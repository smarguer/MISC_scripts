#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 1) {die "need a gff file and a .ALLtrs file";}
(my $gff)=@ARGV;

open (IN, $gff) or die 'could not find the gff file';
open (OUT, ">", "$gff.REPAIRED") or die 'could not open output file';


my $line;
my @holder;

while ($line=<IN>)
{
 chomp ($line);
# chop ($line);
 @holder=split(/\t/,$line);
 print "$#holder\n";
 print OUT "$line\n";
}


close IN;
close OUT;

