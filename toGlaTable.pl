#!/usr/bin/perl
use strict;
use warnings;
#Input file
#################################################################################
 
if (@ARGV != 1) {die "need a  name";}
(my $in)=@ARGV;
 
open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.gla.table.txt") or die 'could not open output file';
########################
#Variables.
################################################################################
 
my $line;
my @holder;
my $enriched;
my $count=0; 
my $new=0;
my $i=0;
my $short="NA";
my $out;
my $list;
my $all=0;
my $pval=0;
my $what=0;
print OUT "list\twhat\tpercent.in.list\tpercent.all\tp-value\n";

while ($line=<IN>)
{
 $count++;
# print "$count\n";
 chomp($line);
 @holder=split(/\t/, $line);
 if (@holder == 0)
 {
  next;
 }
 if (@holder == 1)
 {
  if ($holder[0]=~ /\w{1,}/)
  {
  print OUT "\n#$holder[0]\n";
  }
  next;
 } 
 
 if ($holder[1]=~ /underrepresented/) {next;}
 $holder[1]=~ /(enriched|lower|higher|equal)/;
 $what=$1;
 if ($holder[1]=~ /e\+/)
 {
 $list="NA";
 $all="NA";
 }
 elsif ($holder[1]=~ /(\d{1,}\.{0,1}\d{0,})\D{1,}(\d{1,}\.{0,1}\d{0,})/)
 {
 $list=$1;
 $all=$2;
 }
 else
 {
 $list="NA";
 $all="NA";
 }
 $holder[3]=~ /(\d{1,}\.{1}\d{1,})/;
 $pval=$1; 

 print OUT "$holder[0]\t$what\t$list\t$all\t$pval\n";

}
close IN;
close OUT;



