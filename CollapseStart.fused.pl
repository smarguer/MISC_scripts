#!/usr/bin/perl


use strict;
use warnings;
use POSIX;
my $line;
my $count=0;
my $count1=0;
my @holder;
my $chr;
my $start;
my $strand;
my %read;
#######################
#Takes input
#######################

if (@ARGV != 1) {die "I need a file";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';

######################################
#parses Exonerate output
######################################

while ($line=<IN>)
{
	
	chomp ($line);

	@holder = split (/\t/, $line);

################################################################################
    $chr=$holder[10];
    $strand=$holder[9];
    $start=$holder[8]; 
#    print "$chr\n";

    if(exists $read{$chr}{$strand}{$start})
    {
     $read{$chr}{$strand}{$start}++;
    }
    else
    {
     $read{$chr}{$strand}{$start}=1;
    }
}


for my $c_out (sort { lc($a) cmp lc($b) } keys %read)
 {
  for my $s_out (keys %{$read{$c_out}})
   {
    for my $start_out (sort { $a <=> $b } keys %{$read{$c_out}{$s_out}})
     {
      print "$c_out\t$s_out\t$start_out\t$read{$c_out}{$s_out}{$start_out}\n";
     }
   }
 }



	close IN;
