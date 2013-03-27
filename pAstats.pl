#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0;
my $holder;
my $pos;
my %count;
my %score;

if (@ARGV != 3) {die "need 2 file names, and a format option value";}
(my $in, my $out, my $format)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
#######################################################
#from mummer
#######################################################
if ($format eq 'M')
{
while ($line=<IN>)
{
	$count++;
	if ($line =~ m/^\>/)
	{
	chomp($line);
	my @holder=split(/\t/,$line);
	if ($count{$holder[1]})
	{
	$count{$holder[1]}++;
	$score{$holder[1]} = $score{$holder[1]}+$holder[2];
	}
	else
	{
	$count{$holder[1]} = 1;
	$score{$holder[1]} = $holder[2];
	}
	#print "$holder";
	}
	
}
}
########################################################
#from exonerate
########################################################
if ($format eq 'E')
{
while ($line=<IN>)
{
	$count++;
	chomp($line);
	my @holder=split(/\t/,$line);
	
	if ($count{$holder[1]})
	{
	$count{$holder[1]}++;
	$score{$holder[1]} = $score{$holder[1]}+$holder[2];
	}
	else
	{
	$count{$holder[1]} = 1;
	$score{$holder[1]} = $holder[2];
	}
	#print "$holder";
	
	
}
}
#################################################
#format output
#################################################
for my $out (sort keys %count)

{
print OUT "$out\t$count{$out}\t$score{$out}\n";
}




print "$count1\n";

close IN;
close OUT;

