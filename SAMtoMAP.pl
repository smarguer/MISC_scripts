#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;

my $chr;
my $start;
my $end;

my @holder;
my @holder1;

my %sort;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  @holder1 = split (/;/, $holder[0]);
  $holder[2] =~ /chr/;
  $chr="CH".$'."_bases"; 
  $start=$holder[3]-1;
  $end=$start+$holder1[12];
  if($holder1[2]==0)
  {
   $sort{$holder1[0]}="$holder1[1]vulgar: $holder1[3];$holder1[4];$holder1[5] $holder1[6] $holder1[7] $holder1[8] $chr $start $end $holder1[9] $holder1[10] $holder1[11] $holder1[12] $holder1[13]\n";
  }   
  elsif($holder1[2]==1)
  {
   $sort{$holder1[0]}="$holder1[1]vulgar: $holder1[3];$holder1[4];$holder1[5] $holder1[6] $holder1[7] $holder1[8] $chr $end $start $holder1[9] $holder1[10] $holder1[11] $holder1[12] $holder1[13]\n";
  }
 }
 
 for my $out (sort {$a <=> $b} keys %sort)
 {
  print $sort{$out};
 }


close IN;

