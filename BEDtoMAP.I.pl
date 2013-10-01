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
  chomp ($line);

  @holder = split (/\t/, $line);
  @holder1 = split (/;/, $holder[3]);
  if($holder1[2]==0)
  {
   print "$holder1[0] $holder1[1]vulgar: $holder1[3];$holder1[4];$holder1[5] $holder1[6] $holder1[7] $holder1[8] CH".substr($holder[0],3).'_BASES'." $holder[1] $holder[2] $holder1[9] $holder1[10] $holder1[11] $holder1[12] $holder1[13]\n";
   #print $sort{$holder1[0]};
  }
  elsif($holder1[2]==1)
  {
   print "$holder1[0] $holder1[1]vulgar: $holder1[3];$holder1[4];$holder1[5] $holder1[6] $holder1[7] $holder1[8] CH".substr($holder[0],3).'_BASES'." $holder[2] $holder[1] $holder1[9] $holder1[10] $holder1[11] $holder1[12] $holder1[13]\n";

   #print $sort{$holder1[0]};
  }
 }
#for ($out=1;$out <= keys %hold;$out++)
#for ($out=1;$out <= 100;$out++)
#{
#print "$out\n";
# if(exists($hold{$out}))
# {
#  print $hold{$out};
# }
#}

close IN;


