#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 3) {die "need 2 fasta files and a gff";}
(my $CHR,my $TRS,my $gff)=@ARGV;

open (IN, $CHR) or die 'could not find fasta file 1';
open (IN1, $TRS) or die 'could not find fasta 2';
open (IN2, $gff) or die 'could not find gff file';

my $line;
my $line1;
my $line2=<IN2>;
my $randomNumber;
my $chr;
my %read;
my %map;
my %seq;
my $out;
my $len;
my $rev;
my $name=0;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my @holder;
my %chr;
my %trs;
my %five;
my %three;
my %poly;
my %strand;

open (OUT1, ">", "Theoretical_trs_plus.fasta") or die 'could not open output file';
open (OUT2, ">", "Theoretical_trs_minus.fasta") or die 'could not open output file';

while ($line=<IN>)
{
 $count++;
 chomp($line);
 if ($line=~/\>/)
 {
  $name="$line";
  $chr{$name}="A";
 }
 else
 {
  $chr{$name}.=$line;
 }
}

$chr{">CH1_bases"}=substr($chr{">CH1_bases"},1,length($chr{">CH1_bases"}));
$chr{">CH2_bases"}=substr($chr{">CH2_bases"},1,length($chr{">CH2_bases"}));
$chr{">CH3_bases"}=substr($chr{">CH3_bases"},1,length($chr{">CH3_bases"}));
$chr{">CH4_bases"}=substr($chr{">CH4_bases"},1,length($chr{">CH4_bases"}));
$chr{">CH5_bases"}=substr($chr{">CH5_bases"},1,length($chr{">CH5_bases"}));
$chr{">CH6_bases"}=substr($chr{">CH6_bases"},1,length($chr{">CH6_bases"}));

while($line2=<IN2>)
{
 chomp($line2);
 @holder=split(/\t/,$line2);
 $name=">".$holder[9];
 $chr=">CH".$holder[12]."_bases";
 $strand{$name}=$holder[6];
#print "$chr\n";
#print "$name\n";

 if($holder[2] eq "5\'UTR")
 {
  $five{$name}=substr($chr{$chr},$holder[3],($holder[4]-$holder[3]));
  if($holder[6] eq '-')
  {
   $five{$name}=reverse($five{$name});
   $five{$name}=~tr/ACGTacgt/TGCAtgca/;
  }
 $five{$name}=~tr/ACGTacgt/ACGTACGT/;
 }
 if($holder[2] eq "3\'UTR")
 {
  $three{$name}=substr($chr{$chr},$holder[3],($holder[4]-$holder[3]));
  if($holder[6] eq '-')
  {
   $three{$name}=reverse($three{$name});
   $three{$name}=~tr/ACGTacgt/TGCAtgca/;
  }
 $three{$name}=~tr/ACGTacgt/ACGTACGT/;
 }
}

while ($line1=<IN1>)
{
 $count++;
 chomp($line1);
 if ($line1=~/\>/)
 {
  $name="$line1";
  $trs{$name}="A"; 
  unless($five{$name})
  {
   $five{$name}='A';
  }
  unless($three{$name})
  {
   $three{$name}='A';
  }
  if ($name =~ /SP[NABC][CP]/)
  {
   $poly{$name}='AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
  }
  else
  {
   $poly{$name}='A';
  }
 }
 else
 {
  $trs{$name}.=$line1;
 }
}



my $i;

foreach(keys %trs)
{
 $name=$_;
 #$trs{$name}=substr($trs{$name},1,(length($trs{$name})-1));
 #chomp($trs{$name});
 my $test=chop($trs{$name});
 print "$test";
 my $out=$five{$name}.$trs{$name}.$three{$name}.$poly{$name};
 #my $out=$five{$name}.$three{$name};
 
 $out=substr($out,0,(length($out)-2));
 if ($strand{$name} eq '+')
 { 
  print OUT1 "$name\n$out\n";
 } 
 else
 {
  print OUT2 "$name\n$out\n";
 }
}

close IN;
close IN1;
close IN2;
close OUT1;
close OUT2;



















