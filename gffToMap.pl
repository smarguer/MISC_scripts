#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
########################


print OUT '>SNP	BG=white'."\t".'FG=red	SY=+'."\n".'>E	BG=cyan	SY=exon'."\n".'>I	BG=yellow	
SY=intron'."\n".'>G	BG=gray	SY=gene	PT=0'."\n".'>R	FG=#00FF00	SY=$	PT=0'."\n";






my $line;
my @holder;

while ($line=<IN>)
{
	
	chomp ($line);

	@holder = split (/\t/, $line);
	if ($holder[0] eq "chr1")
	{
		if ($holder[2] eq "gene")
		{
		print OUT "G\t$holder[3]\t$holder[4]\t$holder[9]\n";
		}
	        if ($holder[2] eq "CSD")
		{
		print OUT "E\t$holder[3]\t$holder[4]\t$holder[9]\n";
		}
		if ($holder[2] eq "intron")
		{
		print OUT "I\t$holder[3]\t$holder[4]\n";
		}

	}


}
	
close IN;
close OUT;
