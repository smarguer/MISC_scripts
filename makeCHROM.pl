#!/usr/bin/perl

#creates a file with all 'five' chromosomes as long strings.

use strict;
use warnings;

my $line;
my $line1;
my $count=0;
my $count1=0;
my $holder;
my @holder;
my $pos;
my $mpos;
my $score=0;
my $chrom='start';
my $sense;
my $seg;
my $int;

my %seq;
my $current;
my $length;


open (IN1, "/jurg/homedir/samuel/POMBE_SEQ/analysis/ALLchromosomes.fsa") or die 'could not find the chromosome file';
open (OUT, ">", "ALLchromosomes.str") or die 'could not open output file :('; 


########################
#reads in the chromosome fasta file
########################

while ($line1=<IN1>)
{
 chomp($line1);
 if ($line1 =~ />/)
 {
  $seq{$line1}=0;
  $current=$line1;
 }
 else
 {
  if ($seq{$current} eq 0)
  {
   $seq{$current}=$line1;
  }
  else
  {
   $seq{$current}=$seq{$current}.$line1;
  }
 }
}

for my $out (sort keys %seq)
{
print OUT "$out\n$seq{$out}\n";
}	
close IN1;
close OUT;




