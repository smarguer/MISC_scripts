#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $line1;
my $count=0;
my $count1=0;
my $count2=0;
my $holder;
my @holder;
my @holder1;
my %map;

if (@ARGV != 2) {die "wrong number of files";}
(my $in, my $in1)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (IN1, $in1) or die 'could not find the input file';
#open (OUT, ">", $out) or die 'could not open output file';



while ($line=<IN>)
	{
		
		#$count++;
		
	
		chomp ($line);

		@holder = split (/ /, $line);
		unless ($holder[0]){next;}
		if ($holder[0] ne "vulgar:"){next;}
		if ($map{$holder[1]}) {next;}
		else
		{
		$count++;
		print "$holder[1]\t";
		$map{$holder[1]}=1;
		}
		
		#print OUT "$line\n";
	}
while ($line1=<IN1>)
{
	$count1++;
	
	if ($count1 == 1)
	{
	chomp($line1);
	$holder=substr($line1,1);
	print "$holder\n";
	if ($map{$holder})
	{
	$count2++;
	}
	}
	elsif ($count1 == 2)
	{
	$count1=0;
	}

}

print "$count\n$count1\n$count2\n";


close IN;
close IN1;

