#!/usr/bin/perl

use strict;
use warnings;

my $count=0;
my @holder;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

my $line=<IN>;

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  if ($holder[2] eq "CDS")
  {
   print "$holder[0]\t$holder[1]\t$holder[2]\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\tParent=$holder[9];Note=$holder[8]\n"
  }
  else
  {
   print "$holder[0]\t$holder[1]\t$holder[2]\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\tID=$holder[9];Name=$holder[9];Note=$holder[8]\n"
  }
 }


close IN;

