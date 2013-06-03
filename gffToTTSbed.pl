#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;
my @holder;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  if($holder[2] ne "gene"){next;}
  if($holder[7] eq "+")
  {
   print "$holder[0]\t$holder[4]\t$holder[4]\t$holder[9]\t$holder[9]\t$holder[7]\n";
  }
  else
  {
   print "$holder[0]\t$holder[3]\t$holder[3]\t$holder[9]\t$holder[9]\t$holder[7]\n";
  }

 
 }


close IN;

