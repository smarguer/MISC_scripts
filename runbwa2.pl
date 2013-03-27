#!/usr/bin/perl

#wrapper for bwa, gets to sam file

use strict;
use warnings;
use Benchmark;
use Data::Dumper;

#inputs
my $use = "\nUse: $0 genome path fastq1 fastq2 isolate\n\n";
my ($genome,$path,$fastq1,$fastq2,$isolate) = @ARGV;
die $use unless (@ARGV == 5);
die $use unless (-e $genome and $path and -e "$path/$fastq1" and -e "$path/$fastq2" and $isolate);

my %status = ();
my $n = 1;

#time it
my $time0 = new Benchmark;

my $now = localtime;
print "Command: $0 @ARGV\ndate: $now\n"; 

#1 & 2: run aln using 4 threads
print "running: bwa aln -t 4 $genome $path/$fastq1 > $path/$fastq1.sai\n";
$status{$n} = system "bwa aln -t 4 $genome $path/$fastq1 > $path/$fastq1.sai";
die "Problem stage $n" if $status{$n}; $n++;

print "running: bwa aln -t 4 $genome $path/$fastq2 > $path/$fastq2.sai\n";
$status{$n} = system "bwa aln -t 4 $genome $path/$fastq2 > $path/$fastq2.sai";
die "Problem stage $n" if $status{$n}; $n++;

sleep 5 while ( !(-s "$path/$fastq2.sai") );

#run sampe
print "running: bwa sampe $genome $path/$fastq1.sai $path/$fastq2.sai $path/$fastq1 $path/$fastq2 > $path/$isolate.sam\n";
$status{$n} = system "bwa sampe $genome $path/$fastq1.sai $path/$fastq2.sai $path/$fastq1 $path/$fastq2 > $path/$isolate.sam";
die "Problem stage $n" if $status{$n}; $n++;

#calculate time taken
my $time1 = new Benchmark;
my $timdiff = timediff($time1, $time0);
print "Done. Took ", timestr($timdiff), " to run\noutput:$isolate.sam\n";
print "status outputs ", Dumper \%status, "\n\n";

