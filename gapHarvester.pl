#!/usr/bin/perl


use strict;
use warnings;
use POSIX;
my $line;
my $line1;
my $count=0;
my $count1=0;
my $holder;
my @holder;
my $pos;
my $mpos;
my $score=0;
my $chrom='start';
my $sense;
my $readlength=54;
my %readlength;
my $mis=10;
my $len;
my $steps;
my $out1;
my $out2;
my %read;
my %count;
my %gap;
my %end;

#######################
#Takes input
#######################

if (@ARGV != 2) {die "I need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (OUT, ">", $out) or die 'could not open output file';

######################################
#parses Exonerate output
######################################

while ($line=<IN>)
{
	
	$count++;
	$score=0;
	
	chomp ($line);

	@holder = split (/\t/, $line);
	unless ($holder[0]){next;}
	if ($holder[5] ne $holder[11]){next;}
	if ($gap{$holder[6]})
	{
	$count{$holder[6]}++;
	$gap{$holder[6]}[$count{$holder[6]}]=abs($holder[1]-$end{$holder[6]}[($count{$holder[6]}-1)]);	
	$end{$holder[6]}[$count{$holder[6]}]=$holder[2];
	}	
	else
	{
	$count{$holder[6]}=0;
	$gap{$holder[6]}[$count{$holder[6]}]=0;	
	$end{$holder[6]}[$count{$holder[6]}]=$holder[2];
	}
}		
####################################################################################
print OUT "1\t2\t3\t4\t5\t6\t7\t8\t9\t10\t11\n";
for $out1 (sort keys %gap)
{
$out2=join("\t",@{$gap{$out1}});
print OUT "$out1\t".($#{$gap{$out1}}+1)."\t$out2\n";		
}


close IN;
close OUT;
