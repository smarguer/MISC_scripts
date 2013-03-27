#!/usr/bin/perl


use strict;
use warnings;
use List::Util qw[min max];

if (@ARGV != 1) {die "need a gff file and a .ALLtrs file";}
(my $gff, my $in)=@ARGV;

open (IN, $gff) or die 'could not find the gff file';
open (OUT, ">", "$gff.CHOPPED") or die 'could not open output file';


my $line;

while ($line=<IN>)
{
 chomp ($line);
 chop ($line);
 print OUT "$line\n";
}


close IN;
close OUT;

