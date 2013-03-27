use strict;
use warnings;


########################
if (@ARGV != 2) {die "need a name and a gff file";}
(my $in, my $gff)=@ARGV;
my $in1=$gff;
open (IN, $gff) or die 'could not find the input file';
open (IN1, $in) or die 'could not find the input file';
open (IN2, $in1) or die 'could not find the input file';

open (OUT, ">", "$in.map") or die 'could not open output file';
########################


my $line;
my $line1;
my $line2;
my $mid;
my $gene;
my $strand;
my $genestrand1;
my $genestrand2;
my $count=0;
my $count1=0;
my $count2=0;
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
my $out1;
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
my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','LTR','tRNA');

####################################################################
#Creates ref unsed to corrects for strand in exon and intron number
####################################################################

while ($line2=<IN2>)
{
 chomp ($line2);
 @holder2 = split (/\t/, $line2);
 	
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
         for ($i=($holder[3]+1);$i<$holder[4];$i++)
         {
	  $HIT{$holder[12]}{$i}{$sense{$holder[9]}}="INTRON_$holder[9].I$featureNumber";
	  $HIT{$holder[12]}{$i}{$antisense{$holder[9]}}="AS.INTRON_$holder[9].I$featureNumber";
	 } 
	}

#print "$holder[6]\t$featureNumber\t$CDScount{$holder[9]}\t$INTcount{$holder[9]}\n";

$featureNumber=0;
}

#print "gff parsed\n";

#####################################
#Reads exonerate files and maps segments 
#####################################

while ($line1=<IN1>)
{

 $count++;
 chomp ($line1);
 @holder1 = split (/ /, $line1);
#print "*";
 if ($holder1[0] ne "vulgar:"){next;}
#print "-";
 #unless (@holder1==6)
 #{
 # next;
 #}
 $strand=$holder1[8];
 $chr=substr($holder1[5],2,1);
#print "$chr";		
 if ($chr eq "T")
 {
 $length=0;
 }
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
		

 $seg="$holder1[1]£0";

##duplicates
 if (defined $HITstart{$seg})
 {
 $count2++;
 chop($seg);
 $seg="$seg$count2";
 #print "$seg\n";
 }


#########################
#finds start and end hits
#########################
if (defined %{$HIT{$chr}{$holder1[6]}})
{
$HITstart{$seg}=$HIT{$chr}{$holder1[6]}{$holder1[8]};
}
else
{
$HITstart{$seg}="INTERGENIC";
}

if (defined %{$HIT{$chr}{$holder1[7]}})
{
$HITend{$seg}=$HIT{$chr}{$holder1[7]}{$holder1[8]};
}
else
{
$HITend{$seg}="INTERGENIC";
}

}
##########################

#####################################################################
#print output file
####################################################################

for my $out (sort keys %HITstart)
{
#$out1=$out;
#print "$out\t";

$out =~ /£/; 
$out1=$`;

#print "$`\n";

print OUT "$out1\t$HITstart{$out}\t$HITend{$out}\n";

}

#print "$count\n";
close IN;
close OUT;
close IN1;

