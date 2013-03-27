#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 4) {die "need 4 file names";}
(my $reads, my $in, my $out, my $out2)=@ARGV;

open (IN, $reads) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the chromosome file';
#open (IN2, $reads) or die 'could not find the chromosome file';
open (OUT, ">", $out) or die 'could not open output file';
open (OUT2, ">", $out2) or die 'could not open second output file';

########################


my $line;
my $line1;
my $line2;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my $chrom;
my $length;
my $holder;
my @holder;
my @read;
my %reads;
my %reads1;


#####################
#while ($line1=<IN1>)
#{
#$count1++;
#$chrom = $chrom.$line1;
#substr($line1,10);
#$chrom=$line1;
#}#
#$length=$count1*60;
#print "contig has been parsed\n";
#####################
while ($line=<IN>)
{
        $count2++;
        if ($count2 == 1)
        {
        chomp($line);
        $holder=substr($line,1);
        }
        elsif ($count2 == 2)
        {
        $count3++;
        chomp($line);
        $reads{$holder}=$line;
        $count2=0;
        #print "$holder\n$reads{$holder}\n";
        }
#!/usr/bin/perl
}
while ($line1=<IN1>)
{
        
        $count++;
        
        chomp ($line1);

        @holder = split (/ /, $line1);
        unless ($holder[0]){next;}
        if ($holder[0] ne "vulgar:"){next;}
        $reads1{$holder[1]}=0;
        if ($reads{$holder[1]})
        {
        $reads1{$holder[1]}++;
        #print "unless";
        #next;
        #maximise match
        ################################
        #if (($holder[2]*$holder[3])!= 0)
        #{
        #print OUT2 "$line1\t$reads{$holder[1]}\n";
        #next;
        #}
        
        if ($holder[4] eq "-")
        {
        if ((substr($reads{$holder[1]},$holder[2],6) eq "TCGTAT") && ($holder[9] <= ($holder[2]*5)) && ($holder[9] >= (($holder[2]*5)-9)))
        {
        print OUT "$line1\t$reads{$holder[1]}\n";
        }
        else
        {
        print OUT2 "$line1\t$reads{$holder[1]}\n";
        }
        }
        elsif ($holder[4] eq "+")
        {
        #@read=split (//,$reads{$holder[1]});
        #$end=$holder[3]-1;
        #print "IN!!!\n";
        if ((substr($reads{$holder[1]},$holder[3],6) eq "TCGTAT") && ($holder[9] <= ($holder[3]*5)) && ($holder[9] >= (($holder[3]*5)-9)))
        {
        print OUT "$line1\t$reads{$holder[1]}\n";
        }
        else
        {
        print OUT2 "$line1\t$reads{$holder[1]}\n";
        }
        }
        }
        
}

for my $out1 (keys %reads)
{
if ($reads1{$out1} && $reads1{$out1} > 0)
{
next;
}
else
{
print OUT2 "vulgar: ".$out1." UNMAPPED ".$reads{$out1}."\n";
}
}

close IN;
close IN1;
close OUT;
close OUT2;



