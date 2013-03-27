#!/usr/bin/perl;



use strict;
use warnings;

if (@ARGV != 1) {die "need 1 file names";}
(my $in)=@ARGV;

open (IN, "$in.csfasta") or die 'could not find the input file';
open (IN1, $in."_QV.qual") or die 'could not find the input file';
open (OUT, ">", "$in.fastq") or die 'could not open output file';


my $line;
my $line1;
my $count=0;
my $count1=0;
my %out;
my $name='no';
my $out1;
my $out2;
my @holder;
my $i;


#print "reading\n";

while ($line=<IN>)
{
 $count++;
# print "$count\n";
 chomp ($line);
 
 if ($line =~ /[#]/)
 {
  next;
 }
 
 elsif ($line =~ /[>]/)
 {
  $name=$line;
 }
 
 else
 {
  $out{$name}{1}=$line;
  $name='no';
 }
}

while ($line1=<IN1>)
{

 $count1++;
# print "$count1\n";

 chomp ($line1);
 
 if ($line1 =~ /[#]/)
 {
  next;
 }
 
 elsif ($line1 =~ /[>]/)
 {
  $name=$line1;
 }
 
 else
 {
  @holder=split(/ /,$line1);
  @holder=map(abs,@holder);
  @holder=map($_+33,@holder);
  @holder=map(chr,@holder);   
  $out{$name}{2}=join('',@holder);
  $name='no';
 }
}


####

#print "printing\n";

for $out1 (keys %out)
{
$out2=substr($out1,1,length($out1));
print OUT "$out2\n$out{$out1}{1}\n+\n$out{$out1}{2}\n";
}

close IN;
close IN1;
close OUT;






