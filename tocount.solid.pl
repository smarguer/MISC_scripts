#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my %base;
my @holder;
my @holder1;
my $i;
my $pos;
my $pos1;
my $mpos;
my $lchr;
my $nchr;
my $multi=0;
my $unique=0;
my $chromcount=0;
my $plus=0;
my $minus=0;
my $mis;
my %mis;
my $len;
my $chrom;

if (@ARGV != 3) {die "need 2 file names, and a chromosome";}
(my $in, my $out, my $chr)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

if ($chr==1)
{
#chr1
$lchr=5579133;
}
elsif ($chr==2)
{
#chr2
$lchr=4539804;
}
elsif ($chr==3)
{
#chr3
$lchr=2452883;
}
#print "preparing hash...\n";
for ($i =1; $i <= (2 * $lchr); $i++)
{
$base{$i}=0;
#print "$i";
}

#print "analysing reads...\n";

while ($line=<IN>)
{
$count++;
#print "*************************\n";	
	chomp ($line);
#print "$line\n";
	@holder = split (/\,/, $line);
	if ($#holder==0){next;}
	elsif ($#holder>1){$multi++;}
	elsif ($#holder==1){$unique++;}
#print "@holder\n";	
	$holder[1] =~ /([123]{1})_([-]*\d+)\.(\d)/;
#print "$1\t$2\t$3\n";	
	$chrom=$1;
	$pos=$2;
	$mis=$3;
	if($mis{$3}){$mis{$3}++;}
	else {$mis{$3}=1;}
	$len=50;	
#print "$chr\t$chrom\n";
	if ($chrom != $chr){next;}	
	$chromcount++;

	if ($pos >= 0)
	{
	$holder1[0]= $pos+1;
	$holder1[1]= $pos+1+($len-1);
	$plus++;
#print "plus\t@holder1\n";
	}
 	
	if ($pos < 0)
	{
	$holder1[0]=abs($pos)+1-($len-1)+$lchr;
	$holder1[1]=abs($pos)+1+$lchr;
	$minus++;
#print "minus\t@holder1\n";
	}		
	
	foreach $pos1 ($holder1[0] .. $holder1[1])
	{
	$base{$pos1}++;
	}
#print "$count\b\b\b\b\b\b\b\b";
}
	
#print "printing...\n";

for my $out (sort keys %base)
{
print OUT "$out\t$base{$out}\n";
}
##Some statistics:
########
print "total number of reads: ".($count/2)."\n";
print "total with unique match: $unique\n";
print "total with multiple matches: $multi\n";
print "total matches on chr $chr: $chromcount\n";
print "\ton the top strand: $plus\n";
print "\ton the bottom strand: $minus\n";
for my $out1 (sort keys %mis)
{
print "$out1 mismatch: $mis{$out1}\n";
}
########

close IN;
close OUT;

