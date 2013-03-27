#!/usr/bin/perl


use strict;
use warnings;
use POSIX;

my $line;
my $count=0;
my $count1=0;

my $codon;
my $out;
my $out1;

my @holder;
my @match;

my %read;
my %match;
my %count;


#######################
#Takes input
#######################

if (@ARGV != 1) {die "Need one mapping file to collapse and an output name";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';
open (OUT, ">", $in.'.specificity') or die 'could not open output file';


######################################
#parses Exonerate output
######################################


while ($line=<IN>)
{
	
 $count++;
 #print "$count\n";
 $count1++;
 chomp ($line);
 @holder = split (/ /, $line);
 unless ($holder[0]){next;}
 if ($holder[0] !~ /vulgar/){next;}

#$len=$holder[3] - $holder[2];
###############################################################################
 $holder[5]=~/(\w+)\.(\d+)/;	
 $codon=$1;
 #print "$codon\n";
 if (defined $read{$holder[1]})
 {
  $read{$holder[1]}.=";$codon";
 }
 else
 {
  $read{$holder[1]}=$codon;
 }
}
for $out (keys %read)
{

 @match=();
 %match=();

 if ($read{$out} =~ /;/)
 {
  @match=split(/;/,$read{$out});
  for (@match)
  {
   $match{$_}=1;
  }
  $out1=join(';',keys %match);
  if (defined $count{$out1})
  {
   $count{$out1}++;
  }
  else
  {
   $count{$out1}=1;
  }
 } 
 else
 {
  if (defined $count{$read{$out}})
  {
   $count{$read{$out}}++;
  }
  else
  {
   $count{$read{$out}}=1;
  }
 }
}

for $out (keys %count)
{
 print OUT "$out\t$count{$out}\n";
}

close IN;
close OUT;




