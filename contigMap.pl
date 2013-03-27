#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 3) {die "need 2 file names";}
(my $in, my $gff, my $out)=@ARGV;

open (IN, $gff) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
########################


my $line;
my $line1;
my $mid;
my $chr;
my $gene;
my $count=0;
my $check=0;

my @holder;
my @holder1;

my %gffStart;
my %gffEnd;
my %gffChr;
my %conStart;
my %conEnd;
my %conChr;

while ($line=<IN>)
{
	
	chomp ($line);

	@holder = split (/\t/, $line);
	$gffStart{$holder[9]}=$holder[3];
	$gffEnd{$holder[9]}=$holder[4];
	$gffChr{$holder[9]}=substr($holder[0],3,1);
}

print "\n\n\n";
while ($line1=<IN1>)
	{
		
		$count++;
		chomp ($line1);

		@holder1 = split (/ /, $line1);
		unless ($holder1[0]){next;}
		if ($holder1[0] ne "vulgar:"){next;}
		
		$chr=substr($holder1[5],2,1);
		$mid=$holder1[6] +(($holder1[7]-$holder1[6])/2);
		for $gene (sort keys %gffStart)
	 		{
			#print "$gffChr{$gene}\t$chr\n";
			if ($gffChr{$gene} ne $chr) {next;}
			if (($mid >= $gffStart{$gene} && $mid <= $gffEnd{$gene})||($holder1[6] >= $gffStart{$gene} && $holder1[6] <= $gffEnd{$gene})||($holder1[7] >= $gffStart{$gene} && $holder1[7] <= $gffEnd{$gene}))
				{
				print OUT "$line1\t$gene\t$gffStart{$gene}\t$gffEnd{$gene}\t".($gffStart{$gene}-$holder1[6])."\t".($holder1[7]-$gffEnd{$gene})."\n";
				#print "$count\b\b\b\b";
				$check=1;
				}
			}
	#print "$chr";
	if ($check != 1)
	{
	print "$line1\n";
	}
	$check=0;
	}

print "$count\n";
close IN;
close OUT;
close IN1;
