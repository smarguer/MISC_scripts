#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 1) {die "need a fasta file";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the fasta file';

my $line;
my $line1;
my $randomNumber;
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

#open (OUT, ">", "Simulated_$in") or die 'could not open output file';

while ($line=<IN>)
{
 $count++;
 chomp($line);
 if ($line=~/\>/)
 {
  $name="$line";
  $seq{$name}="A";
 }
 else
 {
  $seq{$name}.=$line;
 }
}

my $i;

foreach(keys %seq)
{
 $name=$_;
 $seq{$name}=substr($seq{$name},1,length($seq{$name}));
 $len=length($seq{$name})-50;
 $rev=$seq{$name};
 $rev=reverse($rev);
 $rev=~tr/ACGTacgt/TGCAtgca/;
 for ($i=0;$i<=$len;$i++)
 {
  $count1++;
  print $name.'.'.$count1."\n".substr($seq{$name},$i,50)."\n";
  print $name.'.AS.'.$count1."\n".substr($rev,$i,50)."\n";
 }
}

close IN;



















