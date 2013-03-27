use strict;
use warnings;
use POSIX;
use Carp;

########################
if (@ARGV != 1) {die "need a file and a gff file";}
(my $gff)=@ARGV;
my $in1=$gff;
my $in=$gff;
open (IN, $gff) or die 'could not find the gff file';
open (IN1, $in) or die 'could not find the input file';
open (IN2, $in1) or die 'could not find the input file';
my $gffname;

$gff =~ /(gff_.+\.txt)/;
$gffname=$1;
die 'Unrecognised gff name.' unless $gffname;
#print "$gff\t$gffname\n";

#open (OUT, ">", "$in.mapIV.$gffname") or die 'could not open output file';
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
my $count3=0;
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
#my @features=('CDS','misc_RNA','tRNA','snRNA','snoRNA','LTR','rRNA');
my @features=('CDS','misc_RNA','tRNA','snRNA','snoRNA','LTR','rRNA','3\'UTR','5\'UTR');
#my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','rep_origin','polyA_signal','LTR','tRNA');
my @excluded=('CDS_motif','BLASTN_HIT','gap','repeat_unit','mRNA','promoter','rep_origin','polyA_signal','polyA_site','3\'UTR','5\'UTR','tRNA');
my $test;
my @done=();
my $hit;
my $ashit;
my %holder;
my $c=0;
####
my %map;
my $seg_out;
my $seg1;
my $init=0;
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

#print OUT "Name\tstart\tend\tstrand\tchr\thit1\thit2\thit3\thit4\thit5\thit6\thit7\thit8\thit9\thit10\n";
#####################################
#Reads exonerate output files and maps reads 
#####################################
#die;

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

 unless($holder1[9]=~/SPNCRNA./) {next;}
 unless($holder1[2] eq "gene") {next;}
# print "$holder1[0]\n";

# if ($holder1[0] !~ /vulgar/){next;}
 $strand=$holder1[6];
 $chr=$holder1[12];
 
 $seg=$holder1[9];
 
# if ($holder1[0] =~ /Mvulgar/)
# {$seg="M$holder1[1]";}
 
# elsif ($holder1[0] =~ /Uvulgar/)
# {$seg="U$holder1[1]";}
 
#print "$seg\n"; 
 $i=0;
 $counthits=0;
 @holder3= ($holder1[3],$holder1[4]);
 if ($holder3[0] > $holder3[1])
 {
  @holder3=reverse(@holder3);
 }
 
 $seg1=$seg.'.E1';
 $map{$seg1}{ALL}="A";
 
##map read to annotation and print OUT###################
 for ($i=$holder3[0];$i <= $holder3[1];$i++)
 {
  $count3++;

  if(defined @{$HIT{$chr}{$i}{$strand}})
  {
############
   #if($count3==1)
   #{
    if(scalar(@{$HIT{$chr}{$i}{$strand}}) > 1)
    {
     unless(($init==1))
     {
      if((defined $map{$seg1}{START})&&(defined $map{$seg1}{END}))
      { 
       $map{$seg1}{ALL}.="\t$map{$seg1}{START}\t$map{$seg1}{END}";
      }
      else
      {
       $map{$seg1}{ALL}.="\tNA\tNA";
      }
      $init=1;
      undef $map{$seg1}{START};
      undef $map{$seg1}{END};
     }
   
     foreach(@{$HIT{$chr}{$i}{$strand}})
     {
      $holder{$_}=1;
      if ($_ eq $seg1)
      {
       next;
      }
      elsif(defined $map{$_}{START})
      {
       $map{$_}{END}=$i;
      }
      else
      {
       $map{$_}{START}=$i;
      }
     }
    }
    else
    {
     $init=0;
     $holder{$HIT{$chr}{$i}{$strand}[0]}=1;
     if(defined $map{$HIT{$chr}{$i}{$strand}[0]}{START})
     {
      $map{$HIT{$chr}{$i}{$strand}[0]}{END}=$i;
     }
     else
     {
      $map{$HIT{$chr}{$i}{$strand}[0]}{START}=$i;
     }
    }
   #}
  }
 }

############

  
#  else
#  {
#   $holder{"NEW"}=1;
#   if(defined $map{"NEW"}{START})
#   {
#    $map{"NEW"}{END}=$i;
#   }
#   else
#   {
#    $map{"NEW"}{START}=$i;
#   }
#  }
 if((defined $map{$seg1}{START}) && (defined $map{$seg1}{END}))
 {
  $map{$seg1}{ALL}.="\t$map{$seg1}{START}\t$map{$seg1}{END}";
 }
 elsif($map{$seg1}{ALL} eq "A")
 {
  $map{$seg1}{ALL}.="\tNA\tNA";
 }
 
 $seg_out=substr($map{$seg1}{ALL},2);
 #$seg_out=$map{$seg1}{ALL};
 print "$seg\t$holder3[0]\t$holder3[1]\t$strand\t$chr\tALL\t".join ("\t", keys %holder)."\n";

 foreach my $out1 (keys %map)
 {
  if($out1 eq $seg1)
  {
   print "$seg\t$holder3[0]\t$holder3[1]\t$strand\t$chr\tGOOD\t$out1\t$seg_out\n";
  }
  else
  {
   unless (defined $map{$out1}{START}) {$map{$out1}{START}=$map{$out1}{END};}
   unless (defined $map{$out1}{END}) {$map{$out1}{END}=$map{$out1}{START};}
   
   print "$seg\t$holder3[0]\t$holder3[1]\t$strand\t$chr\tNO\t$out1\t$map{$out1}{START}\t$map{$out1}{END}\n";
  }
 }
# print  "$seg\t$holder3[0]\t$holder3[1]\t$strand\t$chr\t".join ("\t", keys %holder)."\n";

 undef %holder;
 undef %map;
 $count3=0;
 $init=1;
}
print "\n";
#close OUT;
close IN1;

