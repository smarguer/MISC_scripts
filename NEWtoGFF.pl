#!/usr/bin/perl
use strict;
use warnings;
#Input file
#################################################################################
 
if (@ARGV != 3) {die "need a  name and a size limit, and a tag";}
(my $in, my $size, my $source)=@ARGV;
 
open (IN, "$in") or die 'could not find the input file';
open (OUT, ">", "$in.gff") or die 'could not open output file';
########################
#Variables.
################################################################################
 
my $line=<IN>;
my @holder;
my $count=0; 
my $new=0;
my $i=0;
my $annot='.';

print OUT "seqname\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattributes\tName\torf_classification\tgene\tchr\n";


while ($line=<IN>)
{

 $count++;
 $new=0;
 $annot='.';

# print "$count\n";
 chomp($line);
 @holder=split(/\t/, $line);
 
 for ($i=7;$i <= $#holder;$i++)
 {
  if (($holder[$i] ne "NEW")&&($holder[$i] !~ /AS.SPNCRNA/))
  {
   if ($holder[$i] =~ /AS/)
   {
    $annot.=";".$holder[$i];    
    $new=2;
   #next;
   }
   else
   {
    $new=1;
    last;
   }
  } 
 }




###########
 unless ($holder[3] >= $size)
 {
  $new=1;
 }
############
 if ($new==1)
 {
  $new=0;
  $annot='.';
  next;
 }
 if ($new==2)
 {
  $annot=substr($annot,2); 
  print OUT "chr\t$source\tgene\t$holder[1]\t$holder[2]\t$holder[4]\t$holder[5]\t\.\t$annot\t$holder[0]\tAntisense\tNA\t$holder[6]\n";
  print OUT "chr\t$source\tmisc_RNA\t$holder[1]\t$holder[2]\t$holder[4]\t$holder[5]\t\.\t$annot\t$holder[0]\tAntisense\tNA\t$holder[6]\n";
 }
 if ($new==0)
 { 
  print OUT "chr\t$source\tgene\t$holder[1]\t$holder[2]\t$holder[4]\t$holder[5]\t\.\t$holder[7]\t$holder[0]\tNA\tNA\t$holder[6]\n";
  print OUT "chr\t$source\tmisc_RNA\t$holder[1]\t$holder[2]\t$holder[4]\t$holder[5]\t\.\t$holder[7]\t$holder[0]\tNA\tNA\t$holder[6]\n";
 }

}
close IN;
close OUT;



