use strict;
use warnings;
use POSIX;

########################
if (@ARGV != 3) {die "need a file, a gff file, and a tag";}
(my $in, my $gff, my $tag)=@ARGV;
my $in1=$gff;
open (IN, $gff) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the input file';
open (IN2, $in1) or die 'could not find the input file';

open (OUT, ">", "$in.IV.map") or die 'could not open output file';
open (OUT1, ">", "$in.IV.map.short") or die 'could not open output file';
########################


my $line=<IN>;
my $line1;
my $line2=<IN2>;
my $mid;
my $gene;
my $strand;
my $genestrand1;
my $genestrand2;
my $count=0;
my $count1=0;
my $count2=1;
my $check=0;
my @holder;
my @holder1;
my @holder2;
my @holder3;
my $name;
my $length;
my $seg;
my $countmatch;
my $countstrand=1;
my $matchStart;
my $matchEnd;
my $start;
my $end;
my $i;

my %gffStart;
my %gffEnd;
my %gffChr;
my %gffStrand;
my %match;
my %out;
my $chr;
my $featureNumber;
my $first1;
my $first2;
my $first3;
my $last1;
my $last2;
my $last3;
my $last4;
my $prev;
my $counthits=0;
my $counthitshold=0;
my $w=0;
my $ww=1000000;
my %HIT;
my %HITstart;
my %HITend;
my %HITmid;
my %HITfirst1;
my %HITfirst2;
my %HITfirst3;
my %HITlast1;
my %HITlast2;
my %HITlast3;
my %HITlast4;
my %FINALHIT;

my %sense;
my %antisense;
my %count;
my %count1;
my %CDScount;
my %INTcount;
my @features=('CDS','misc_RNA','tRNA','snRNA','snoRNA','LTR','rRNA');
#my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','LTR','tRNA');
my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','promoter','rep_origin','polyA_signal','polyA_site','3\'UTR','5\'UTR','tRNA');
my $test;
my @done=();
my $hit;
my $ashit;
my %holder;
my $c=0;
my $keycount=0;
my $maxout;
my $map;
my @map;
my @new;

####################################################################
#Creates ref unsed to corrects for strand in exon and intron number
####################################################################

while ($line2=<IN2>)
{
 chomp ($line2);
 @holder2 = split (/\t/, $line2);

##debug##
#print "$holder2[9]\t$holder2[12]\n";
#########

#print "$holder2[12]";

 if (grep /$holder2[9]/, @excluded)
 {
  next; 
 } 	
 if ($holder2[9] eq "LTR")
 {
  $holder2[9] = "LTR.$holder2[3].$holder2[12]";
 }

 unless ($CDScount{$holder2[9]})
 {
  $CDScount{$holder2[9]}=0;
 }
 unless ($INTcount{$holder2[9]})
 {
  $INTcount{$holder2[9]}=0;
 }
 if (grep /$holder2[2]/, @features)
 {
 $CDScount{$holder2[9]}++;
 }
 elsif ($holder2[2] eq "intron")
 {
 $INTcount{$holder2[9]}++;
 }

}
close IN2;

