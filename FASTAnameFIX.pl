#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0;
my %counter;
my @line;

if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

while ($line=<IN>)
{
	$count++;
	if ($count == 1)
	{
	chomp($line);
    @line=split(/ /,$line);
   
    print OUT join(';',@line)."\n";
	}
	elsif ($count == 2)
	{
	print OUT "$line";
	$count=0;
	}
	
}

close IN;
close OUT;


