#!/usr/bin/perl

use strict;
use warnings;

my $line;
my $count=0;
my @holder;
my $read;
my %read;
if (@ARGV != 1) {die "wrong number of files";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';

while ($line=<IN>)
 {
  $count++;
  chomp ($line);

  @holder = split (/\t/, $line);
  
  if($holder[3] eq "+")
  {
   $read=$holder[1].$holder[8];
  }
  elsif ($holder[3] eq '-')
  {
   $read=$holder[2].$holder[8];
  }
  if(exists $read{$read})
  {
   next;
  }
  else
  {
   $read{$read}=1;
   print "$line\n";
  }
 }


close IN;

