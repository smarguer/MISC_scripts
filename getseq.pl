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
my $seg;
my $int;
my $chr;

#######################
#Takes input
#######################

if (@ARGV != 3) {die "need 3 file names";}
#(my $in, my $out, my $chr)=@ARGV;
(my $in, my $out, $chr)=@ARGV;
open (IN, $in) or die 'could not find the input file';
open (IN1, $chr) or die 'could not find the chromosome file';
open (OUT, ">", $out) or die 'could not open output file';

########################
#reads in the chromosome fasta file
########################
while ($line1=<IN1>)
{
chomp($line1);
$chrom = $chrom.$line1;
#substr($line1,10);
#$chrom=$line1;
}
$chrom= substr($chrom, 14);
########################
#for introns
########################
#while ($line=<IN>)
#	{
#		
#		$count++;
#		$score=0;
#	
#		chomp ($line);
#
#		@holder = split (/\t/, $line);
#		if ($holder[9] eq "+")
#		{
#		print OUT ">$holder[4]_seg\n".substr($chrom, $holder[0], ($holder[1]-$holder[0]))."\n>$holder[4]\n".substr($chrom, $holder[5], ($holder[6]-$holder[5]))."\n";
#		}
#		elsif ($holder[9] eq "-")
#		{
#		$seg = reverse(substr($chrom, $holder[0], ($holder[1]-$holder[0])));
#		$seg =~ tr/ACGTacgt/TGCAtgca/;
#		$int = reverse(substr($chrom, $holder[5], ($holder[6]-$holder[5])));
#		$int =~ tr/ACGTacgt/TGCAtgca/;
#		print OUT ">$holder[4]_seg\n$seg\n>$holder[4]\n$int\n";
#		}
#	}
#######################
#for intergenic
######################
while ($line=<IN>)
	{
		
		$count++;
		$score=0;
	
		chomp ($line);

		@holder = split (/\t/, $line);
		if ($holder[9] eq "+")
		{
		print OUT ">$holder[4]_$holder[0]\n".substr($chrom, $holder[0], ($holder[1]-$holder[0]))."\n";
		}
		elsif ($holder[9] eq "-")
		{
		$seg = reverse(substr($chrom, $holder[0], ($holder[1]-$holder[0])));
		$seg =~ tr/ACGTacgt/TGCAtgca/;
		#$int = reverse(substr($chrom, $holder[5], ($holder[6]-$holder[5])));
		#$int =~ tr/ACGTacgt/TGCAtgca/;
		print OUT ">$holder[4]_$holder[0]\n$seg\n";
		}
	}
	
	
	
close IN;
close IN1;
close OUT;


close IN;
close OUT;

