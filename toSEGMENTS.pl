#!/usr/bin/perl
use strict;
use warnings;
#Input file
################################################################################

if (@ARGV != 2) {die "need 1 name and a cut off";}
(my $in, my $cutoff)=@ARGV;

#open (IN, $in) or die 'could not find the input file';
#open (IN1, $in1) or die 'could not find chromosome number';
open (OUT, ">", "$in.$cutoff.SEG") or die 'could not open output file';
########################
#Variables.
################################################################################

my $line;
my $in1;
my $count = 0;
my $count1=1;
my $sum = 0;
#my $cutoff = $in2;
my $name;
my $prev=-1;
my $syst;
my $chrom;
my $ori = 0 ;
my $start = 0;
my $end = 0;
my $chr = 0;
my $strand;
#my @holder;
my $holder= 0;

#Output file.
################################################################################
#open (OUT, ">C:\\segments.nWTn.3mis.chr1.".$cutoff.".txt") or die 'could not open output file';
#Parse GS file
################################################################################

##########
#All in one
##########
for ($in1=1;$in1<=3;$in1++)
{ 

open (IN, "$in.chr$in1") or die "could not open chromosome $in1 file";

$prev=0;
$start=0;
$end=0;
$count=0;

##added 080812
$count1=1;
##

if ($in1==1) {$chr=5579133;}
if ($in1==2) {$chr=4539804;}
if ($in1==3) {$chr=2452883;}
#$count=0;

while ($line=<IN>)
{
	$count++;
  #$count1++;
	#@holder = split (/\t/,$line);
  	$holder=$line;
  	if ($prev < $cutoff)
  	{
 		if ($holder < $cutoff)
  		{
  			$prev = $holder;
  			next;
  		}
  		elsif ($holder>= $cutoff)
    		{
    			$start=$count;
    			$end=$count;
    			$sum=$holder;
    		}
  		$prev = $holder;
  	}
  	elsif ($prev >= $cutoff)
  	{
  		if ($holder < $cutoff)
    		{
    		#unless ($start){next;} 
    			if ($start > $chr)
			{
				$start=$start-$chr;
				$end=$end-$chr;
				$strand='-';
			}
			elsif ($start < $chr)
                        {
   				$strand='+';
   			}
			
			print OUT "$start\t$end\t".($end-$start+1)."\t";
            printf OUT "%.1f", ($sum/$count1);
            print OUT     "\t$strand\t$in1\n";
			
#print "$in1\t$strand\n";
			$start=0;
    			$end=0;
    			$count1=1;
    			$sum=0;
    			$prev=$holder;
    		}
  		elsif ($holder>= $cutoff)
    		{
    			$count1++;
    			$end=$count;
    			$prev=$holder;
    			$sum=$sum+$holder;
    		}
  	}

}


close IN;
}
close OUT;

