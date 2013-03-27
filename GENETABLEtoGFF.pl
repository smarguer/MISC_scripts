#!/usr/bin/perl
use strict;
use warnings;
#Input file
#################################################################################
 
if (@ARGV != 1) {die "need a  name";}
(my $in)=@ARGV;
 
open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.gff") or die 'could not open output file';
########################
#Variables.
################################################################################
 
my $line=<IN>;
my @holder;
my $source="WT";
my $count=0; 
my $new=0;
my $i=0;
my $short="NA";

print OUT "seqname\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattributes\tName\torf_classification\tgene\tchr\n";


while ($line=<IN>)
{
 $count++;
# print "$count\n";
 chomp($line);
 @holder=split(/\t/, $line);
 if ($holder[5]==0)
 {
  $holder[6]=$holder[3];
  $holder[7]=$holder[4];
 }
 if ($holder[6] > $holder[3])
 {
  $holder[6]=$holder[3];
  $short="SHORT";
 } 
 if ($holder[7] < $holder[4])
 {
  $holder[7]=$holder[4];
  $short="SHORT";
 }
 


 print OUT "chr\t$source\tgene\t$holder[6]\t$holder[7]\t\.\t$holder[2]\t\.\t.\t$holder[0]\t$short\tNA\t$holder[1]\n";
 print OUT "chr\t$source\tmisc_RNA\t$holder[6]\t$holder[7]\t\.\t$holder[2]\t\.\t.\t$holder[0]\t$short\tNA\t$holder[1]\n";
 
# unless ($holder[8]==0)
# {
#  if ($holder[2] eq "+")
#  {
#   $holder[2] = "-";
#  }
#  else
#  {
#   $holder[2] = "+";
#  }
#
#  print OUT "chr\t$source\tgene\t$holder[9]\t$holder[10]\t\.\t$holder[2]\t\.\t.\tAS.$holder[0]\tNA\tNA\t$holder[1]\n";
#  print OUT "chr\t$source\tmisc_RNA\t$holder[9]\t$holder[10]\t\.\t$holder[2]\t\.\t.\tAS.$holder[0]\tNA\tNA\t$holder[1]\n";
# }
 $short="NA";
}
close IN;
close OUT;



