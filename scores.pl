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
my @scores;
#######################
#Takes input
#######################

if (@ARGV != 2) {die "need 2 file names...";}
(my $in, my $out)=@ARGV;

#(my $in) = @ARGV;

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
	#print "$holder[9]";
	if ($holder[9] == 178)
	{
	#print OUT "$holder[1]\n";
	print OUT "$line\n";
	}
	if (grep /$holder[9]/, @scores) {next;}
	else 
	{
	print "$holder[9]\n";
	push (@scores, $holder[9]);
	}
	
	}
	
print "@scores";


close IN;
close OUT;

