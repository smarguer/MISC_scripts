#!/usr/bin/perl


use strict;
use warnings;
use POSIX;
my $line;
my $count=0;
my $count1=0;
my @holder;
my $start_codon_start;
my $start_codon_end;
my $stop_codon_start;
my $stop_codon_end;

if (@ARGV != 2) {die "I need 2 file names to proceed";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (OUT, ">", $out) or die 'could not open output file';


while ($line=<IN>)
{

        $count++;

        chomp ($line);

        @holder = split (/\t/, $line);
	
	if ($holder[9] eq "LTR")
                 {
                 $holder[9]="$holder[9]_$holder[0]_$holder[3]";
                 }


	if ($holder[2] eq "gene")
	{
		if ($holder[6] eq "+" || $holder[6] eq ".") 
                {
                	$start_codon_start=$holder[3];
                        $start_codon_end=$holder[3]+2;
                        $stop_codon_start=$holder[4]-2;
                        $stop_codon_end=$holder[4];
                }      
		if ($holder[6] eq "-")
		{
			$start_codon_start=$holder[4];
			$start_codon_end=$holder[4]-2;
			$stop_codon_start=$holder[3]+2;
			$stop_codon_end=$holder[3];
		}
	
		print OUT "$holder[0]\t$holder[1]\tstart_codon\t$start_codon_start\t$start_codon_end\t$holder[5]\t$holder[6]\t$holder[7]\tgene_id ".'"'.$holder[9].'"'."; transcript_id ".'"'.$holder[9].".1".'"'.";\n";
		print OUT "$holder[0]\t$holder[1]\tstop_codon\t$stop_codon_start\t$stop_codon_end\t$holder[5]\t$holder[6]\t$holder[7]\tgene_id ".'"'.$holder[9].'"'."; transcript_id ".'"'.$holder[9].".1".'"'.";\n";

	
	}
	elsif ($holder[2] eq "CDS" || $holder[2] eq "LTR" || $holder[2] eq "misc_RNA")
	{
	print OUT "$holder[0]\t$holder[1]\tCDS\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\tgene_id ".'"'.$holder[9].'"'."; transcript_id ".'"'.$holder[9].".1".'"'.";\n";
	print OUT "$holder[0]\t$holder[1]\texon\t$holder[3]\t$holder[4]\t$holder[5]\t$holder[6]\t$holder[7]\tgene_id ".'"'.$holder[9].'"'."; transcript_id ".'"'.$holder[9].".1".'"'.";\n";
	}


}

close IN;
close OUT;

