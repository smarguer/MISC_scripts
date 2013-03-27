#!/usr/bin/perl
use strict;
use warnings;
#Input file
#################################################################################
 
if (@ARGV != 1) {die "need a file";}
(my $in)=@ARGV;
 
open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.fastq") or die 'could not open output file';
########################
#Variables.
################################################################################
 
my $line=<IN>;
my @holder;
my $count=0; 
my $new=0;
my $i=0;


while ($line=<IN>)
{
 $count++;
 chomp($line);
 @holder=split(/\t/, $line);
 print OUT "$holder[0]\n$holder[4]\n+\n$holder[5]\n"; 
}
close IN;
close OUT;



