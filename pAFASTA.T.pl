#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0;
my $holder;

if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

while ($line=<IN>)
{
	$count++;
	if ($count == 1)
	{
	$holder=$line;
	}
	elsif ($count == 2)
	{
	if (($line =~ /^T{10}/) && ($line !~ /T{30}/)) 
	{
	chomp ($line);
	$count1++;
	$line = reverse($line);
        $line =~ tr/ACGTacgt/TGCAtgca/;
	print OUT "$holder$line\n";
	$count=0;
	}
	else
	{
	$count=0;
	}
	}
	
}
print "$count1\n";

close IN;
close OUT;

