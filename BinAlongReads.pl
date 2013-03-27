use strict;
use warnings;
use POSIX;

########################
if (@ARGV != 1) {die "just need a mapping  output file";}
(my $in)=@ARGV;
open (IN, $in) or die 'could not find the input file';

open (OUT1, ">", "$in.BIN.chr1") or die 'could not open output file';
open (OUT2, ">", "$in.BIN.chr2") or die 'could not open output file';
open (OUT3, ">", "$in.BIN.chr3") or die 'could not open output file';
########################


my $line=<IN>;
my @holder1;
my @holder3;
my %reads;
my $binSize=200;
my $step=50;
my $strand;
my $chr;
my $start;
my $end;
my $count=0;
my $i;

####################################################################
#Creates ref unsed to corrects for strand in exon and intron number
####################################################################

print "Bining reads...\n";

while ($line=<IN>)
{
 $count++;

#print "$count\n";

 chomp ($line);
##extract coordinates, chr, strand, and initialises a few things##
 @holder1 = split (/ /, $line);
 if ($holder1[0] ne "vulgar:"){next;}
 $strand=$holder1[8];
 $chr=substr($holder1[5],2,1);
 @holder3= ($holder1[6],$holder1[7]);
 if ($holder3[0] > $holder3[1])
 {
  @holder3=reverse(@holder3);
 }
 
 $start=ceil(($holder3[0]/$binSize));
 $end=ceil(($holder3[1]/$binSize));
 
 if(exists $reads{$chr}{$strand}{$start})
 {
  $reads{$chr}{$strand}{$start}++;
 }
 else
 {
  $reads{$chr}{$strand}{$start}=1;
 }
 if($start != $end)
 {
  if(exists $reads{$chr}{$strand}{$end})
  {
   $reads{$chr}{$strand}{$end}++;
  }
  else
  {
   $reads{$chr}{$strand}{$end}=1;
  }
 }
}

print "printing...\n";
print "chr1...\n";
my $chr1=5579133/$binSize;
my $chr2=4539804/$binSize;
my $chr3=2452833/$binSize;
print OUT1 "bin.start\tbin.end\tplus.count\tminus.count\n";
print OUT2 "bin.start\tbin.end\tplus.count\tminus.count\n";
print OUT3 "bin.start\tbin.end\tplus.count\tminus.count\n";

for($i=1;$i<=$chr1;$i++)
{
print OUT1 (($i*$binSize)-200)."\t".((($i*$binSize)+$binSize)-200)."\t";

if(exists $reads{1}{'+'}{$i})
{
 print OUT1 $reads{1}{'+'}{$i}."\t";
}
else
{
 print OUT1 "0\t";
}
if(exists $reads{1}{'-'}{$i})
{
 print OUT1 $reads{1}{'-'}{$i}."\n";
}
else
{
 print OUT1 "0\n";
}

}
print "chr2...\n";
for($i=1;$i<=$chr2;$i++)
{
print OUT2 (($i*$binSize)-200)."\t".((($i*$binSize)+$binSize)-200)."\t";

if(exists $reads{2}{'+'}{$i})
{
 print OUT2 $reads{2}{'+'}{$i}."\t";
}
else
{
 print OUT2 "0\t";
}
if(exists $reads{2}{'-'}{$i})
{
 print OUT2 $reads{2}{'-'}{$i}."\n";
}
else
{
 print OUT2 "0\n";
}
}
print "chr3...\n";
for($i=1;$i<=$chr3;$i++)
{
print OUT3 (($i*$binSize)-200)."\t".((($i*$binSize)+$binSize)-200)."\t";

if(exists $reads{3}{'+'}{$i})
{
 print OUT3 $reads{3}{'+'}{$i}."\t";
}
else
{
 print OUT3 "0\t";
}
if(exists $reads{3}{'-'}{$i})
{
 print OUT3 $reads{3}{'-'}{$i}."\n";
}
else
{
 print OUT3 "0\n";
}
}


close OUT1;
close OUT2;
close OUT3;
close IN;

