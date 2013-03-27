#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0; 
my %base;
my @holder;
my @holder1;
my $i=0;
my $j;
my $pos;
my $mpos;
my $chr;
my $lchr;
my $nchr;
my $out;
my $out1;
my $k;
my $spike;

###
if (@ARGV != 1) {die "need 1 name";}
(my $in)=@ARGV;

open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.spikes.bases") or die 'could not open output file';
###

for ($i =0; $i <=776; $i++)
{
 $base{1}{$i}=0;
}
for ($i =0; $i <=776; $i++)
{
 $base{2}{$i}=0;
}
for ($i =0; $i <=1026; $i++)
{
 $base{3}{$i}=0;
}
for ($i =0; $i <=1027; $i++)
{
 $base{4}{$i}=0;
}
for ($i =0; $i <=1059; $i++)
{
 $base{5}{$i}=0;
}
for ($i =0; $i <=1276; $i++)
{
 $base{6}{$i}=0;
}
for ($i =0; $i <=1474; $i++)
{
 $base{7}{$i}=0;
}
for ($i =0; $i <=2026; $i++)
{
 $base{8}{$i}=0;
}

####################

while ($line=<IN>)
{
 chomp ($line);
 @holder = split (/ /, $line);
 if ($holder[0] ne "vulgar:"){next;}
 $count++;
 $holder[5] =~ /_([1-8]{1})_/;
 $spike=$1;
 @holder1= ($holder[6],$holder[7]);
 @holder1= sort (@holder1);

 if ($holder[8] eq "-")
 {
  print "AS####$line\n";
  next;
 }		
#to adjust the start of the match coordinate to the real genome coordinate.the
 $holder1[0]=$holder1[0]+1;
  $base{$spike}{0}++;	
 foreach $pos ($holder1[0] .. $holder1[1])
 {
  $base{$spike}{$pos}++;
 }
}
	
for ($out=1;$out<=8;$out++)
{
 print OUT ">SPIKE_".$out."\n";
 print OUT "$base{$out}{0}\n";
 $k = keys %{$base{$out}};
 for ($out1=1;$out1<$k;$out1++)
 {
  print OUT "$base{$out}{$out1}.";
 }
 print OUT "\n";
 print "$out\t$out1\n";
}

close IN;
close OUT;




 
