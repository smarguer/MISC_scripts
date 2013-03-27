#!/usr/bin/perl

############################################################
##Corrects strands information for Croucher protocol########
############################################################

use strict;
use warnings;
use POSIX;
my $line;
my $count=0;
my $count1=0;
my @holder;
my $strand;

#######################
#Takes input
#######################

if (@ARGV != 2) {die "I need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (OUT, ">", $out) or die 'could not open output file';


######################################
#parses Exonerate output
######################################


while ($line=<IN>)
{
	
 $count++;
 $count1++;
 chomp ($line);
 @holder = split (/ /, $line);
 unless ($holder[0]){next;}
 if ($holder[0] ne "vulgar:"){next;}

 if ($holder[8] eq '+')
 {
  $strand='-';
 }
 elsif ($holder[8] eq '-')
 {
  $strand='+';
 }
 print OUT "$holder[0] $holder[1] $holder[2] $holder[3] $holder[4] $holder[5] $holder[7] $holder[6] $strand $holder[9] $holder[10] $holder[11] $holder[12]\n";
}

close IN;
close OUT;
