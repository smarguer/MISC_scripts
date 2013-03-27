#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 1) {die "need just a gff";}
(my $gff)=@ARGV;

open (IN, $gff) or die 'could not find fasta file 1';

my $line=<IN>;
my $randomNumber;
my $chr;
my %read;
my %map;
my %seq;
my $out;
my $len;
my $rev;
my $name=0;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my $exon;
my @holder;
my @coord;
my %chr;
my %trs;
my %five;
my %three;
my %poly;
my %strand;
my %ORFstart;
my %ORFend;
my %CDSstart;
my %CDSend;
my @included=("rRNA","snoRNA","tRNA","snRNA","CDS","misc_RNA","LTR");

while($line=<IN>)
{
 chomp($line);
 @holder=split(/\t/,$line);
 
 @coord=($holder[3],$holder[4]);

 #if($holder[6] eq "-")
 #{
 # @coord=reverse(@coord);
 #}

 if ($holder[9] eq 'LTR')
 {
  $name="LTR.".$holder[3].'.'.$holder[6].'.'.$holder[12];
 }
 else
 {
  $name=$holder[9];
 }

##
#print "@coord\n";
## 
 if ($holder[2] eq "gene")
 {
  $chr{$name}=$holder[12];
  $strand{$name}=$holder[6];

  $ORFstart{$name}=$coord[0];
  $ORFend{$name}=$coord[1];
 }

 elsif($holder[2] eq "5\'UTR")
 {
  if($holder[6] eq '+')
  {
   $five{$name}=$coord[0];
  }
  elsif($holder[6] eq '-')
  {
   $three{$name}=$coord[1];
  }
 }

 elsif($holder[2] eq "3\'UTR")
 {
  if($holder[6] eq '+')
  {
   $three{$name}=$coord[1];
  }
  elsif($holder[6] eq '-')
  {
   $five{$name}=$coord[0];
  }
 }

 elsif(grep(/$holder[2]/,@included))
 {
#  print "$holder[2]\n";
  push (@{$CDSstart{$name}},$coord[0]);
  push (@{$CDSend{$name}},$coord[1]);
 }
}

######

foreach(keys %ORFstart)
{
 $name=$_;
 $exon=@{$CDSstart{$name}};
 @{$CDSstart{$name}}=join(',',@{$CDSstart{$name}});
 @{$CDSend{$name}}=join(',',@{$CDSend{$name}});
 unless(exists $five{$name})
 {
  $five{$name}=$ORFstart{$name};
 }
 unless(exists $three{$name})
 {
  $three{$name}=$ORFend{$name};
 }
 
 print "$name\tchr$chr{$name}\t$strand{$name}\t$five{$name}\t$three{$name}\t$ORFstart{$name}\t$ORFend{$name}\t$exon\t@{$CDSstart{$name}}\t@{$CDSend{$name}}\t$name\n";
}

close IN;



















