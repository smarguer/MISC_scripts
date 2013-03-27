#!/usr/bin/perl


use strict;
use warnings;


if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
open (OUT1, ">", $out.'.log') or die 'could not open log file';

my $i;
my $out1;
my $out2;
my $line;
my $start;
my $count=0;
my $count1=0;
while ($line=<IN>)
{
$count++;
#unless (($line =~ /^[>]/)||($line =~ /^[T]/)){next;}

if ($line =~ /[>]/)
{
	$out1=$line;
}

else
{
        chomp ($line);

	if ($line =~ /CGCCTTGGCCGT/)
	{
	$start=index($line,'CGCCTTGGCCGT');
	#print "$start\n";
	$out2=substr($line,0,$start);
	if ($start == 0)
	{
	$out2='AAAA';
	}
	}	
	else
	{
	$out2=$line;
	}

if (length ($out2) > 20)
{
$count1++;
print OUT "$out1$out2\n";
print OUT1 length($out2)."\n";
}
}
#print "$count\b\b\b\b\b\b\b\b";
}
my @time=times;
print OUT1 "\n\n\n$count\n$count1\n$time[0]\n$time[1]\n$time[2]\n$time[3]\n";
close IN;
close OUT;
close OUT1;



