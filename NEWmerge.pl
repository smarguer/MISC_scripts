#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 1) {die "need 2 file names";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", "$in.merged.gff") or die 'could not open output file';
########################


my $line=<IN>;
my @holder;

my $prevSTART=0;
my $prevEND=0;
my $prevSTRAND='init';
my $prevCHR=1;

my $outSTART=0;
my $outEND=0;
my $outSTRAND='init';
my $outCHR=1;
my $outNAME='init';
my $outID; 
my $cutoff = 50;
my $out="seqname\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattributes\tName\torf_classification\tgene\tchr\n";



while ($line=<IN>)
{
	
 chomp ($line);

 @holder = split (/\t/, $line);
 if ($holder[2] ne 'gene')
 {
  next;
 } 
 
 if (($holder[3] < $prevSTART) && ($holder[12] == $prevCHR))
 {
  print "$line\n";
  die 'gff not properly sorted...';
 }
 
 elsif ((($holder[3] < $prevEND) || (($holder[3]-$prevEND) < $cutoff)) && ($holder[12] == $prevCHR))
 {
  if ($holder[4] > $prevEND)
  {
  $outEND=$holder[4];
  }
  if ($outSTRAND eq 'init')
  {
   $outSTRAND=$holder[6];
  }
  else
  {
   $outSTRAND.=";$holder[6]";
  }
  if ($outNAME eq 'init')
  {
   $outNAME=$holder[9];
  }
  else
  {
   $outNAME.=";$holder[9]";
  }
  
  $outID="NEW.$outSTART.$outEND.$holder[12]";
  $out="chr\tWT_ME_RRP6\tgene\t$outSTART\t$outEND\t\.\t$outSTRAND\t\.\t$outNAME\t$outID\tNA\tNA\t$holder[12]\n";
 }
 else
 {
  print OUT "$out";
  $outSTART=$holder[3];
  $outEND=$holder[4];
  $outNAME=$holder[9];
  $outID=0;
  $outSTRAND=$holder[6];
  #$outCHR=$holder[12];
  $out="$line\n";
 }

 $prevSTART=$holder[3];
 $prevEND=$outEND;
 $prevSTRAND=$holder[6];
 $prevCHR=$holder[12];

}

	
close IN;
close OUT;
