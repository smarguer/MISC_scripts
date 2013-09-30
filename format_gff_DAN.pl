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
  if ($count > 1)
  {
   @holder = split (/\t/, $line);
   $holder[12]=substr $holder[12],3;
   $holder[8]="No comment";
   $holder[2]="gene";
   print join("\t",@holder)."\n";
   $holder[2]="CDS";
   print join("\t",@holder)."\n";
  }
  else
  {
   print "$line\n";
  }
 }


close IN;

