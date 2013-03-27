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
my @holder;
my @seq;
my $count=0;
my $count1=0;
my $count2=0;
my $point=0;

while ($line=<IN>)
{
	$count++;
	$point=0;
	chomp ($line);
	@holder=split(/\t/,$line);
	if ($holder[0] =~ /#/){next;}
	@seq=split(/;/, $holder[8]);
#print "$seq[0]\n";
	#@trans=split(//, $seq[0]);
	#@trans=splice(@trans,2,$#trans);
#print "@trans\n";
	#for ($i = 1; $i <= $#trans; $i++)
	#{
	#if ($trans[$i-1] !~ /[ATCG0123\.]/)
	#{
	#print "@trans\n";
	#$point=1;
	#$count2++;
	#}
	#elsif ($trans[$i-1] eq "A")
	#{
#		if ($trans[$i] eq "."){$count1++;$point=1;last;}
#		elsif ($trans[$i] == 0){$trans[$i]="A";}
#		elsif ($trans[$i] == 1){$trans[$i]="C";}
#		elsif ($trans[$i] == 2){$trans[$i]="G";}
#		elsif ($trans[$i] == 3){$trans[$i]="T";}
#	}
#	elsif ($trans[$i-1] eq "C")
#	{
#		if ($trans[$i] eq "."){$count1++;$point=1;last;}
#		elsif($trans[$i] == 0){$trans[$i]="C";}
#		elsif ($trans[$i] == 1){$trans[$i]="A";}
#		elsif ($trans[$i] == 2){$trans[$i]="T";}
#		elsif ($trans[$i] == 3){$trans[$i]="G";}
#	}
#	elsif ($trans[$i-1] eq "G")
#	{  
#		if ($trans[$i] eq "."){$count1++;$point=1;last;}
#		elsif ($trans[$i] == 0){$trans[$i]="G";}
#		elsif($trans[$i] == 1){$trans[$i]="T";}
#		elsif ($trans[$i] == 2){$trans[$i]="A";}
#		elsif ($trans[$i] == 3){$trans[$i]="C";}
#	}	
#	elsif ($trans[$i-1] eq "T")
#	{
#		if ($trans[$i] eq "."){$count1++;$point=1;last;}
#		elsif ($trans[$i] == 0){$trans[$i]="T";}
#		elsif ($trans[$i] == 1){$trans[$i]="G";}
#		elsif ($trans[$i] == 2){$trans[$i]="C";}
#		elsif ($trans[$i] == 3){$trans[$i]="A";}
#	}
#
#	}
#	#print "@trans\n";
#	if ($point==1){next;} 
	$out1 = $holder[0];
#	$out2 = join('', @trans);
 	$out2=substr($seq[0],2);
#print "$out2\n";
if ($out2 =~ /[x\.]/)
{
print ">".$out1."_M".$holder[3]."\n$out2\n";
next;
}
	print OUT ">".$out1."_M".$holder[3]."\n$out2\n";
}
	#
	print "$count\b\b\b\b\b\b\b\b";

print OUT1 "total number of reads: $count\n";
print OUT1 "reads with '.': $count1\n";
print OUT1 "reads with 'x': $count2\n";

close IN;
close OUT;
close OUT1;
