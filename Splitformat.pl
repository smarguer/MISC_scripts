#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0; 
my $count4=0;
my @holder;
my %reads;
my %start;
my %end;
my %strand;
my %dupl;
my %numstart;
my %numend;
my @name;
my $name;

###all in one
if (@ARGV != 1) {die "need 1 name";}
(my $in)=@ARGV;


open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.intra") or die 'could not open output file';
open (OUT1,">", "$in.inter") or die 'could not open output file';

#######

#print "analysing reads...\n";

while ($line=<IN>)
{
	
	chomp ($line);
	@holder = split (/\t/, $line);
	$count++;
    @name= split /_/, $holder[0];
    $name=$name[0]; 
#print "$holder[0]\n";

 
    if ($holder[0] =~ /_A/)
    {
     $holder[1] =~ /\.E/;
     $reads{$name}{A}=$line;
     $start{$name}{A}=$`;
     $numstart{$name}{A}=$';
	}
    elsif ($holder[0] =~ /_B/)
    {
    $holder[1] =~ /\.E/;
     $reads{$name}{B}=$line;
     $start{$name}{B}=$`;
     $numstart{$name}{B}=$';
    }
    if ($holder[0] =~ /_A/)
    {
    $holder[2] =~ /\.E/;
     $reads{$name}{A}=$line;
     $end{$name}{A}=$`;
     $numend{$name}{A}=$';
    }
    elsif ($holder[0] =~ /_B/)
    {
    $holder[2] =~ /\.E/;
     $reads{$name}{B}=$line;
     $end{$name}{B}=$`;
     $numend{$name}{B}=$';
    }
}


for my $out (keys %reads)
{
 unless ((defined $reads{$out}{A})&&(defined $reads{$out}{B}))
 {
  print "$out\n";
  next;
 } 
 if ($start{$out}{A} eq $start{$out}{B})
 {
  #print OUT "$reads{$out}{A}\t$reads{$out}{B}\n";
  print OUT "$out\t$start{$out}{A}\t$numstart{$out}{A}\t$numend{$out}{A}\t$start{$out}{B}\t$numstart{$out}{B}\t$numend{$out}{B}\n";

 }
 else
 {
  print OUT1 "$out\t$start{$out}{A}\t$numstart{$out}{A}\t$numend{$out}{A}\t$start{$out}{B}\t$numstart{$out}{B}\t$numend{$out}{B}\n";
 }
} 


close IN;
close OUT;




 
