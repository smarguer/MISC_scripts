#!/usr/bin/perl
use strict;
use warnings;
#Input file
#################################################################################
 
if (@ARGV != 1) {die "need a file";}
(my $in)=@ARGV;
 
open (IN, "$in") or die 'could not find the input file';
#open (OUT, ">", "$in.") or die 'could not open output file';
########################
#Variables.
################################################################################
 
my $line;
my @holder;
my @holder1;
my $count=0; 
my $new=0;
my $i=0;
my $name;
my $start;
my $end;
my $chromStart;
my $chromEnd;
my $score;
my $mis;

while ($line=<IN>)
{
 $count++;
 chomp($line);
 @holder=split(/\t/, $line);
 @holder1=split(/;/, $holder[8]);
 
 $holder1[1]=~ /Name=/;
 $name=$';
 $holder1[2]=~ /P=\"(\d{1,2})-(\d{1,2})\"/;
 if ($holder[6] eq "+")
 {
  $start=$1-1;
  $end=$2;
  $chromStart=$holder[3]-1;
  $chromEnd=$holder[4];
 }
 else
 {
  $start=$2-1;
  $end=$1;
  $chromStart=$holder[4];
  $chromEnd=$holder[3]-1;
 }
 $holder1[3]=~ /Note="M:(\d)/;
 $mis=$1;
 $score=($holder[5]*5)-($mis*4);

 print "vulgar: ".$name." ".$start." ".$end." + ".$holder[0]." ".$chromStart." ".$chromEnd." ".$holder[6]." ".$score." M ".$end." ".$end."\n"; 
}
close IN;
#close OUT;



