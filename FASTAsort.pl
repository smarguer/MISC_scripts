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

if (@ARGV != 4) {die "need 4 file names";}
(my $in, my $in1, my $out, my $out1)=@ARGV;

open (IN, $in) or die 'could not find the list';
open (IN1, $in1) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
open (OUT1, ">", $out1) or die 'could not open output file';

print "reading mapped reads file...\n";

while ($line=<IN>)
	{
		
		$count++;
		
	
		chomp ($line);

		#@holder = split (/ /, $line);
		#unless ($holder[0]){next;}
		#if ($holder[0] ne "vulgar:"){next;}
		if ($map{$line}) {$map{$line}++;}
		else {$map{$line} = 1;}
		
	}


print "sorting reads...\n";

while ($line1=<IN1>)
{
	$count1++;
	chomp($line1);
	if ($line1 =~ /[>]/)
	{
	
	$line1=substr($line1,1);
		if ($map{$line1})
		{
		print OUT ">$line1\n";
		$count2=1;
		}
		else
		{
		print OUT1 ">$line1\n";
		$count2=2;
		}
			
	}
	
	elsif ($count2==1)
	{
	print OUT "$line1\n";
	$count2=0;
	}
	
	elsif ($count2==2)
	{
	print OUT1 "$line1\n";
	$count2=0;
	}
	
}

#print "$holder\n\n";


print "Done\n";

close IN;
close IN1;
close OUT;
close OUT1;







