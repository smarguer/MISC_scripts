#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 1) {die "need a file names";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", "$in.gff") or die 'could not open output file';
########################


#print OUT '>SNP	BG=white'."\t".'FG=red	SY=+'."\n".'>E	BG=cyan	SY=exon'."\n".'>I	BG=yellow	
#SY=intron'."\n".'>G	BG=gray	SY=gene	PT=0'."\n".'>R	FG=#00FF00	SY=$	PT=0'."\n";






my $line;
my @holder;

while ($line=<IN>)
{
	
 chomp ($line);

 @holder = split (/\t/, $line);

 $holder[2]="misc_RNA";
 print OUT "$line\n";
 print OUT join ("\t",@holder)."\n";

}
	
close IN;
close OUT;
