#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my %base;
my @holder;
my @holder1;
my @holder2;
my $i=0;
my $j=0;
my $pos;
my $mpos;
my $chr;
my $lchr;
my $nchr;
my %chr;
my %intron;
#if (@ARGV != 3) {die "need 2 file names, and a chromosome";}
#(my $in, my $out, my $chr)=@ARGV;


###all in one
if (@ARGV != 2) {die "need 1 file name and a gff";}
(my $in, my $gff)=@ARGV;

open (IN1, "$gff") or die 'could not find the gff file';
###read gff
my $line1=<IN1>;

$chr{1}=5579133;
$chr{2}=4539804;
$chr{3}=2452883;
$chr{4}=10;
$chr{5}=10;
$chr{6}=10;

while ($line1 = <IN1>)
{
 chomp($line1);
 @holder2=split(/\t/, $line1);
 if ($holder2[2] eq "intron")
 {
  $j=0;
  for ($i=($holder2[3]+1); $i < $holder2[4]; $i++)
  {
   $j=$i+$chr{$holder2[12]};
   $intron{$holder2[12]}{$i}=1;
   $intron{$holder2[12]}{$j}=1;
#if ($holder2[9] eq 'SPAC9.11')
#if ($holder2[9] eq 'SPAC1250.05')
#{
#print "$i\n";
#}
  }
 }
}

for ($chr=1;$chr<=3;$chr++)
{
#print "$chr\n";
#open (IN, $in) or die 'could not find the input file';
open (IN, "$in") or die 'could not find the input file';

open (OUT, ">", "$in.chr$chr.bases") or die 'could not open output file';
#######
if ($chr==1)
{
#chr1
$lchr=5579133;
$nchr = "CH1_bases";
}
elsif ($chr==2)
{
#chr2
$lchr=4539804;
$nchr = "CH2_bases";
}
elsif ($chr==3)
{
#chr3
$lchr=2452883;
$nchr = "CH3_bases";
}
#print "preparing hash...\n";
for ($i =1; $i <= (2 * $lchr); $i++)
{
$base{$i}=0;
#print "$i";
}


#print "$lchr\n$nchr\n";



#print "analysing reads...\n";

while ($line=<IN>)
{
	
	chomp ($line);
	@holder = split (/ /, $line);
	if ($holder[0] ne "vulgar:"){next;}
	if ($holder[5] ne $nchr){next;}
	$count++;
	@holder1= ($holder[6],$holder[7]);
	@holder1= sort (@holder1);
 	
	if ($holder[8] eq "-")
	{
	$holder1[0]=$holder1[0]+$lchr;
	$holder1[1]=$holder1[1]+$lchr;
	}		
	

	#to adjust the start of the match coordinate to the real genome coordinate.the
	 
        #$holder1[0]=$holder1[0]+1;
	if ($holder1[0]==0){$holder1[0]=1;}
	if ($holder1[1]==0){$holder1[1]=1;}

	foreach $pos ($holder1[0] .. $holder1[1])
	{
	 if (defined $intron{$chr}{$pos})
         {
#print "$base{$pos}\n";
          $base{$pos}=0;
	  #next;
         }
         else
         {
          $base{$pos}++;
	 }
#print "$base{$pos}\n";
#if ($holder[1] eq '@5:86:149:1932:Y')
#{
#print "$pos\t$base{$pos}\n";
#}
        }
#print "$count\b\b\b\b\b\b\b\b";
}
	
#print "printing...\n";

for my $out (sort keys %base)
{
print OUT "$out\t$base{$out}\n";
}

%base=();
close IN;
close OUT;
}




 
