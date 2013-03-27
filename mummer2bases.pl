#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $i=0;
my %pos;


if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the coordinates';
open (OUT, ">", $out) or die 'could not open output file';

while ($i < 5672131)
{
$i++;
$pos{$i}=0;
}
  
while ($line=<IN>)
{
	$count++;
	
	 next if ($line =~ m/^\>/); 
	

	

	
	#print "test";		
	my @holder=split(/\s/,$line);
	#print "$holder[1]\n";			
	$pos{$holder[0]}=$holder[1];
	
}

for my $out (sort keys %pos)
{
	print OUT "$out\t$pos{$out}\n";
}


close IN;
close OUT;

