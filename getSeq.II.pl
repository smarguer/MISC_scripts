#!/usr/bin/perl


use strict;
use warnings;

my $line1;

my %seq;
my $current;
my $length;

my $start=0;
my $end=0;
my $strand="+";
my $pos;
my $int;
my $chr;

#######################
#Takes input
#start,end, and chromosome
#######################

if (@ARGV != 4) {die "need 4 arguments";}

#alterantive 1;
#($start, $end, $chr)=@ARGV;

#altereantive 2;
($pos, $int, $chr, $strand)=@ARGV;

open (IN1, "/jurg/homedir/samuel/POMBE_SEQ/analysis/ALLchromosomes.str") or die 'could not find the chromosome file';

########################
#reads in the chromosome fasta file
########################



while ($line1=<IN1>)
{
 chomp($line1);
 if ($line1 =~ />/)
 {
  $seq{$line1}=0;
  $current=$line1;
 }
 else
 {
  $seq{$current}=$line1;
 }
}
######################
#prints sequence
######################
if ($chr == 1){$chr = ">CH1_bases"}
elsif($chr == 2){$chr = ">CH2_bases"}
elsif($chr == 3){$chr = ">CH3_bases"}
elsif($chr == 4){$chr = ">MIT_bases"}
elsif($chr == 5){$chr = ">MAT_bases"}

$length=$end-$start;

my $int1=$int;

my $length1=$pos-$int;
if ($length1 < 0) 
{
$length1=0;
$int=$pos;
}

my $length2=$pos+$int;
if ($length2 > length($seq{$chr}))
{
$int1=length($seq{$chr})-$pos;
$length2=$pos+$int1;
}

#alterantive 1;
#print "$chr\n$start\n".substr($seq{$chr},$start,$length)."\n$end\n";
#alterantive 2;

my $out=substr($seq{$chr}, $length1, $int).uc(substr($seq{$chr},$pos,1)).substr($seq{$chr}, ($pos+1), $int1);

if ($strand eq "-")
{
$out=reverse($out);
$out=~ tr/ACGTacgt/TGCAtgca/;
}

print "$chr\n$length1\n";
print "$out\n";
print "$length2\n";

close IN1;





