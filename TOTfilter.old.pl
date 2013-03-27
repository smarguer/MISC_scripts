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
#######################
#Takes input
#######################

if (@ARGV != 4) {die "need 3 file names, and a format option";}
(my $in, my $out, my $chr, my $format)=@ARGV;

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
#parses mummer output
########################
if ($format eq "M")
{

while ($line=<IN>)
{
	$count++;
	$score=0;
	if ($line =~ m/^\>/)
	{
		chomp($line);
		$holder=$line;
	#print "$holder";
	}
	elsif ($line !~ m/^\>/)
	{
		chomp ($line);
	#print "$line\n";
		$line =~ m/\s(\d+)\s+(\d+)\s+(\d+)/g;
	#print "$1\n$2\n$3\n";
		my $start = $2;
		my $end = $3;
		my $hit = $1;
	#if ($end-$start > 15 && $end-$start < 29)
		if ($start == 1 && $end <= 25)
	#if ($start == 11 && $end == 30)
		{
			$count1++;
        #print "$1\n$2\n$3\n";
			my $test = $holder;
			
			if ($sense eq "A")
			{
				if ($holder =~ /Reverse/)
				{
					$pos = $hit-1;
				}
				else
				{
					$pos = $hit+$end-1;
				}
			}
			
			elsif ($sense eq "T")
			{
				if ($holder =~ /Reverse/)
				{
					$pos = $hit+$end-1;
				}
	
				else
				{
					$pos = $hit-1;
				}
			}
####################################	
			$mpos=$pos-11;
	#if ((substr($chrom, $pos, 5) eq 'aaaaa') || (substr($chrom, $pos, 5) eq 'ttttt'))
			if ((substr($chrom, $pos, 10) =~ /[t|c|g]*[a]{5,}/) || (substr($chrom, $pos, 10) =~ /[t|c|g]*[t]{5,}/))
			{
				$score = 2;
	#print "$score\n";
			}
	
			if ((substr($chrom, $mpos, 10) =~ /[t|c|g]*[a]{5,}/) || (substr($chrom, $mpos, 10) =~ /[t|c|g]*[t]{5,}/))
			{
				$score = $score + 2;
	#print "$score\n";
			}
#####################################	
			print OUT "$holder\t$pos\t$score\n$line\n";
        		$count=0;
        	}
	
	}
	
}
}
######################################
#parses Exonerate output
######################################

elsif ($format eq "E")
{

	while ($line=<IN>)
	{
		
		$count++;
		$score=0;
	
		chomp ($line);

		@holder = split (/ /, $line);
		unless ($holder[0]){next;}
		if ($holder[0] ne "vulgar:"){next;}
		
#################################################################################		
		
			if ($holder[4] eq "+")
			{
				#if ($holder[2]==0 && $holder[3]==30 && ($holder[9] =~ /[1][5][0]/))
				#if ($holder[9] =~ /(132|136|140|145|150)/)
				if ($holder[9] =~ /(123|127|131|132|135|136|140|145|150)/)
				{
			
					#print OUT "$line\n";
					$pos=$holder[7]+1;
	#print '+';			
					$score=0;
					$mpos=$pos-11;
	
					#print OUT "$pos\t$score\n$line\n";
					print OUT "$line\n";
				}
			}
			
			if ($holder[4] eq "-")
			{
				#if ($holder[3]==0 && $holder[2]==30 && ($holder[9] =~ /[1][5][0]/))
				#if ($holder[9] =~ /(132|136|140|145|150)/)
				if ($holder[9] =~ /(123|127|131|132|135|136|140|145|150)/)
				{
			
					#print OUT "$line\n";
					$pos=$holder[6]+1;
	#print '-';
					$score=0;
					$mpos=$pos-11;
	
					#print OUT "$pos\t$score\n$line\n";
					print OUT "$line\n";
				}	
			}
		

####################################################################################

		
        	$count=0;

	}
}


#print "$count1\n";
#print substr($chrom, 793917, 5),"\n";
#print substr($chrom, 0, 100),"\n";

close IN;
close OUT;

