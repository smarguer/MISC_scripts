#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;
my @holder;
my $cutoff=100;
my %chr;

if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';
$chr{"chr1"}=5579133-$cutoff;
$chr{"chr2"}=4539804-$cutoff;
$chr{"chr3"}=2452883-$cutoff;

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  
  unless(($holder[1] < $cutoff)||($holder[2] > $chr{$holder[0]})||($holder[0] eq "chr4")||($holder[0] eq "chr5")||($holder[0] eq "chr6"))
  {
   print "$line\n";
  }
 }


close IN;

