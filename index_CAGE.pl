use strict;
use warnings;

my @index;
my @files;
my @out;
my $i;
my $j;
my $match;
my $total;
my $perc;


#@index= ('@HWI',
#"^ACAGAT",
#"^ATCGTG",
#"^CACGAT",
#"^CACTGA",
#"^CTGACG",
#"^GAGTGA",
#"^GTATAC",
#"^TCGAGC",
#"TATAGGG");

@index= ('@HWI',
"^ACAGAT[ATCG]{8}TATAGGG",
"^ATCGTG[ATCG]{8}TATAGGG",
"^CACGAT[ATCG]{8}TATAGGG",
"^CACTGA[ATCG]{8}TATAGGG",
"^CTGACG[ATCG]{8}TATAGGG",
"^GAGTGA[ATCG]{8}TATAGGG",
"^GTATAC[ATCG]{8}TATAGGG",
"^TCGAGC[ATCG]{8}TATAGGG",
"TATAGGG");



#@index= ('@HWI',
#"^TGTCTA",
#"^TAGCAC",
#"^GTGCTA",
#"^GTGACT",
#"^GACTGC",
#"^CTCACT",
#"^CATATG",
#"^AGCTCG",
#"TATAGGG");


#@files=("JB1_MM1_ACAGAT_L007_R1_001.fastq",
#"JB2_MM2_ATCGTG_L007_R1_001.fastq",
#"JB3_YE1_CACGAT_L007_R1_001.fastq",
#"JB4_YE2_CACTGA_L007_R1_001.fastq",
#"JB5_rrp6_1_CTGACG_L007_R1_001.fastq",
#"JB6_rrp6_2_GAGTGA_L007_R1_001.fastq",
#"JB7_MN1_GTATAC_L007_R1_001.fastq",
#"JB8_MN2_TCGAGC_L007_R1_001.fastq");
@files=("Sample_JB1_MM1/0609_1_R1.fastq",
"Sample_JB2_MM2/0609_2_R1.fastq",
"Sample_JB3_YE1/0609_3_R1.fastq",
"Sample_JB4_YE2/0609_4_R1.fastq",
"Sample_JB5_rrp6_1/0609_5_R1.fastq",
"Sample_JB6_rrp6_2/0609_6_R1.fastq",
"Sample_JB7_MN1/0609_7_R1.fastq",
"Sample_JB8_MN2/0609_8_R1.fastq");

@out=map(substr($_,1),@index);
$out[0]="total";
$out[9]=$index[9];
print ' '."\t".join("\t",@out)."\n";
@out=();

for $j (@files)
{
# print "**************\n";
# print "$j\n";
 @out=($j);
 
 for $i (@index)
 {
  $match=`grep -cP $i $j`;
 
  if($i eq '@HWI')
  {
  # print 'Total: '.$match;
   chomp $match;
   push(@out,$match);
   $total=$match;
  # print "++++++++\n";
  }
#  elsif ($i eq "TATAGGG")
#  {
#   chomp $match;
#   #print "++++++++\n";
#   $perc=(($match/$total)*100);
#   $perc= sprintf ("%.1f",$perc);
#   #print $i.': '.$match.'('.$perc.')'."\n";
#   push ($match.'('.$perc.')',@out);
#  }
  else
  {
   chomp $match;
   $perc=(($match/$total)*100);
   $perc= sprintf ("%.1f",$perc);
#   print substr($i,1).': '.$match.'('.$perc.')'."\n";
   push (@out,$match.'('.$perc.')');
  }
 }
 print join("\t",@out)."\n";
 @out=()
}



