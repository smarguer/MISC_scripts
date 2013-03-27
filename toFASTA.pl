#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my %counter;

if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

while ($line=<IN>)
{
	$count++;
	if ($count == 1)
	{
	chomp ($line);
	if (!$counter{$line}){$counter{$line}=0;}
	$counter{$line}++;
	if ($counter{$line} > 1)
	{
	print OUT ">$line"."_"."$counter{$line}\n";
	}
	else
	{
	print OUT ">$line\n";
	}
	}
	elsif ($count == 2)
	{
	print OUT "$line";
	}
	elsif ($count == 4)
	{
	$count=0;
	}
	
}

for my $out (sort keys %counter)
{
if ($counter{$out} > 1){$count1++;}
}
if ($count1 != 0)
{
print "$count1\n";
}
close IN;
close OUT;

