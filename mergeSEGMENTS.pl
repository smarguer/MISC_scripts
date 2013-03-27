#!/usr/bin/perl
use strict;
use warnings;
#Input file
################################################################################

if (@ARGV != 2) {die "need a  name and a gap size";}
(my $in, my $in1)=@ARGV;

open (IN, "$in.SEG") or die 'could not find the input file';
open (OUT, ">", "$in.".$in1."SEG") or die 'could not open output file';
########################
#Variables.
################################################################################

my $line;
my $line1=0;
my $prevS= 0;
my $prevE= 0;
my $gap= $in1;
my $actgap=0;
my $length= 0;
my $sig= 0;
my $sigout=0;
my $prevStrand= 'init';
my $prevChrom= 'init';
my $a=0;
my @holder;

while ($line=<IN>)
{
  	
 chomp($line);
 @holder=split(/\t/, $line);

 #$length=$holder[2];
 $actgap=$holder[0]-$prevE+1;
 if (($actgap < $gap) && ($prevStrand eq $holder[4]) && ($prevChrom eq $holder[5]))
 {
  if ($prevS==0)
  {
   $prevS = $holder[0];
   $length = 0;	
   $sig= 0;			
   $a=1;
  }
  
  $length= $holder[1]-$prevS+1; 		
  $sig= $sig+($holder[3]*$holder[2]);
  $sigout=sprintf("%.1f",($sig/$length));
  $line1="$prevS\t$holder[1]\t$length\t$sigout\t$holder[4]\t$holder[5]";
  $prevS= $prevS;
  $prevE= $holder[1];
 }	
 else
 {
  print OUT "$line1\n";
  $prevS= $holder[0];	
  $prevE= $holder[1];
  $line1 = $line;
  $length = $holder[2]+1;
  $sig = $holder[3]*$length;
 }	
	
 $prevStrand = $holder[4];
 $prevChrom= $holder[5];
}


close IN;
close OUT;
