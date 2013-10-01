#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;
my $out=0;
my @holder;
my @holder1;
my %hold;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

while ($line=<IN>)
 {
  $count++;

  @holder = split (/ /, $line);
  shift @holder;
  print join ' ',@holder;
 }
close IN;


