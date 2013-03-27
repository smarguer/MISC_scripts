#!/usr/bin/perl


use strict;
use warnings;


if (@ARGV != 2) {die "need a file name, and the reads length";}
(my $in, my $readlength)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", "$in.split") or die 'could not open output file';
#open (OUT1, ">", $out.'.log') or die 'could not open log file';

my $i;
my $out1;
my $out2;
my $out3;
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
	chomp($line);
	$out1=$line;
}

else
{
        chomp ($line);

	
	unless(length($line)==$readlength){next;}
	
	
	$out2=substr($line,0,20);
	$out3=substr($line,($readlength-20),$readlength);	
	print OUT $out1."_A\n".$out2."\n".$out1."_B\n".$out3."\n";
}

}

close IN;
close OUT;




