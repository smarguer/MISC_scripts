#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 1) {die "need 1 exonerate output file";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", "$in.bed") or die 'could not open output file';
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
my $out1;
my $out2;

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
  $chr1{$coord[0]}{$holder[1]}="$coord[0]\t$coord[1]\t$holder[1];$holder[2];$holder[3];$holder[4];$holder[8];$holder[9];$holder[10];$holder[11];$holder[12]\t500\t$holder[8]\n";
 }
 elsif ($holder[5] eq "CH2_bases")
 {
  $chr2{$coord[0]}{$holder[1]}="$coord[0]\t$coord[1]\t$holder[1];$holder[2];$holder[3];$holder[4];$holder[8];$holder[9];$holder[10];$holder[11];$holder[12]\t500\t$holder[8]\n";
 }
 elsif ($holder[5] eq "CH3_bases")
 {
  $chr3{$coord[0]}{$holder[1]}="$coord[0]\t$coord[1]\t$holder[1];$holder[2];$holder[3];$holder[4];$holder[8];$holder[9];$holder[10];$holder[11];$holder[12]\t500\t$holder[8]\n";
 }
 elsif ($holder[5] eq "MIT_bases")
 {
  $chr4{$coord[0]}{$holder[1]}="$coord[0]\t$coord[1]\t$holder[1];$holder[2];$holder[3];$holder[4];$holder[8];$holder[9];$holder[10];$holder[11];$holder[12]\t500\t$holder[8]\n";
 }
 elsif ($holder[5] eq "MAT_bases")
 {
  $chr5{$coord[0]}{$holder[1]}="$coord[0]\t$coord[1]\t$holder[1];$holder[2];$holder[3];$holder[4];$holder[8];$holder[9];$holder[10];$holder[11];$holder[12]\t500\t$holder[8]\n";
 }
 elsif ($holder[5] eq "TEL_bases")
 {
  $chr6{$coord[0]}{$holder[1]}="$coord[0]\t$coord[1]\t$holder[1];$holder[2];$holder[3];$holder[4];$holder[8];$holder[9];$holder[10];$holder[11];$holder[12]\t500\t$holder[8]\n";
 }

}

 #print OUT "chrom\tchromStart\tchomEnd\tname\tscore\tstrand\n";

 @sorted = sort { $a <=> $b } keys %chr1;
 foreach $out1 (@sorted)
 {
  foreach $out2 (keys %{$chr1{$out1}})
  {
   print OUT "Chr1\t$chr1{$out1}{$out2}";
  }
 }
 @sorted = ();

 @sorted = sort { $a <=> $b } keys %chr2;
 foreach $out1 (@sorted)
 {
  foreach $out2 (keys %{$chr2{$out1}})
  {
   print OUT "Chr2\t$chr2{$out1}{$out2}";
  }
 }
 @sorted = ();

 @sorted = sort { $a <=> $b } keys %chr3;
 foreach $out1 (@sorted)
 {
  foreach $out2 (keys %{$chr3{$out1}})
  {
   print OUT "Chr3\t$chr3{$out1}{$out2}";
  }
 }
 @sorted = ();

 @sorted = sort { $a <=> $b } keys %chr4;
 foreach $out1 (@sorted)
 {
  foreach $out2 (keys %{$chr4{$out1}})
  {
   print OUT "Chr4\t$chr4{$out1}{$out2}";
  }
 }
 @sorted = ();

 @sorted = sort { $a <=> $b } keys %chr5;
 foreach $out1 (@sorted)
 {
  foreach $out2 (keys %{$chr5{$out1}})
  {
   print OUT "Chr5\t$chr5{$out1}{$out2}";
  }
 }
 @sorted = ();

 @sorted = sort { $a <=> $b } keys %chr6;
 foreach $out1 (@sorted)
 {
  foreach $out2 (keys %{$chr6{$out1}})
  {
   print OUT "Chr6\t$chr6{$out1}{$out2}";
  }
 }
 @sorted = ();


close IN;
close OUT;


