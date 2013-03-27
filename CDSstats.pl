use strict;
use warnings;
use POSIX;

########################
if (@ARGV != 2) {die "need a file and a gff file";}
(my $in, my $gff)=@ARGV;
my $in1=$gff;
open (IN, $gff) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the input file';
open (IN2, $in1) or die 'could not find the input file';

open (OUT, ">", "$in.FEATURETABLE") or die 'could not open output file';
open (OUT1, ">", "$in.GENETABLE") or die 'could not open output file';

########################


my $line=<IN>;
my $line1=<IN1>;
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
my $first;
my $last;
my $out;
my $out2;
my %HIT;
my %HITstart;
my %HITend;
my %HITmid;
my %HITfirst;
my %HITlast;
my %FEATURE;
my %GENE;
my @done;
my @done1;

my %sense;
my %antisense;
my %count;
my %count1;
my %CDScount;
my %INTcount;
my @features=('CDS','misc_RNA','tRNA','snRNA','snoRNA','LTR','rRNA','mRNA');
#my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','LTR','tRNA');
my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','3\'UTR','5\'UTR','tRNA');

######################################################################
#Creates ref unsed to corrects for strand in exon and intron numbering
######################################################################

while ($line2=<IN2>)
{
 chomp ($line2);
 @holder2 = split (/\t/, $line2);
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
  $GENE{$holder[9]}{START}=$holder[4];
  $GENE{$holder[9]}{END}=$holder[3];
  $GENE{$holder[9]}{SEG}=0;  
  $GENE{"AS.$holder[9]"}{START}=$holder[4];
  $GENE{"AS.$holder[9]"}{END}=$holder[3];
  $GENE{"AS.$holder[9]"}{SEG}=0;
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
   $FEATURE{"$holder[9].E$featureNumber"}{SEG}=0;
   $FEATURE{"$holder[9].E$featureNumber"}{START}=$holder[4];
   $FEATURE{"$holder[9].E$featureNumber"}{END}=$holder[3];
   
   $FEATURE{"AS.$holder[9].E$featureNumber"}{SEG}=0;      
   $FEATURE{"AS.$holder[9].E$featureNumber"}{START}=$holder[4];      
   $FEATURE{"AS.$holder[9].E$featureNumber"}{END}=$holder[3];      
 }
 
 elsif ($holder[2] eq "intron")
 {
  $count1++;
  $name="INTRON_".$holder[9]."_".$count1;
  $gffStart{$name}=$holder[3];
  $gffEnd{$name}=$holder[4];
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

  $FEATURE{"INTRON_$holder[9].I$featureNumber"}{SEG}=0;
  $FEATURE{"INTRON_$holder[9].I$featureNumber"}{START}=$holder[4];
  $FEATURE{"INTRON_$holder[9].I$featureNumber"}{END}=$holder[3];
  
  $FEATURE{"AS.INTRON_$holder[9].I$featureNumber"}{SEG}=0;
  $FEATURE{"AS.INTRON_$holder[9].I$featureNumber"}{START}=$holder[4];
  $FEATURE{"AS.INTRON_$holder[9].I$featureNumber"}{END}=$holder[3];
  
  $featureNumber=0;
 }
}

print "gff parsed\n";

#####################################
#Reads .map files and maps segments 
#####################################

while ($line1=<IN1>)
{
 @done=();
 @done1=();
 @holder1=();
 $count++;
 chomp ($line1);

 @holder1 = split (/\t/, $line1);
 
my $size=$#holder1;

 for ($i=7;$i<=$size;$i++)
 {
  if ($holder1[$i] eq "NEW")
  {
   next;
  } 
  
  unless (defined $FEATURE{$holder1[$i]}{SEG})
  {
   print "$line1\n$holder1[$i] wasn't included in the data structure\n";
   next;
  }  

#######
#for gene table
#######
  $gene=$holder1[$i];
  
  if ($gene=~/INTRON_/)
  {
   $gene=$`.$';
  }
  
  if ($gene=~/\.I/)
  {
   $gene=$`;
  }   
  elsif ($gene=~/\.E/)
  {
   $gene=$`;
  }
####

  unless (grep /$holder1[$i]/, @done)
  {
   $FEATURE{$holder1[$i]}{SEG}++;
   push (@done, $holder1[$i]);  
  }

  unless (grep /$gene/, @done1)
  {
   $GENE{$gene}{SEG}++;
   push (@done1, $gene);
  }

  if ($FEATURE{$holder1[$i]}{START} > $holder1[1])
  {
   $FEATURE{$holder1[$i]}{START} = $holder1[1];
  }
  
  if ($FEATURE{$holder1[$i]}{END} < $holder1[2])
  {
   $FEATURE{$holder1[$i]}{END} = $holder1[2];
  }
  
  if ($GENE{$gene}{START} > $holder1[1])
  {
   $GENE{$gene}{START} = $holder1[1];
  }
  
  if ($GENE{$gene}{END} < $holder1[2])
  {
   $GENE{$gene}{END} = $holder1[2];
  }
 }
}
####################
#print out
####################

print OUT "Name\tsegments\tstart\tend\tAS.segments\tAS.start\tAS.end\n";
print OUT1 "Name\tchr\tstrand\tORF.start\tORF.end\tsegments\tstart\tend\tAS.segments\tAS.start\tAS.end\n";

for $out (keys %FEATURE)
{
 if ($out=~/AS/)
 {
  next;
 }
 my $out1="AS.$out";
 if ($out =~ /INTRON_/)
 {
  $out2=$';
 }
 else
 {
  $out2=$out;
 }
 if ($FEATURE{$out1}{SEG}==0)
 {
  $FEATURE{$out1}{START}=0;
  $FEATURE{$out1}{END}=0;
 }
 if ($FEATURE{$out}{SEG}==0)
 {
  $FEATURE{$out}{START}=0;
  $FEATURE{$out}{END}=0;
 }
 print OUT "$out2\t$FEATURE{$out}{SEG}\t$FEATURE{$out}{START}\t$FEATURE{$out}{END}\t$FEATURE{$out1}{SEG}\t$FEATURE{$out1}{START}\t$FEATURE{$out1}{END}\n";
}

for $out (keys %GENE)
{
 if ($out=~/AS/)
 {
  next;
 }
 my $out1="AS.$out";
 if ($GENE{$out1}{SEG}==0)
 {
  $GENE{$out1}{START}=0;
  $GENE{$out1}{END}=0;
 }
 
 if ($GENE{$out}{SEG}==0)
 {
  $GENE{$out}{START}=0;
  $GENE{$out}{END}=0;
 }



 print OUT1 "$out\t$gffChr{$out}\t$gffStrand{$out}\t$gffStart{$out}\t$gffEnd{$out}\t$GENE{$out}{SEG}\t$GENE{$out}{START}\t$GENE{$out}{END}\t$GENE{$out1}{SEG}\t$GENE{$out1}{START}\t$GENE{$out1}{END}\n";
}

close IN;
close OUT;
close OUT1;
close IN1;

