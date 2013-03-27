#!/usr/bin/perl


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
my %count;
#######################
#Takes input
#######################

if (@ARGV != 2) {die "need 2 file names...";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';


######################################
#parses Exonerate output
######################################


        while ($line=<IN>)
        {

                $count++;
                $score=0;

                chomp ($line);

                @holder = split (/ /, $line);
                unless ($holder[0]){next;}
                if ($holder[0] ne "vulgar:"){next;}

#################################################################################

if ($count{$holder[5]}) {$count{$holder[5]}++;}
else {$count{$holder[5]}=1;}

}


for my $out (keys %count)
{
print OUT "$out\t$count{$out}\n";
}

close IN;
close OUT;
