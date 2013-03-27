#!/usr/bin/perl


use strict;
use warnings;
use POSIX;
my $line;
my $count=0;
my $count1=0;
my @holder;

if (@ARGV != 2) {die "I need 2 file names to proceed";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (OUT, ">", $out) or die 'could not open output file';


while ($line=<IN>)
{

        $count++;
	
        chomp ($line);
	$line=uc($line);
	print OUT "$line\n";
	
}

close IN;
close OUT;

