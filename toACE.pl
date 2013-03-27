#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 4) {die "need 4 file names";}
(my $in, my $out, my $chr, my $reads)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (IN1, $chr) or die 'could not find the chromosome file';
open (IN2, $reads) or die 'could not find the chromosome file';
open (OUT, ">", $out) or die 'could not open output file';
########################


my $line;
my $line1=<IN1>;
my $line2;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my $chrom;
my $length;
my $holder;
my @holder;
my %reads;
my $as;
my $co;
my %af;
my %bq;
my %bs;
my %rd;
my %qa;
my %ds; 
my $pos;

#####################
while ($line1=<IN1>)
{
$count1++;
$chrom = $chrom.$line1;
#substr($line1,10);
#$chrom=$line1;
}#
$length=$count1*60;
print "contig has been parsed\n";
#####################
while ($line2=<IN2>)
{
	$count2++;
	if ($count2 == 1)
	{
	chomp($line2);
	$holder=substr($line2,1);
	}
	elsif ($count2 == 2)
	{
	$count3++;
	chomp($line2);
	$reads{$holder}=$line2;
	$count2=0;
	#print "$holder\n$reads{$holder}\n";
	}

#print "$holder\n\n";
}
print "reads sequences have been processed\n";
#####################
while ($line=<IN>)
{
	
	chomp ($line);

	@holder = split (/ /, $line);
	
	if ($holder[0] ne "vulgar:"){next;}
	#if ($bq{$holder[1]}){print "non-unique!!!!!\n";}


####################		

		if ($holder[8] eq "+")
		{
		$count++;
		$pos=$holder[6] + 1;
		$bq{$holder[1]}=40;
		$af{$holder[1]}="AF ".$holder[1]." U $pos";
		$rd{$holder[1]}="RD ".$holder[1]." 30 0 0";
		$qa{$holder[1]}="QA 1 30 1 30";
		$ds{$holder[1]}="DS CHROMAT_FILE: ".$holder[1]." PHD_FILE ".$holder[1].".phd.1 TIME: Fri Oct 17 16:47:40 2008";
		}
		if ($holder[8] eq "-")
		{
		$count++;
		$reads{$holder[1]} = reverse($reads{$holder[1]});
        	$reads{$holder[1]} =~ tr/ACGTacgt/TGCAtgca/;
		#for pA
		$pos=$holder[6] - (36 - $holder[2]);
		####
		#for tot
		#$pos=$holder[7] + 1;
		####
		$bq{$holder[1]}=40;
		$af{$holder[1]}="AF ".$holder[1]." C $pos";
		$rd{$holder[1]}="RD ".$holder[1]." 30 0 0";
		$qa{$holder[1]}="QA 1 30 1 30";
		$ds{$holder[1]}="DS CHROMAT_FILE: ".$holder[1]." PHD_FILE ".$holder[1].".phd.1 TIME: Fri Oct 17 16:47:40 2008";
		}
		else
		{
		next;
		}
}
################
$count=scalar keys %bq; #hack until multiple hits solved...

$as="AS 1 ".$count;
$co="CO chr1 ".$length." ".$count." 1 U";
print "mapping data have been processed\n";
################
print "printing...\n";


print OUT "$as\n\n$co\n$chrom\n\n";

print OUT "BQ\n\n";

for my $out (sort keys %bq)
{
print OUT "$af{$out}\n";
}

print OUT "BS\n\n";


for my $out (sort keys %bq)
{
print OUT "$rd{$out}\n$reads{$out}\n\n$qa{$out}\n$ds{$out}\n\n";
}

print "finished printing\n\n";

close IN;
close IN1;
close IN2;
close OUT;
