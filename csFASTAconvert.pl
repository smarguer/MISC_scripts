#!/usr/bin/perl
use warnings;
use strict;

if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
open (OUT1, ">", $out.'.log') or die 'could not open log file';

my $i;
my $out1;
my $out2;
my $line;
my @trans;
my $count=0;
my $count1=0;
my $point;
while ($line=<IN>)
{
$count++;
unless (($line =~ /^[>]/)||($line =~ /^[T]/)){next;}  

if ($line =~ /[>]/)
{
$out1=$line;
$point=0;
}

else
{
	chomp ($line);
	@trans=split(//, $line);
#print "@trans\n";
	for ($i = 1; $i <= $#trans; $i++)
	{

	if ($trans[$i-1] eq "A")
	{
		if ($trans[$i] eq "."){$count1++;$point=1;last;}
		elsif ($trans[$i] == 0){$trans[$i]="A";}
		elsif ($trans[$i] == 1){$trans[$i]="C";}
		elsif ($trans[$i] == 2){$trans[$i]="G";}
		elsif ($trans[$i] == 3){$trans[$i]="T";}
	}
	elsif ($trans[$i-1] eq "C")
	{
		if ($trans[$i] eq "."){$count1++;$point=1;last;}
		elsif($trans[$i] == 0){$trans[$i]="C";}
		elsif ($trans[$i] == 1){$trans[$i]="A";}
		elsif ($trans[$i] == 2){$trans[$i]="T";}
		elsif ($trans[$i] == 3){$trans[$i]="G";}
	}
	elsif ($trans[$i-1] eq "G")
	{  
		if ($trans[$i] eq "."){$count1++;$point=1;last;}
		elsif ($trans[$i] == 0){$trans[$i]="G";}
		elsif($trans[$i] == 1){$trans[$i]="T";}
		elsif ($trans[$i] == 2){$trans[$i]="A";}
		elsif ($trans[$i] == 3){$trans[$i]="C";}
	}	
	elsif ($trans[$i-1] eq "T")
	{
		if ($trans[$i] eq "."){$count1++;$point=1;last;}
		elsif ($trans[$i] == 0){$trans[$i]="T";}
		elsif ($trans[$i] == 1){$trans[$i]="G";}
		elsif ($trans[$i] == 2){$trans[$i]="C";}
		elsif ($trans[$i] == 3){$trans[$i]="A";}
	}

	}
	#print "@trans\n";
	if ($point==1){next;} 
	$out2 = join('', @trans);
	$out2 = substr($out2,1); 
	print OUT "$out1$out2\n";
}
	#
	#print "$count\b\b\b\b\b\b\b\b";
}
print OUT1 "$count\n";
print OUT1 "$count1\n";

close IN;
close OUT;
close OUT1;
