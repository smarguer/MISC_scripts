#!/usr/bin/perl


use strict;
use warnings;


if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
#open (OUT1, ">", $out.'.log') or die 'could not open log file';

my $i;
my $out1;
my $out2;
my $out3;
my $line;
my $start;
my $name;
my $half;

my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my $count4=0;
my $count5=0;

my @holder;
my @holder1;

my %pos;

while ($line=<IN>)
{

chomp ($line);

        @holder = split (/ /, $line);
        unless ($holder[0]){next;}
        if ($holder[0] ne "vulgar:"){next;}
	$count++;
	@holder1 = split (/_/,$holder[1]);
	#print "@holder1\n";
	$name=join("_",$holder1[0],$holder1[1],$holder1[2],$holder1[3]);
	$half=$holder1[4];
	if ($pos{$name}{$half})
	{
	$pos{$name}{$half}="NON UNIQUE";
	}
	else
	{
	$pos{$name}{$half}=$holder[6];	
	}
}
for $out (keys %pos)
{
if ($pos{$out}{A} && $pos{$out}{B})
{
	$count1++;
	if (($pos{$out}{A} eq "NON UNIQUE") || ($pos{$out}{B} eq "NON UNIQUE"))
	{
	$count2++;
	print OUT "$out\t$pos{$out}{A}\t$pos{$out}{B}\tNON UNIQUE\n";
	}
	else
	{
	$count3++;
	print OUT "$out\t$pos{$out}{A}\t$pos{$out}{B}\t".abs($pos{$out}{A}-$pos{$out}{B})."\n";
	}
}
elsif ($pos{$out}{A})
{
	$count4++;
	print OUT "$out\t$pos{$out}{A}\tNO MATCH\tNO MATCH\n";
}
elsif ($pos{$out}{B})
{
	$count5++;
	print OUT "$out\tNO MATCH\t$pos{$out}{B}\tNO MATCH\n";
}

}

print "Total matched: ".$count."\n";
print "Both halves mapable: ".$count1."\n";
print "One or two non unique: ".$count2."\n";
print "Both unique: ".$count3."\n";
print "No match A: ".$count5."\n";
print "No match B: ".$count4."\n";

close IN;
close OUT;




