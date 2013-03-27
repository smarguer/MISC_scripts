#!/usr/bin/perl
use strict;
use warnings;
#Input file
################################################################################

if (@ARGV != 3) {die "need 3 file names";}
(my $in, my $in1,  my $out1)=@ARGV;

open (IN, $in) or die 'could not find the first input file';
open (IN1, $in1) or die 'could not find the second input file';
open (OUT, ">", $out1) or die 'could not open output file';

####################
my $line;
my $line1;
my $out;
my $count0;
my $count1;
my $count2;
my $count3;
my $count4;
my %pair1;
my %pair2;
my %pair1c;
my %pair2c;

my @holder;

while ($line=<IN>)
{
        chomp($line);
        @holder=split(/\s/, $line);
	chop($holder[1]);
 	#print "$holder[1]\n$holder[6]\n";	
	if ($pair1{$holder[1]})
	{
	$pair1c{$holder[1]}++;
	}
	else
	{
	$pair1{$holder[1]}=$holder[6];
	$pair1c{$holder[1]}=1;
	}
}


while ($line1 = <IN1>)
{
        chomp($line1);
        @holder=split(/\s/, $line1);
        chop($holder[1]);
       #print "$holder[1]\n$holder[6]\n";
	if ($pair2{$holder[1]})
        {
        $pair2c{$holder[1]}++;
        }
        else
        {
        $pair2{$holder[1]}=$holder[6];
        $pair2c{$holder[1]}=1;
        }
}
close IN;
close IN1;

for $out (keys %pair1)
{
if ($pair1{$out} && $pair2{$out})
{
$count0++;
print OUT "$out\t$pair1{$out}\t$pair2{$out}\t".($pair2{$out}-$pair1{$out})."\t$pair1c{$out}\t$pair2c{$out}\n";
}
elsif ($pair1{$out} && !($pair2{$out}))
{
$count1++;
}
}
for $out (keys %pair2)
{
$count3++;
if ($pair2{$out} && !($pair1{$out}))
{
$count4++;
} 
}
print "$count0\n$count1\n$count2\n$count3\n$count4\n";

close OUT;

