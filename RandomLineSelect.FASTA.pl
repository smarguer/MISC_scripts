#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 2) {die "need two files and a number of reads and an read option [FASTA/MAP]";}
(my $in, my $number)=@ARGV;


open (IN, $in) or die 'could not find the fasta file';

my $line;
my $line1;
my $randomNumber;
my %read;
my %map;
my %seq;
my $out;
my $name;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my @holder;

$in=~/(\.fasta)/;
my $in1=$`;
$in1=~ s{.*/}{}; 
open (OUT, ">", $in1.'_'.$number.'.fasta') or die 'could not open output file';

while ($line=<IN>)
{
 if (($count==0) && ($line!~/\>/))
 {
  print "header?\n";
  die;
 }
 chomp $line;
 if ($line=~/\>/)
 {
  $count++;
  $randomNumber=int(rand(1000000000));
  $read{$randomNumber}=$line;
 }
 else
 {
  $read{$randomNumber}.="\n$line";
  $randomNumber=0;
 }
}
#print "fasta read\n";

for $out (sort {$a<=>$b} keys %read)
{
 $count2++;
 last if ($count2 > $number);
 print OUT $read{$out}."\n";
}

close IN;
close OUT;
