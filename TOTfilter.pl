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
my $readlength=54;
my $mis=5;
my $len;
my $steps;


#######################
#Takes input
#######################

if (@ARGV != 4) {die "I need 2 file names, the readlength and the number of mismatches allowed";}
(my $in, my $out, $readlength, $mis)=@ARGV;

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
		$len=$holder[3] - $holder[2];
		$steps=$mis-($readlength-$holder[3]+$holder[2]);
		
#################################################################################		
		
			if ($holder[8] eq "+")
			{
				#if ($holder[2]==0 && $holder[3]==30 && ($holder[9] =~ /[1][5][0]/))
				#if ($holder[9] =~ /(132|136|140|145|150)/)
				#if ($holder[9] =~ /(123|127|131|132|135|136|140|145|150)/)
				#if (($holder[9] =~ /(158|162|164|166|167|168|169|170|171|173|175|176|178|180|185)/)||
				#    (($holder[9] =~ /(155)/) && (($holder[2] == 37)||($holder[3] == 37)))||
				#    (($holder[9] =~ /(160)/) && (($holder[2] == 37)||($holder[3] == 37))))
				#if ($holder[9] =~ /(154|163)/)
				if (($holder[9] >= (($readlength*5)-($mis*9))) && ($holder[9] <= ($len * 5)) && ($holder[9] >= (($len * 5) - ($steps * 9))))
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
			
			if ($holder[8] eq "-")
			{
				#if ($holder[3]==0 && $holder[2]==30 && ($holder[9] =~ /[1][5][0]/))
				#if ($holder[9] =~ /(132|136|140|145|150)/)
				#if ($holder[9] =~ /(123|127|131|132|135|136|140|145|150)/)
				#if ($holder[9] =~ /(158|162|166|167|170|171|175|176|180|185)/)
				#if ($holder[9] =~ /(154|163)/)
 				#if (($holder[9] =~ /(158|162|164|166|167|168|169|170|171|173|175|176|178|180|185)/)||
                                #    (($holder[9] =~ /(155)/) && (($holder[2] == 37)||($holder[3] == 37)))||
                                #    (($holder[9] =~ /(160)/) && (($holder[2] == 37)||($holder[3] == 37))))
				if (($holder[9] >= (($readlength*5)-($mis*9))) && ($holder[9] <= ($len * 5)) && ($holder[9] >= (($len * 5) - ($steps * 9))))
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



#print "$count1\n";
#print substr($chrom, 793917, 5),"\n";
#print substr($chrom, 0, 100),"\n";

close IN;
close OUT;

