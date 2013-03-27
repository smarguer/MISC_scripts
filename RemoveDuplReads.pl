#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $header;
my %read;
my %counter;
my %checked;

if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';

while ($line=<IN>)
{
	$count++;
	if ($count == 1)
	{
	 $header="$line";
	}
	elsif ($count == 2)
	{
	 if($read{$line})
         {
	  $read{$line}++; 
################################
#extract highly duplicated reads
#unless($checked{$line})
#{
# if ($read{$line}>10000)
# {
#  print "$line";
#  $checked{$line}=1
# }
#}
###############################


          $count=0;
          next;
         }
         else
         {
          $read{$line}=1;
          print OUT $header.$line;
	  $count=0;
         }
	}
}	
        for my $dup (keys %read)
        {
         if($counter{$read{$dup}})
         {
          $counter{$read{$dup}}++;
         }
         else
         {
          $counter{$read{$dup}}=1;
         }
        }
        for my $out1 (sort  {$a <=> $b} keys %counter)
        {   
         print $out1."\t".$counter{$out1}."\n";
        }


close IN;
close OUT;


