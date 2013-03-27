#!/usr/bin/perl
use strict;
use warnings;
#Input file
################################################################################

if (@ARGV != 1) {die "need a  name and a gap size";}
(my $in)=@ARGV;

open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.STATS") or die 'could not open output file';
###############################################################################

my $line;
my $line1=0;
my $prevS= 0;
my $prevE= 0;
my $length= 0;
my $sig= 0;
my $sigout=0;
my $prevStrand= 'init';
my $prevChrom= 'init';
my %start;
my %end;
my $out;

my @holder;

while ($line=<IN>)
{

 chomp($line);
 @holder=split(/\t/, $line);
 if (defined $start{$holder[15]}) 
 {
  $start{$holder[15]}++;
 }
 else
 {
  $start{$holder[15]}=1;
 }

}

for $out (keys %start)
{
print OUT "$out\t$start{$out}\n";
}

close IN;
close OUT;



























 
