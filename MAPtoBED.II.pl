#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 1) {die "need 1 exonerate output file";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';
########################



my $line;
my $count=0;
my @holder;
my @coord;
my @sorted;
my %chr1;
my %chr2;
my %chr3;
my %chr4;
my %chr5;
my %chr6;

while ($line=<IN>)
{
 $count++;
 chomp ($line);
 @holder = split (/\t/, $line);
 if($holder[1] == 0)
 {next;}
 else
 {
 print "$holder[0]\t$holder[1]\t$holder[2]\n";
 }
}

close IN;


