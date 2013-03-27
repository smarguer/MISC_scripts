#!/usr/bin/perl


use strict;
use warnings;
use POSIX;
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
my %readlength;
my $mis=0;
my $len;
my $steps;
my $out1;
my %trs;
my %gff;
my $trs;
my $gff;

#######################
#Takes input
#######################

if (@ARGV != 2) {die "I need 3 file names, the readlength and the number of mismatches allowed";}
(my $in1, my $in)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (IN1, $in1) or die 'could not find fasta file';
#open (OUT, ">", $out) or die 'could not open output file';
#open (OUT1,">",$out.".log") or die 'could not open log file';
######################################
#parses fasta file
######################################
while ($line1=<IN1>)
{
	chomp ($line1);
        if ($line1 =~ /[\>]/)
	{
	 $out1=substr($line1,1);
	 $trs{$out1}=$out1;
	}
	else
	{
	 next;
	}

}

######################################
#parses Exonerate output
######################################


while ($line=<IN>)
{
	
	$count++;
	$count1++;
	$score=0;
	chomp ($line);
	@holder = split (/\t/, $line);
        if ($holder[2] ne "gene")
        {
         next;
        }
	$gff{$holder[9]}=$line;
}

print "checking trs data:\n";
 
for $trs (keys %trs)
{
 unless (defined $gff{$trs})
 {
  if ($trs !~ /SPM/)
  {
  print "$trs{$trs}\n"; 
  }
 }
}
print "checking gff data:\n";

for $gff (keys %gff)
{
 unless (defined $trs{$gff})
 {
  if ($gff =~ /SP/)
  {
   print "$gff{$gff}\n";
  }
 }
}

close IN;
close IN1;
