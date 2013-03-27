#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $line1;
my @holder;
my %name;

my $count=0;
my $count1=0; 
my $count2=0;
my $count3=0;
my $count4=0;
my %counter;
my $seq=0;
my $header=0;
my $Average;
my $i;
my $out1=0;
my $out2=0;
my @qual_table;
my @out;
my %average;
my $readaverage=0;
my $list=0;
my $n=1000000;



if (@ARGV == 1)
{
(my $in)=@ARGV;

open (IN, "$in.fastq") or die 'could not find the input file';
#open (OUT, ">", "$in.fasta") or die 'could not open output file';
open (OUT1, ">", "$in.qualtable") or die 'could not open output file'; 
open (OUT2, ">", "$in.qualaverage") or die 'could not open output file';
}

elsif (@ARGV == 2)
{
 (my $in, my $in1)=@ARGV;

 open (IN, "$in.fastq") or die 'could not find the input file';
 open (IN1,"$in1") or die 'could not find the mapping file';
 #open (OUT, ">", "$in.fasta") or die 'could not open output file';
 open (OUT1, ">", "$in.map.qualtable") or die 'could not open output file'; 
 open (OUT2, ">", "$in.map.qualaverage") or die 'could not open output file';

print "reading mapping file...\n";

 while ($line1=<IN1>)
 {
  @holder = split (/ /, $line1);
  unless ($holder[0]){next;}
  if ($holder[0] ne "vulgar:"){next;}
  $name{$holder[1]}=1;
#print "$holder[1]\n";
 }

close IN1;
$list=1;
}

while ($line=<IN>)
{
 $count++;
 $count4++;
#print "$count\n";

if ($count4 > $n)
{
print "$count4\n";
$n=$n+1000000;
}

#if (($count == 1) & ($list==1))
# {
#print "$line\n";
# }



 if (($count == 1) & ($list==1))
 {
  chomp ($line);
  if(defined $name{$line})
  {
#print "defined\n";
   $count3=0;
   next;
  }
  else
  {
   $count3=7;
   next;
  }  
 }
   
 elsif ($count == 4)
#    if ($count == 4)
 {
  if ($count3==7)
  {
$count=0;
$seq=0;
$header=0;
$Average=0;
next;
  }
  else
  {   
  $count2++;
  chomp($line);
  my @char=split(//,$line);
  my @qual=map(ord,@char);
  @qual=map($_-33,@qual);
	
  for ($i=0; $i<=$#qual; $i++)
  {
   $qual_table[$i]{$qual[$i]}++;
     
#print "$qual[$i]\n";
#print "$qual_table[$i]{$qual[$i]}\n";
#print "@{$qual_table[$i]}\n";
                 
   $Average+=$qual[$i];
  }
	
 	 $readaverage=int((($Average/($#qual+1))+0.5));
	 if ($average{$readaverage})
	 {
	 $average{$readaverage}++;
	 }
         
	 else
	 {
	 $average{$readaverage}=1;
	 }
	 
	 $count=0;
	 $seq=0;
	 $header=0;
	 $Average=0;
    }
  
}
}
####print out qual table######################################

print "printing qual table...\n";

for ($i=0; $i<=$#{@qual_table}; $i++)
{
           for ($out1=1;$out1<=50;$out1++)
 	   {
	   $out[$i][($out1-1)]=0;
   	   }
           

	   for ($out1=1;$out1<=50;$out1++)
 	   {
	    if ($qual_table[$i]{$out1})
	    {
             $out[$i][($out1-1)]=$qual_table[$i]{$out1};
            }
           }
           print OUT1 join ("\t",@{$out[$i]})."\n";
}

####print average file###########################################

print "printing average file...\n";

for ($out2=1;$out2<=50;$out2++)
{
if ($average{$out2})
{
print OUT2 "$out2\t$average{$out2}\n";
}
else
{
print OUT2 "$out2\t0\n";
}
}
#################################################################

for my $out (sort keys %counter)
{
if ($counter{$out} > 1)
{
$count1++;
}
if ($count1 != 0)
{
print "$count1\n";
}
}
close IN;
#close OUT;
close OUT1;
close OUT2;
