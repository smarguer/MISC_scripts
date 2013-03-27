#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my %base;
my @holder;
my @holder1;
my $i;
my $pos;
my $mpos;
my $lchr;
my $nchr;

if (@ARGV != 3) {die "need 2 file names, and a chromosome";}
(my $in, my $out, my $chr)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

if ($chr==1)
{
#chr1
$lchr=5579133;
$nchr = "CH1_bases";
}
elsif ($chr==2)
{
#chr2
$lchr=4539804;
$nchr = "CH2_bases";
}
elsif ($chr==3)
{
#chr3
$lchr=2452883;
$nchr = "CH3_bases";
}
#print "preparing hash...\n";
for ($i =1; $i <= (2 * $lchr); $i++)
{
$base{$i}=0;
#print "$i";
}

#print "analysing reads...\n";

while ($line=<IN>)
{
	
	chomp ($line);
	@holder = split (/ /, $line);
	if ($holder[0] ne "vulgar:"){next;}
	if ($holder[5] ne $nchr){next;}
	$count++;
	@holder1= ($holder[6],$holder[7]);
	@holder1= sort (@holder1);
 	
	if ($holder[8] eq "-")
	{
	$holder1[0]=$holder1[0]+$lchr;
	$holder1[1]=$holder1[1]+$lchr;
	}		
	
	foreach $pos ($holder1[0] .. $holder1[1])
	{
	$base{$pos}++;
	}
#print "$count\b\b\b\b\b\b\b\b";
}
	
#print "printing...\n";

for my $out (sort keys %base)
{
print OUT "$out\t$base{$out}\n";
}
#to coorect for the missing base...
#print OUT "0\n";

close IN;
close OUT;

