#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 2) {die "need a file and an index sequence and a tag";}
(my $in,my $index)=@ARGV;

open (IN, $in) or die 'could not find the fastq file';
open (OUT, ">", $in."_".$index.".txt") or die 'could not open output file';


my $line;
my $count00=0;
my $count0=0;
my $count1=0;
my $count2=0;
my $count3=0;
my $count4=0;
my $count5=0;
my $count6=0;
my $count7=0;
my $count8=0;
my $count9=0;
my $count10=0;
my $count11=0;
my $count12=0;
my $title;

my $indexM2=substr $index,-2,2;
my $indexM1=substr $index,-3,3;

if ($index =~ /N/)
{
 $index =~ s/N/\[ATCGN\]/g;
}
if ($indexM1 =~ /N/)
{
 $indexM1 =~ s/N/\[ATCGN\]/g;
}
if ($indexM2 =~ /N/)
{
 $indexM2 =~ s/N/\[ATCGN\]/g;
}


#print "$index\n$indexM1\n$indexM2\n";
#die;

while ($line=<IN>)
{
 $count00++;
 if ($line =~ /^[ATCGN][ATCGN][ATCGN]$index/)
 {$count5++;}
 elsif ($line =~ /^[ATCGN][ATCGN]$index/)
 {$count4++;}
 elsif ($line =~ /^[ATCGN]$index/)
 {$count3++;}
 elsif ($line =~ /^$index/)
 {$count2++;}
 elsif ($line =~ /^$indexM2/)
 {$count0++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count6++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count7++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count8++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count9++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count10++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count11++;}
 elsif ($line =~ /^[ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN][ATCGN]$index/)
 {$count12++;}
 elsif ($line =~ /^$indexM1/)
 {$count1++;}
 elsif($line =~ /@/)
 {$title=$line;}
 else
 {print $title.$line;}

}
$count00=$count00/2;
print OUT 
"Base\t$index\tperc\n"."-2\t$count0\t".($count0/$count00*100)."\n"."-1\t$count1\t".($count1/$count00*100)."\n"."0\t$count2\t".($count2/$count00*100)."\n"."1\t$count3\t".($count3/$count00*100)."\n"."2\t$count4\t".($count4/$count00*100)."\n"."3\t$count5\t".($count5/$count00*100)."\n"."4\t$count6\t".($count6/$count00*100)."\n"."5\t$count7\t".($count7/$count00*100)."\n"."6\t$count8\t".($count8/$count00*100)."\n"."7\t$count9\t".($count9/$count00*100)."\n"."8\t$count10\t".($count10/$count00*100)."\n"."9\t$count11\t".($count11/$count00*100)."\n"."10\t$count12\t".($count12/$count00*100)."\n";




close IN;
close OUT;


