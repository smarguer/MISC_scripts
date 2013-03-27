#!/usr/bin/perl


use strict;
use warnings;


if (@ARGV != 4) {die "need a transcripts input, a cds input, a gff file, and an output file name";}
(my $in, my $in2, my $gff, my $output)=@ARGV;

open (IN, $gff) or die 'could not find the gff file';
open (IN1, $in) or die 'could not find the transcripts input';
open (IN2, $in2) or die 'could not find the cds input';
open (OUT, ">", $output) or die 'could not open output file';
open (OUT1, ">", $output.".not") or die 'could not open output file 2';

my $line;
my $line1=<IN1>;
my $line2=<IN2>;
my $count=0;
my $count1=0;
my $count3=0;
my $not;
my %CDS;
my %INT;
my %startG;
my %endG;
my %chrG;
my %strandG;
my %count;
my %countint;
my %readmatch;
my @holder;
my @holder1;
my @not;
my $i;
my $k;
my $chr;
my $end;
my $mpos;
my $lchr;
my $nchr;
my $total;
my $totalint;
###############################################################
#produce junctions data structure from gff
###############################################################

print "preparing junctions data structure.\n";
while ($line=<IN>)
{
	chomp ($line);
	@holder= split (/\t/,$line);
	if ($holder[2] eq 'gene')
	{
		$startG{$holder[9]}=$holder[3];
		$endG{$holder[9]}=$holder[4];
		$strandG{$holder[9]}=$holder[6];
		$chrG{$holder[9]}=$holder[12];
	}
	elsif ($holder[2] eq 'CDS')
	{
		unless ($CDS{$holder[9]})
		{
			$count=-1;
		}
		$count++;
		$CDS{$holder[9]}[$count]=$holder[4]-$holder[3]+1;	

	}
	elsif ($holder[2] eq 'intron')
	{
		unless ($INT{$holder[9]})
                {
                        $count1=-1;
                }
                $count1++;
                $INT{$holder[9]}[$count1]=$holder[4]-$holder[3]-1;
	
	}

}


for my $out (sort keys %CDS)
{
$totalint=0;

#leave out intron-less genes
if ($#{$CDS{$out}} == 0){
#print "####################$out#############\n";
next;}


if ($strandG{$out} eq '-')
{
	@{$CDS{$out}} = reverse(@{$CDS{$out}});
	if ($INT{$out}) {@{$INT{$out}} = reverse(@{$INT{$out}});}
}

$end=$#{$CDS{$out}}-1;
for my $i (0..$end)
{
$total += $_ foreach @{$CDS{$out}}[0..$i] ;
my $j=$i+1;
#$total=$total+$j;
if ($INT{$out}[$i])
{
$totalint += $INT{$out}[$i];
}

$count{$out}{$j}{POS}=$total+1;
$count{$out}{$j}{COUNTp}=0;
$count{$out}{$j}{COUNTm}=0;
#print OUT "JUN\t$out.".$j."\t$CDS{$out}[$i]\t$count{$out}{$j}{POS}\n";

if ($INT{$out}[$i])
{
$countint{$out}{$j}{START}=$total+$totalint-$INT{$out}[$i]+1;
$countint{$out}{$j}{END}=$total+$totalint;
$countint{$out}{$j}{COUNTp}=0;
$countint{$out}{$j}{COUNTm}=0;
#print OUT "INT\t$out.".$j."\t$countint{$out}{$j}{START}\t$countint{$out}{$j}{END}\n";
}

#$count{$out}{$i}{NOT}=0;
$total=0;

} 
#print "@{$CDS{$out}}\n";
}



close IN;


##########################################################
#Analyse .ALLtrs exonerate output file. Counts transreads
##########################################################

print "Analysing transreads.\n";

while ($line1=<IN1>)
{
        
        
        chomp ($line1);

        @holder = split (/ /, $line1);
        unless ($holder[0]){next;}
        if ($holder[0] ne "vulgar:"){next;}
	if ($holder[8] eq '+')
	{
		$not=0;
		for $i (keys %{$count{$holder[5]}})
		{
			#print "$i";
			if (($holder[6] < $count{$holder[5]}{$i}{POS}) &&
			($holder[7] > $count{$holder[5]}{$i}{POS}))
			{
				$count{$holder[5]}{$i}{COUNTp}++;
				$not++;
			}
		}  
	}	

	elsif ($holder[8] eq '-')
        {
                $not=0;
                for $i (keys %{$count{$holder[5]}})
                {
                        if (($holder[6] > $count{$holder[5]}{$i}{POS}) &&
                        ($holder[7] < $count{$holder[5]}{$i}{POS}))
                        {
                                $count{$holder[5]}{$i}{COUNTm}++;
                                $not++;
                        }
                }
        }

	if ($not==0)
	{
	#	$count{$holder[5]}{$holder[1]}{NOT}=1;
	push(@not, $holder[1]);
	}
}
#####################################################################
#Analyse exonerate .ALLcds file counts exon-intron junction reads
#####################################################################

print "Analysing exon-intron junctions.\n";

$i=0;

while ($line2=<IN2>)
{
        $count3++;
        chomp ($line2);
        @holder= split (/ /,$line2);
        unless ($holder[0]){next;}
        if ($holder[0] ne "vulgar:"){next;}
	unless ($countint{$holder[5]}){next;}
	
	if ($holder[8] eq '+')
        {
	unless ($countint{$holder[5]}){next;}
                $not=0;
                for $i (keys %{$countint{$holder[5]}})
                {
                        #print "$i";
                        if ((($holder[6] < $countint{$holder[5]}{$i}{START}) &&
                        ($holder[7] > $countint{$holder[5]}{$i}{START})) ||
			(($holder[6] < $countint{$holder[5]}{$i}{END}) &&
                        ($holder[7] > $countint{$holder[5]}{$i}{END})))
                        {
                                $countint{$holder[5]}{$i}{COUNTp}++;
                                $not++;
                        }
                }
        }


	elsif ($holder[8] eq '-')
        {
                $not=0;
                for $i (keys %{$count{$holder[5]}})
                {
                        if ((($holder[6] > $countint{$holder[5]}{$i}{START}) &&
                        ($holder[7] < $countint{$holder[5]}{$i}{START})) ||
			(($holder[6] > $countint{$holder[5]}{$i}{END}) &&
			($holder[7] < $countint{$holder[5]}{$i}{END})))
                        {
                                $countint{$holder[5]}{$i}{COUNTm}++;
                                $not++;
                        }
                }
        }






#print "$count3\b\b\b\b\b\b\b\b";
}









####################################################################
#Wrinting output
####################################################################

print "Writing output file.\n";



print OUT1 join("\n",@not)."\n"."$#not"."\n";

for my $out (sort keys %count)
{
	for my $i (sort keys %{$count{$out}})
	{
	print OUT "$out.".$i."\t$out\t$i\t$count{$out}{$i}{POS}\t$countint{$out}{$i}{START}\t$countint{$out}{$i}{END}\t$count{$out}{$i}{COUNTp}\t".($countint{$out}{$i}{COUNTp}/2)."\t$count{$out}{$i}{COUNTm}\t".($countint{$out}{$i}{COUNTm}/2)."\n";
	} 
}
close IN1;
close IN2;
close OUT;
close OUT1;
