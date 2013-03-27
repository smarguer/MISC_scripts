#!/usr/bin/perl


use strict;
use warnings;
my @holder;
my @holder1;
my $line;
my $out;
my $readaverage;
my %average;

if (@ARGV != 1) {die "I need a file name";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (OUT, ">", "$in.qualaverage") or die 'could not open output file';


while ($line=<IN>)
{

    #$count++;
    #$score=0;

    chomp ($line);

    @holder = split (/ /, $line);
    unless ($holder[0]){next;}
    if ($holder[0] ne "vulgar:"){next;}
    @holder1 = split (/;/, $holder[1]);
    #print "$holder1[1]\n";
    #print OUT "$holder1[1]\n";
    
     $readaverage=int(($holder1[1]+0.5));
     if ($average{$readaverage})
     {
     $average{$readaverage}++;
     }

     else
     {
     $average{$readaverage}=1;
     }


}

####print average table###########################################
for ($out=1;$out<=40;$out++)
{
 if ($average{$out})
 {
  print OUT "$out\t$average{$out}\n";
 }
 else
 {
  print OUT "$out\t0\n";
 }
}

close IN;
close OUT;

