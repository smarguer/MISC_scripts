#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;
my @holder;
my $name;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  if($holder[2] eq "5\'UTR")
  {
   $name="UTR5_".$holder[9];
   print "$holder[0]\t$holder[1]\tgene\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\t$holder[8]\t$name\t$holder[10]\t$holder[11]\t$holder[12]\n";
   print "$holder[0]\t$holder[1]\t$holder[2]\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\t$holder[8]\t$name\t$holder[10]\t$holder[11]\t$holder[12]\n";
  }
  elsif($holder[2] eq "3\'UTR")
  {
   $name="UTR3_".$holder[9];
   print "$holder[0]\t$holder[1]\tgene\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\t$holder[8]\t$name\t$holder[10]\t$holder[11]\t$holder[12]\n";
   print "$holder[0]\t$holder[1]\t$holder[2]\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\t$holder[8]\t$name\t$holder[10]\t$holder[11]\t$holder[12]\n";
  }
  else
  { 
   print "$line\n";
  }
 }


close IN;

