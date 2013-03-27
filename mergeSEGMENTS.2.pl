#!/usr/bin/perl
use strict;
use warnings;
#Input file
################################################################################
##Includes score limit on scores ratios when fusing.
################################################################################
#
if (@ARGV != 4) {die "need a  name and a gap size, a score ratio, and option tag";}
(my $in, my $in1, my $scoreLimit, my $option)=@ARGV;
my $cutoff=32;
if ($option !~ /[RC]/){die "option has to be R (for cut off on scores ratio), or C (for simple cut off)";}
open (IN, "$in.SEG") or die 'could not find the input file';
open (OUT, ">", $in.'.'.$option.$scoreLimit.'.'.$in1."SEG") or die 'could not open output file';
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
#my $a=0;
my @holder;
my @scores;
my $scoreRatio;
my $scoreTest;
my $fuse;


while ($line=<IN>)
{
  	
 my $scoreTest=0;
 chomp($line);
 @holder=split(/\t/, $line);

 $actgap=$holder[0]-($prevE+1);
###
  @scores=($holder[3],$sigout);
  @scores=sort { $a <=> $b } @scores;
#print join("\t",@scores)."\n";
  if ($scores[0]==0)
  {
   $scoreRatio=0;
  }
  else
  { 
   $scoreRatio=$scores[1]/$scores[0];
  }
###

 if(($option eq "R") && ($scoreRatio < $scoreLimit))
 {
  $scoreTest=1;
 }
 elsif (($option eq "C") && ($scores[0] < $scoreLimit) && ($scores[1] < $scoreLimit))
 {
  $scoreTest=1;
 }
 else
 {
  $scoreTest=0;
 }

 if (($actgap < $gap) && ($prevStrand eq $holder[4]) && ($prevChrom eq $holder[5]) && ($scoreTest==1))
 {
#  print "$scoreTest\t$actgap\t".join("\t",@scores)."\t$scoreRatio\n";

  $fuse=1;
  if ($prevS==0)
  {
   $prevS = $holder[0];
   $length = 0;	
   $sig= 0;			
   #$a=1;
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
  $fuse=0;
#  print "$scoreTest\t$actgap\t".join("\t",@scores)."\t$scoreRatio\n";
  print OUT "$line1\n";
##
#print OUT "$actgap\t".join("\t",@scores,$scoreRatio)."\n";
##
  $prevS= $holder[0];	
  $prevE= $holder[1];
  $line1 = $line;
  $length = $holder[2]+1;
  $sig = $holder[3]*$length;
  $sigout=$holder[3];
 }	
	
 $prevStrand = $holder[4];
 $prevChrom= $holder[5];
}
#print "$fuse\n";
#if($fuse==1)
#{
 print OUT "$line1\n";
#}
#elsif($fuse==0)
#{
# print OUT "$line1\n";
#}

close IN;
close OUT;
