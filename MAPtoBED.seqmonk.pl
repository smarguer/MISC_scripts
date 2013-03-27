#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 1) {die "need 1 exonerate output file";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", "$in.seqmonk.bed") or die 'could not open output file';
########################



my $line;
my $count=0;
my @holder;
my @coord;
my @sorted;
my %chr1;
my %chr2;
my %chr3;
my %chr4;
my %chr5;
my %chr6;

while ($line=<IN>)
{
 $count++;
# print "$count\n";
 chomp ($line);
 @holder = split (/ /, $line);


 @coord= ($holder[6],$holder[7]);
 if ($coord[0] > $coord[1])
 {
  @coord=reverse(@coord);
 }

 if ($holder[5] eq "CH1_bases")
 {
  $chr1{$coord[0]}="$coord[0]\t$coord[1]\t$holder[1]\t1\t$holder[8]\n";
 }
 elsif ($holder[5] eq "CH2_bases")
 {
  $chr2{$coord[0]}="$coord[0]\t$coord[1]\t$holder[1]\t1\t$holder[8]\n";
 }
 elsif ($holder[5] eq "CH3_bases")
 {
  $chr3{$coord[0]}="$coord[0]\t$coord[1]\t$holder[1]\t1\t$holder[8]\n";
 }
 elsif ($holder[5] eq "MIT_bases")
 {
  $chr4{$coord[0]}="$coord[0]\t$coord[1]\t$holder[1]\t1\t$holder[8]\n";
 }
 elsif ($holder[5] eq "MAT_bases")
 {
  $chr5{$coord[0]}="$coord[0]\t$coord[1]\t$holder[1]\t1\t$holder[8]\n";
 }
 elsif ($holder[5] eq "TEL_bases")
 {
  $chr6{$coord[0]}="$coord[0]\t$coord[1]\t$holder[1]\t1\t$holder[8]\n";
 }

}

 #print OUT "chrom\tchromStart\tchomEnd\tname\tscore\tstrand\n";

 @sorted = sort { $a <=> $b } keys %chr1;
 foreach(@sorted)
 {
  print OUT "chrI\t$chr1{$_}";
 }
 @sorted = ();
 @sorted = sort { $a <=> $b } keys %chr2;
 foreach(@sorted)
 {
  print OUT "chrII\t$chr2{$_}";
 }
 @sorted = ();
 @sorted = sort { $a <=> $b } keys %chr3;
 foreach(@sorted)
 {
  print OUT "chrIII\t$chr3{$_}";
 }
 @sorted = ();
 @sorted = sort { $a <=> $b } keys %chr4;
 foreach(@sorted)
 {
  print OUT "chrIV\t$chr4{$_}";
 }
 @sorted = ();
 @sorted = sort { $a <=> $b } keys %chr5;
 foreach(@sorted)
 {
  print OUT "chrV\t$chr5{$_}";
 }
 @sorted = ();
 @sorted = sort { $a <=> $b } keys %chr6;
 foreach(@sorted)
 {
  print OUT "chrVI\t$chr6{$_}";
 }
 @sorted = ();

close IN;
close OUT;


