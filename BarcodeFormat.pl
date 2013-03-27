#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my $count2=0;
my %counter;
my $seq=0;
my $header=0;
my $Average;
my $i;
my $out1=0;
my $out2=0;
my @qual_table;
my @out;
my %average;
my $readaverage=0;
###ILL or Sanger quals###
my $type=64;
if (@ARGV != 1) {die "need 1 file name";}
(my $in)=@ARGV;

open (IN, "$in.fasta") or die 'could not find the input file';
open (OUT1, ">", "$in.barcode.fasta") or die 'could not open output file'; 
open (OUT2, ">", "$in.seq.fasta") or die 'could not open output file';

while ($line=<IN>)
{
	$count++;
	if ($count == 1)
	{
	  chomp ($line);
	  $header = "$line";
	}
	
	elsif ($count == 2)
	{
	 $seq = $line;
	
	 print OUT1 "$header\n";
	 print OUT2 "$header\n";
	 print OUT1 substr ($seq,0,6)."\n";
	 print OUT2 substr ($seq,-45)."\n";
         $count=0;
	}
}
close IN;
close OUT1;
close OUT2;
