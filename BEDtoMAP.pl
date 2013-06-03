#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;
my @holder;
my %sort;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  @holder1 = split (/;/, $holder[3]);
  if($holder1[2]==0)
  {
   $sort{$holder1[0]
  }   
 }


close IN;

