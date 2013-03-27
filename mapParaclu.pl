use strict;
use warnings;
use POSIX;

########################
if (@ARGV !=2) {die "need two files";}
(my $in, my $cage)=@ARGV;

open (IN, $cage) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the input file';

open (OUT, ">", "$in.mapParaclu") or die 'could not open output file';
#open (OUT, ">", "test.CUF") or die 'could not open output file';
########################


my $line=<IN>;
my $line1=<IN1>;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my @holder;
my @holder1;
my %HIT;
my %DUP;
my $chr;
my $strand;
my $range;
my @range;
my $dup=0;
my @dup;

####################################################################
#Creates ref unsed to corrects for strand in exon and intron number
####################################################################

while ($line=<IN>)
{

 $count1++;
 #print "$count1\n";

 chomp ($line);
 @holder = split (/\t/, $line);
 $chr=substr($holder[0],3);
 $strand=$holder[1];
 @range=($holder[2]..$holder[3]);
 foreach $range (@range)
 {
  if (exists $HIT{$chr}{$strand}{$range})
  {
   $dup=$DUP{$range};
   
   if(@dup)
   {
    unless ($dup == $dup[-1])
    {
     @dup=push (@dup,$dup);
    }
   }
   else
   {
    @dup=($dup);
   }
   #print "overlapping clusters..!?..\n";
   $HIT{$chr}{$strand}{$range}="overlapping clusters..!?..";
  }
  else
  {
   $HIT{$chr}{$strand}{$range}=$line;
   $DUP{$range}=$count1;
  }
 }
 if($dup !=0)
 {
  $count2++;
  #print "cluster ".$count1." overlaps cluster(s): $dup\n"; 
  #print "+";
 }
 @range=();
 @dup=();
 $dup=0;
}
close IN;
print "paraclu output parsed\n";

#####################################
#Reads exonerate output files and maps reads 
#####################################

while ($line1=<IN1>)
{
 $count++;

 chomp ($line1);
 @holder1 = split (/\t/, $line1);
 if(exists $HIT{$holder1[10]}{$holder1[9]}{$holder1[8]})
 {
  print OUT $line1."\t".$HIT{$holder1[10]}{$holder1[9]}{$holder1[8]}."\n";
 }
 else
 {
  $count3++;
  #print "*";
  #print $line1."\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n";
 }
}
print "$count1 clusters parsed\n";
print "$count2 overlapping clusters indentified\n";
print "$count reads analysed\n";
print "$count3 reads had no assigned cluster\n";

close OUT;
close IN1;