#############################################################
##Reads gff and creates data structures for segment mapping
#############################################################
while ($line=<IN>)
{
 chomp ($line);
 @holder = split (/\t/, $line);
##debug##
#print "$holder[3]$holder[4]\n";
#print "$line\n";
########
 if (grep /$holder[9]/, @excluded)
 {
  next; 
 } 
 
 if ($holder[9] eq "LTR")
 {
  $holder[9] = "LTR.$holder[3].$holder[12]";
 }

 unless ($count{$holder[9]})
 {
  $count{$holder[9]}=0;
 }
 unless ($count1{$holder[9]})
 {
  $count1{$holder[9]}=0;
 }      
   
 if ($holder[2] eq "gene")
 {
  $gffStart{$holder[9]}=$holder[3];
  $gffEnd{$holder[9]}=$holder[4];
  $gffStrand{$holder[9]}=$holder[6];
  $gffChr{$holder[9]}=$holder[12];
  $count1=0;
 }

 elsif (grep /$holder[2]/, @features)
 {
  $count{$holder[9]}++;
  if ($holder[6] eq "+")
  {
   $sense{$holder[9]} = "+";
   $antisense{$holder[9]} = "-";
   $featureNumber=$count{$holder[9]};
  }
  elsif ($holder[6] eq "-")
  {
   $sense{$holder[9]} = "-";
   $antisense{$holder[9]} = "+";
   $featureNumber=abs($count{$holder[9]}-$CDScount{$holder[9]})+1;
  }

	 
  for ($i=$holder[3];$i<=$holder[4];$i++)
  {
    $hit="$holder[9].E$featureNumber";
    $ashit="AS.$holder[9].E$featureNumber";
    unless(grep /$hit/, @{$HIT{$holder[12]}{$i}{$sense{$holder[9]}}})
    {
     push @{$HIT{$holder[12]}{$i}{$sense{$holder[9]}}}, $hit;
    }
    unless(grep /$ashit/, @{$HIT{$holder[12]}{$i}{$antisense{$holder[9]}}})
    {
     push @{$HIT{$holder[12]}{$i}{$antisense{$holder[9]}}}, $ashit;
    }
  } 
 }
 
 elsif ($holder[2] eq "intron")
 {
  $count1++;
  $name="INTRON_".$holder[9]."_".$count1;
  $gffStart{$name}=$holder[3]+1;
  $gffEnd{$name}=$holder[4]-1;
  $gffStrand{$name}=$holder[6];
  $gffChr{$name}=$holder[12];       
  $count1{$holder[9]}++;
 
  if ($holder[6] eq "+")
  {
   $sense{$holder[9]} = "+";
   $antisense{$holder[9]} = "-";
   $featureNumber=$count1{$holder[9]};
  }
  elsif ($holder[6] eq "-")
  {
   $sense{$holder[9]} = "-";
   $antisense{$holder[9]} = "+";
   $featureNumber=abs($count1{$holder[9]}-$INTcount{$holder[9]})+1;
  }
  for ($i=($holder[3]+1);$i<=($holder[4]-1);$i++)
  {
    $hit="INTRON_$holder[9].I$featureNumber";
    $ashit="AS.INTRON_$holder[9].I$featureNumber";
    unless(grep /$hit/, @{$HIT{$holder[12]}{$i}{$sense{$holder[9]}}})
    {
     push @{$HIT{$holder[12]}{$i}{$sense{$holder[9]}}}, $hit;
    }
    unless(grep /$ashit/, @{$HIT{$holder[12]}{$i}{$antisense{$holder[9]}}})
    {
     push @{$HIT{$holder[12]}{$i}{$antisense{$holder[9]}}}, $ashit;
    }
  }
 } 

$featureNumber=0;
###

###

}
close IN;
##
#print $HIT{1}{1}{"+"}."\n";
#print $HIT{1}{1}{"-"}."\n";
##
print "gff parsed\n";

print OUT "Name\tstart\tend\tlength\tscore\tstrand\tchr\thit\n";
print OUT1 "Name\tstart\tend\tlength\tscore\tstrand\tchr\thit\n";

#####################################
#Reads exonerate output files and maps reads 
#####################################

while ($line1=<IN1>)
{
 $count++;
 %holder=();
 chomp ($line1);
 
# if ($count > $ww)
# {
#  print "$count2 ";
#  $ww=$count+1000000;
#  $count2++;
# }

##extract coordinates, chr, strand, and initialises a few things##
 @holder1 = split (/\t/, $line1);
 unless (@holder1==6)
 {
  next;
 }
 $strand=$holder1[4];
 $chr=$holder1[5];

 $seg="$tag.$holder1[0].$holder1[1].$holder1[4].$chr";
 $FINALHIT{$seg}=$chr;
 $i=0;
 $prev=0;
 $counthits=0;
 
 @holder3= ($holder1[0],$holder1[1]);
 if ($holder3[0] > $holder3[1])
 {
  @holder3=reverse(@holder3);
 }

 
##map read to annotation and print OUT###################
 for ($i=$holder3[0];$i <= $holder3[1];$i++)
 {

  if(defined @{$HIT{$chr}{$i}{$strand}})
  {

   foreach(@{$HIT{$chr}{$i}{$strand}})
   {
    $holder{$_}=1;
   }
  }
  
  else
  {
   $holder{"NEW"}=1;
  }
 }
########################################### 
 @map= keys %holder;
 @new= grep(/NEW|AS\./,@map);
 
 if(((scalar(@map)==1)&&($map[0] eq "NEW"))||(scalar(@map)==scalar(@new)))
 {
  $map="NEW";
 }
 
 else
 {
  $map="Annotated";
 }
############################################

 print OUT "$seg\t$holder1[0]\t$holder1[1]\t$holder1[2]\t$holder1[3]\t$holder1[4]\t$holder1[5]\t".join (";", keys %holder)."\n";
 print OUT1 "$seg\t$holder1[0]\t$holder1[1]\t$holder1[2]\t$holder1[3]\t$holder1[4]\t$holder1[5]\t$map\n";
# print  "$seg\t$holder3[0]\t$holder3[1]\t$strand\t$chr\t".join ("\t", keys %holder)."\n";
 
 if (scalar(keys %holder) > $keycount)
 {
  $keycount=scalar(keys %holder);
  $maxout="$seg\t$holder1[0]\t$holder1[1]\t$holder1[2]\t$holder1[3]\t$holder1[4]\t$holder1[5]\t".join (";", keys %holder)."\n";
 }
 undef %holder;
}
print "$keycount\n$maxout\n";
close OUT;
close OUT1;
close IN1;

