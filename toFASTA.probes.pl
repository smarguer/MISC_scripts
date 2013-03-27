#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my %counter;

if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

while ($line=<IN>)
{
my @holder=split('\t',$line);
print OUT ">$holder[0]\n$holder[1]\n";
}

close IN;
close OUT;

