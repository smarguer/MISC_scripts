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

if (@ARGV != 2) {die "need 3 file names, and a format option";}
#(my $in, my $out, my $chr)=@ARGV;
(my $in, my $out)=@ARGV;
open (IN, $in) or die 'could not find the input file';
#open (IN1, $chr) or die 'could not find the chromosome file';
open (OUT, ">", $out) or die 'could not open output file';

########################
#reads in the chromosome fasta file
########################
#while ($line1=<IN1>)
#{
#chomp($line1);
#$chrom = $chrom.$line1;
##substr($line1,10);
##$chrom=$line1;
#}
#$chrom= substr($chrom, 14);

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
		
			if ($holder[4] eq "+")
			{
				#if ($holder[2]<=4 && $holder[3]>=20 && $holder[3]<=28 && ($holder[9] =~ /[1][12345][05]/))
				if (($holder[3] - $holder[2]) >=25 && $holder[3] <= 28 && ($holder[9] =~ /(125)|(130)|(135)|(140)|(116)|(121)|(126)|(131)/)) 
				{

					print OUT "$line\n";
#					$pos=$holder[7]+1;
#	#print '+';
#					$mpos=$pos-11;
#	#if ((substr($chrom, $pos, 5) eq 'aaaaa') || (substr($chrom, $pos, 5) eq 'ttttt'))
#					if ((substr($chrom, $pos, 10) =~ /[t|c|g]*[a]{5,}/))
#					{
#						#$score = 2;
#	#print "$score\n";
#					}
#	
#					if ((substr($chrom, $mpos, 10) =~ /[t|c|g]*[a]{5,}/))
#					{
#						$score = $score + 2;
#	#print "$score\n";
#					}
#					print OUT "$pos\t$score\n$line\n";
				}
			}
			
			if ($holder[4] eq "-")
			{
				#if ($holder[3]<=4 && $holder[2]>=20 && $holder[2]<=28 && ($holder[9] =~ /[1][12345][05]/))
 				if (($holder[2] - $holder[3]) >=25 && $holder[2] <= 28 && ($holder[9] =~ /(125)|(130)|(135)|(140)|(116)|(121)|(126)|(131)/))
                                
				{
			
					print OUT "$line\n";
#					$pos=$holder[6]+1;
#	#print '-';
#	
#					$mpos=$pos-11;
#	#if ((substr($chrom, $pos, 5) eq 'aaaaa') || (substr($chrom, $pos, 5) eq 'ttttt'))
#					if ((substr($chrom, $pos, 10) =~ /[t|c|g]*[a]{5,}/) || (substr($chrom, $pos, 10) =~ /[t|c|g]*[t]{5,}/))
#					{
#						$score = 2;
#	#print "$score\n";
#					}
#	
#					if ((substr($chrom, $mpos, 10) =~ /[t|c|g]*[a]{5,}/) || (substr($chrom, $mpos, 10) =~ /[t|c|g]*[t]{5,}/))
#					{
#						$score = $score + 2;
#	#print "$score\n";
#					}
#					print OUT "$pos\t$score\n$line\n";
				}	
			}
		

####################################################################################

		
        	#$count=0;

	}



#print "$count1\n";
#print substr($chrom, 793917, 5),"\n";
#print substr($chrom, 0, 100),"\n";

close IN;
close OUT;

