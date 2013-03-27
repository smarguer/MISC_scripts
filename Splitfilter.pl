#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0; 
my $count4=0;
my $gap=10;
my @holder;
my %reads;
my %start;
my %end;
my %strand;
my %dupl;

###all in one
if (@ARGV != 1) {die "need 1 name";}
(my $in)=@ARGV;


open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.filtered") or die 'could not open output file';
#######

#print "analysing reads...\n";

while ($line=<IN>)
{
	
	chomp ($line);
	@holder = split (/ /, $line);
	if ($holder[0] ne "vulgar:"){next;}
	$count++;
    $holder[1] =~ /_/;
    
    if (defined $reads{$`}{$'})
    {
    $dupl{$`}="D";
    }
    $reads{$`}{$'}=$line;
    $start{$`}{$'}=$holder[6];
    $end{$`}{$'}=$holder[7];
    $strand{$`}{$'}=$holder[8];

}


for my $out (keys %reads)
{
 if ((defined $reads{$out}{A}) && (defined $reads{$out}{B}))
 {
  $count1++;
  if (defined $dupl{$out})
  { 
   $count2++;
   next;
  }
  if (abs($end{$out}{A} - $start{$out}{B}) <= $gap)
  {
   $count3++;
   next;
  }
  else
  {
   $count4++;
   print OUT "$reads{$out}{A}\n$reads{$out}{B}\n";
  } 
 }
}	
print "couples: $count1\n"; 
print "duplicated: $count2\n"; 
print "side by side: $count3\n"; 
print "promissing: $count4\n"; 


close IN;
close OUT;




 
