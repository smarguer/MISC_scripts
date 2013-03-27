#!/usr/bin/perl

use strict;
use warnings;
use Benchmark;
use Data::Dumper;
use POSIX qw(strftime);
my %transTime=('Jan'=>'01','Feb'=>'02','Mar'=>'03','Apr'=>'04','May'=>'05','Jun'=>'06','Jul'=>'07','Aug'=>'08','Sep'=>'09','Oct'=>'10','Nov'=>'11','Dec'=>'12');
my @today=split /\s/,(localtime);

print "@today\n$today[4]\n";

if ($today[2] !~ /\d{2}/)
{
 $today[2]="0".$today[2];
}


#inputs
my $use = "\nUse:\n-o: options (default PCTVRS, see readme.txt)\n-gp: gff path (/jurg/homedir/samuel/POMBE_SEQ/analysis/)\n-qp: fastq path (default current directory)\n-q: fastq name (NO DEFAULT)\n-g: gff name (default gff_090511.txt)\n-r: read length (default 50)\n-t: tag (default today's date (".$today[2].$transTime{$today[1]}.substr($today[4],2,2)."))\n\n";
##-o
my $options="PCTVRS";
##-gp
my $gffp = "/jurg/homedir/samuel/POMBE_SEQ/analysis/";
##-qp
my $fastqp = "./";
##-q
my $fastq;
##-g
my $gff = "gff_090511.txt";
##-r
my $read = "50";
##-t
my $tag = $today[2].$transTime{$today[1]}.substr($today[4],2,2);

my $readinput;

die $use unless (defined(@ARGV));

while (defined($readinput=shift))
{

 die $use unless ($readinput =~ /-/);


 if($readinput eq '-o')
 {
  $options=shift;
 }

 if($readinput eq '-gp')
 {
  $gffp=shift;
 }

 if($readinput eq '-qp')
 {
  $fastqp=shift;
 }

 if($readinput eq '-q')
 {
  $fastq=shift;
 }

 if($readinput eq '-g')
 {
  $gff=shift;
 }

 if($readinput eq '-r')
 {
  $read=shift;
 }

 if($readinput eq '-t')
 {
  $tag=shift;
 }
}

die "\ngff file with unexpected name structure please use ".'"'."gff_DDMMYY.txt".'"'."\n$use\n" unless ($gff =~ /gff_\d{6}\.txt/);
die "\n-q option missing with no default\n$use\n"  unless (defined($fastq));
#print "$options\n$gffp\n$fastqp\n$fastq\n$gff\n$read\n$tag\n";
print "Let's go!\n";








