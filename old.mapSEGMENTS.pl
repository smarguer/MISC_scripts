use strict;
use warnings;


########################
if (@ARGV != 2) {die "need a file and a gff file";}
(my $in, my $gff)=@ARGV;
my $in1=$gff;
open (IN, $gff) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the input file';
open (IN2, $in1) or die 'could not find the input file';

open (OUT, ">", "$in.map") or die 'could not open output file';
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
my $check=0;
my @holder;
my @holder1;
my @holder2;
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

my %HIT;
my %HITstart;
my %HITend;

my %sense;
my %antisense;
my %count;
my %count1;
my %CDScount;
my %INTcount;
my @features=('CDS','misc_RNA','tRNA','snRNA','snoRNA','LTR','rRNA','mRNA');
#my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','LTR','tRNA');
my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','3\'UTR','5\'UTR','tRNA');

####################################################################
#Creates ref unsed to corrects for strand in exon and intron number
####################################################################

while ($line2=<IN2>)
{
 chomp ($line2);
 @holder2 = split (/\t/, $line2);
 if (grep /$holder2[9]/, @excluded)
 {
  print "$line2\n";
  next; 
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
 if (grep /$holder[9]/, @excluded)
 {
  next; 
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
 elsif (grep /$holder2[2]/, @features)
 {


#
##
###
#print "$line\n";  
###
##
#  


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
   $HIT{$holder[12]}{$i}{$sense{$holder[9]}}="$holder[9].E$featureNumber";
   $HIT{$holder[12]}{$i}{$antisense{$holder[9]}}="AS.$holder[9].E$featureNumber";
#print "$HIT{$holder[12]}{$i}{$antisense{$holder[9]}}\n";	 
  } 
 }
 
 elsif ($holder[2] eq "intron")
 {
  $count1++;
  $name="INTRON_".$holder[9]."_".$count1;
  $gffStart{$name}=$holder[3];
  $gffEnd{$name}=$holder[4];
  $gffStrand{$name}=$holder[6];
  $gffChr{$name}=$holder[12];       
#"fine mapping"        
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
  for ($i=$holder[3];$i<=$holder[4];$i++)
  {
   $HIT{$holder[12]}{$i}{$sense{$holder[9]}}="INTRON_$holder[9].I$featureNumber";
   $HIT{$holder[12]}{$i}{$antisense{$holder[9]}}="AS.INTRON_$holder[9].I$featureNumber";
  } 
 }
$featureNumber=0;
}

print "gff parsed\n";

#####################################
#Reads .SEG files and maps segments 
#####################################

while ($line1=<IN1>)
{

 $count++;
 chomp ($line1);

 @holder1 = split (/\t/, $line1);
 unless (@holder1==6)
 {
  next;
 }
 $strand=$holder1[4];
 $chr=$holder1[5];
		
 if ($chr==1)
 {
  $length=5579133;
 }
 elsif ($chr==2)
 {
  $length=4539804;
 }
 elsif ($chr==3)
 {
  $length=2452883;
 }
#	
		

 $seg="SEG.$holder1[0].$holder1[1].$holder1[4].$chr";
 #$holder1[3]=sprintf("%.2f",$holder1[3]);
 $mid=$holder1[0] +(($holder1[1]-$holder1[0])/2);

#########################
#finds start and end hits
#########################

 if (defined %{$HIT{$chr}{$holder1[0]}})
 {
  $HITstart{$seg}=$HIT{$chr}{$holder1[0]}{$holder1[4]};
 }
 else
 {
  $HITstart{$seg}="INTERGENIC";
 }

 if (defined %{$HIT{$chr}{$holder1[1]}})
 {
  $HITend{$seg}=$HIT{$chr}{$holder1[1]}{$holder1[4]};
 }
 else
 {
  $HITend{$seg}="INTERGENIC";
 }

#################################
#Original 'overlap style' mapping
#################################
                
		
 for $gene (sort keys %gffStart)
 {
#print "$mid\n";
  if ($gffChr{$gene} ne $chr) {next;}
  if (
     ($mid >= $gffStart{$gene} && $mid <= $gffEnd{$gene})||
     ($holder1[0] >= $gffStart{$gene} && $holder1[0] <= $gffEnd{$gene})||
     ($holder1[1] >= $gffStart{$gene} && $holder1[1] <= $gffEnd{$gene})||
     ($holder1[0] <= $gffStart{$gene} && $holder1[1] >= $gffEnd{$gene})
     )
  {
   $genestrand1=$gffStrand{$gene};
   if ($match{$seg})
   {
    if($match{$seg}=~/INTRON_./){$match{$seg}=$gene;}
    unless(($gene=~/INTRON_./)||($match{$seg}=~/$gene/))
    {
     $match{$seg}=$match{$seg}.";".$gene;
     $countmatch++;
     if (($genestrand2 ne 0)&&($genestrand1 ne $genestrand2))
     {
      $countstrand++;
     }
     $genestrand2=$genestrand1;
    }
    $end=$gffEnd{$gene};
    $matchEnd=$holder1[1]-$gffEnd{$gene};						
   }
   else 
   {
    $match{$seg}=$gene;
    $countmatch=1;
    $start=$gffStart{$gene};
    $end=$gffEnd{$gene};
    $matchStart=$gffStart{$gene}-$holder1[0];
    $matchEnd=$holder1[1]-$gffEnd{$gene};
   }
   $out{$seg}="$seg\t$holder1[0]\t$holder1[1]\t$holder1[2]\t$holder1[3]\t$holder1[4]\t$match{$seg}\t$start\t$end\t$matchStart\t$matchEnd\t$gffStrand{$gene}\t$chr\t$countmatch\t$countstrand";
   $check=1;
  }
 }
 $countmatch=0;
 $countstrand=0;
 $genestrand1=0;
 $genestrand2=0;
	
 
 if ($check != 1)
 {
  $out{$seg}="$seg\t$holder1[0]\t$holder1[1]\t$holder1[2]\t$holder1[3]\t$holder1[4]\tINTERGENIC\t.\t.\t.\t.\t.\t$chr\t$countmatch\t0";
 }
 $check=0;
#
###
####
#print "$out{$seg}\n";
####
###
#


}
#####################################################################
#print output file
####################################################################

for my $out (sort keys %out)
{
 print OUT "$out{$out}\t";
 print OUT "$HITstart{$out}\t$HITend{$out}\n";
}
#print "$count\n";
close IN;
close OUT;
close IN1;

