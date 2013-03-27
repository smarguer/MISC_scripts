#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 1) {die "need a go definition file";}
(my $go)=@ARGV;

open (IN, $go) or die 'could not find the go definition file';


my $line;
my $out="id\tname\tdef\talt_id\tis_a\n";
my @alt_id=();
my @is_a=();

while ($line=<IN>)
{
 chomp ($line);
 if($line =~ /^id\:\s{1}/)
 {
  $out=$';
 }
 elsif($line =~ /^name\:\s{1}/)
 {
  $out.="\t".$';
 }
 elsif($line =~ /^alt_id\:\s{1}/)
 {
  push(@alt_id,$');
 }
 elsif($line =~ /^def\:\s{1}/)
 {
  $out.="\t".$';
 }
 elsif($line =~ /(^is_a\:\s{1})(GO\:\d+)/)
 {
  push(@is_a,$2);
 }
 elsif(!$line)
 { 
  $out.="\t".join(';',@alt_id)."\t".join(';',@is_a)."\n";
  print "$out";
  @alt_id=();
  @is_a=();
 }
}


close IN;

