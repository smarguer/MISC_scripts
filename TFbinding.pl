use strict;
use warnings;
use POSIX;

########################
if (@ARGV !=2) {die "need a file and a gff file";}
(my $in, my $gff)=@ARGV;
open (IN, $gff) or die 'could not find the gff file';
open (IN1, $in) or die 'could not find the sequence file';


open (OUT1, ">", "TFbinding.gene.txt") or die 'could not open output file 1';
open (OUT2, ">", "TFbinding.5utr.txt") or die 'could not open output file 2';
open (OUT3, ">", "TFbinding.prom.txt") or die 'could not open output file 3';
open (OUT4, ">", "TFbinding.chr.txt") or die 'could not open output file 4';
########################

my @holder;
my $promlength=600;
my %GeneStart;
my %GeneEnd;
my %GeneStrand;
my %GeneChr;
my %UtrStart;
my %UtrEnd;
my %PromStart;
my %PromEnd;
my %AltPromStart;
my %AltPromEnd;

####################################
#Reads the gff and store coordinates
####################################

my $line=<IN>;
while ($line=<IN>)
{
 chomp ($line);
 @holder = split (/\t/, $line);
 
 $GeneChr{$holder[9]}=$holder[12];
 $GeneStrand{$holder[9]}=$holder[6];
 
 if ($holder[2] eq "gene")
 {
  
  $GeneStart{$holder[9]}=$holder[3];
  $GeneEnd{$holder[9]}=$holder[4];
 
  if($GeneStrand{$holder[9]} eq "+")
  {
   $AltPromStart{$holder[9]}=$holder[3]-$promlength;
   $AltPromEnd{$holder[9]}=$holder[3];
  }
  elsif($GeneStrand{$holder[9]} eq "-")
  {
   $AltPromStart{$holder[9]}=$holder[4];
   $AltPromEnd{$holder[9]}=$holder[4]+$promlength;
  }
 }
 elsif ($holder[2] eq "5\'UTR")
 {
  $UtrStart{$holder[9]}=$holder[3];
  $UtrEnd{$holder[9]}=$holder[4];
  
  if($GeneStrand{$holder[9]} eq "+")
  {
   $PromStart{$holder[9]}=$holder[3]-$promlength;
   $PromEnd{$holder[9]}=$holder[3];
  }
  elsif($GeneStrand{$holder[9]} eq "-")
  {
   $PromStart{$holder[9]}=$holder[4];
   $PromEnd{$holder[9]}=$holder[4]+$promlength;
  }
 }
}
close IN;

#######################################
#Reads Sequences and store them
#######################################
my %chr;
my $line1;
my $count;
my $name;

while ($line1=<IN1>)
{
 $count++;
 chomp($line1);
 if ($line1=~/\>/)
 {
  $name="$line1";
  $chr{$name}="A";
 }
 else
 {
  $chr{$name}.=$line1;
 }
}
close IN1;

$chr{">CH1_bases"}=substr($chr{">CH1_bases"},1,length($chr{">CH1_bases"}));
$chr{">CH2_bases"}=substr($chr{">CH2_bases"},1,length($chr{">CH2_bases"}));
$chr{">CH3_bases"}=substr($chr{">CH3_bases"},1,length($chr{">CH3_bases"}));
$chr{">CH4_bases"}=substr($chr{">CH4_bases"},1,length($chr{">CH4_bases"}));
$chr{">CH5_bases"}=substr($chr{">CH5_bases"},1,length($chr{">CH5_bases"}));
$chr{">CH6_bases"}=substr($chr{">CH6_bases"},1,length($chr{">CH6_bases"}));

#########################################
#Counts and stores binding sites.
#########################################
my @patterns=(
##
#-1-#Sap1_recognition_motif
#TARGCAGNTNYAACGMG,
"TA[AG]GCAG[ATCG]T[ATCG][CT]AACG[AC]G",
#-2-#AP_1_binding_site
"TGACTCA",
#-3-#calcineurin-dependent response element (CDRE motif)
#GNGGCKCA,
"G[ATCG]GGC[GT]CA",
#-4-#cyclic AMP response element (CRE)
"TGACGTCA",
#-5-#CSL_response_element
#GTGRGAA,
"GTG[AG]GAA",
#-6-#copper-response element (CuRE)
#HTHNNGCTGD,
"[ACT]T[ACT][ATCG][ATCG]GCTG[AGT]",
#-7-#DNA damage response element (DRE)
#CGWGGWNGMM,
"CG[AT]GG[AT][ATCG]G[AC][AC]",
#-8-#FLEX_element
#GTAAACAAACAAAM,
"GTAAACAAACAAA[AC]",
#-9-#forkhead_motif
"TTT[AG]TTTACA",
#-10-#homol_D_box
"CAGTCACA|TGTGACTG",
#-11-#homol_E_box
"ACCCTACCCT|AGGGTAGGGT",
#-12-#heat shock element (HSE), (at least 3 copies)
#NGAANNTTCNNGAAN,
"[ATCG]GAA[ATCG][ATCG]TTC[ATCG][ATCG]GAA[ATCG]",
#-13-#iron_repressed_GATA_element
#WGATAA,
"[AT]GATAA",
#-14-#mating_type_M_box
"ACAAT",
#-15-#sterol_regulatory_element (and variants)
"ATCACCCCAC",
#-16-#STREP_motif
"CCCCTC",
#-17-#TR_box
#TTCTTTGTTY,
"TTCTTTGTT[CT]",
#-18-#Ace2_UAS
"CCAGCC",
#-19-#CCAAT_motif
"CCAAT",
#-20-#MluI cell cycle box (MCB)
"ACGCGT",
#-21-#histones, Rustici et al
"AAC[ATCG]CTAAC",
#-22-#TATA box
"TATA[AT]A[AT][AG]",
#-23-#CDRE
"AGCCTC",
#-24-#SRE
"[AT]TCAC[AC]CAT",

);
#######################################
#processing genes
#######################################
my @GeneOut=();
my @UtrOut=();
my @PromOut=();
my $output;
my $GeneOut;
my $seq;
my $chr;


my $title= "Sap1_recognition_motif_TARGCAGNTNYAACGMG\tAP_1_binding_site_TGACTCA\tCDRE_GNGGCKCA\tCRE_TGACGTCA\tCSL_RE_GTGRGAA\tCuRE_HTHNNGCTGD\tDRE_CGWGGWNGMM\tFLEX_GTAAACAAACAAAM\tforkhead_TTT[AG]TTTACA\thomol_D_box_CAGTCACA\thomol_E_box_ACCCTACCCT\tHSE_NGAAN\tiron_repressed_GATA_WGATAA\tmating_type_M_box_ACAAT\tsterol_RE_ATCACCCCAC\tSTREP_CCCCTC\tTR_box_TTCTTTGTTY\tAce2_UAS_CCAGCC\tCCAAT_motif_CCAAT\tMCB_ACGCGT\thistones_Rustici\tTATA_box\tCDRE\tSRE";


print OUT1 "name\t$title\n";
print OUT2 "name\t$title\n";
print OUT3 "name\t$title\n";
print OUT4 "name\t$title\n";

##################################
##Add data for the genome
##################################
my @chrnum=(1,2,3,4,5,6);

foreach my $out (@chrnum)
{
 $chr=">CH".$out."_bases";
 $seq=$chr{$chr};
 $seq=uc($seq);
 
 for my $out1 (@patterns)
 {
  #print "$out\t$out1\n";
  $output=(scalar(@{[$seq =~ /$out1/g]})); 
  push(@GeneOut,$output);  
 }
 
 $GeneOut=join "\t",@GeneOut;
 print OUT4 $chr."+\t$GeneOut\n";
 @GeneOut=();

 $seq = reverse($seq);
 $seq =~ tr/ACGTacgt/TGCAtgca/;
 
 for my $out1 (@patterns)
 {
  #print "$out\t$out1\n";
  $output=(scalar(@{[$seq =~ /$out1/g]})); 
  push(@GeneOut,$output);  
 }
 $GeneOut=join "\t",@GeneOut;
 print OUT4 $chr."-\t$GeneOut\n";
 @GeneOut=();
}
#my $out="SPAC1250.05";
##################################
##Exrtact and print data for Genes
##################################

foreach my $out (keys %GeneStart)
{
 $chr=">CH".$GeneChr{$out}."_bases";
 $seq=substr($chr{$chr},$GeneStart{$out},($GeneEnd{$out}-$GeneStart{$out}));
 $seq=uc($seq);
 if ($GeneStrand{$out} eq "-")
 {
  $seq = reverse($seq);
  $seq =~ tr/ACGTacgt/TGCAtgca/;
 }
 for my $out1 (@patterns)
 {
  #print "$out\t$out1\n";
  $output=(scalar(@{[$seq =~ /$out1/g]})); 
  push(@GeneOut,$output);  
 }
 $GeneOut=join "\t",@GeneOut;
 print OUT1 "$out\t$GeneOut\n";
 @GeneOut=();

#my $test="GAGGCGCA"; 
#print "\n$test\n$size\n\n";
}
##################################
##Extract and print data for 5'UTR
##################################

foreach my $out (keys %GeneStart)
{
 $chr=">CH".$GeneChr{$out}."_bases";
 
 if(defined $UtrStart{$out})
 {
  $seq=substr($chr{$chr},$UtrStart{$out},($UtrEnd{$out}-$UtrStart{$out}));
 
  $seq=uc($seq);
  if ($GeneStrand{$out} eq "-")
  {
   $seq = reverse($seq);
   $seq =~ tr/ACGTacgt/TGCAtgca/;
  } 
  for my $out1 (@patterns)
  {
  #print "$out\t$out1\n";
   $output=(scalar(@{[$seq =~ /$out1/g]})); 
   push(@GeneOut,$output);  
  }
  $GeneOut=join "\t",@GeneOut;
  print OUT2 "$out\t$GeneOut\n";
  @GeneOut=();
 } 
 
 else
 {
  print OUT2 "$out\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n";
 }
}
#####################################
##Extract and print data for promoter
#####################################

foreach my $out (keys %GeneStart)
{
 $chr=">CH".$GeneChr{$out}."_bases";
 
 if(defined $PromStart{$out})
 {
  $seq=substr($chr{$chr},$PromStart{$out},($PromEnd{$out}-$PromStart{$out}));
 }
 else
 {
  $seq=substr($chr{$chr},$AltPromStart{$out},($AltPromEnd{$out}-$AltPromStart{$out}));
 }

 $seq=uc($seq);
 if ($GeneStrand{$out} eq "-")
 {
  $seq = reverse($seq);
  $seq =~ tr/ACGTacgt/TGCAtgca/;
 }

##counts occurence of patterns
 for my $out1 (@patterns)
 {
  #print "$out\t$out1\n";
  $output=(scalar(@{[$seq =~ /$out1/g]})); 
  push(@GeneOut,$output);  
 }
 $GeneOut=join "\t",@GeneOut;
 print OUT3 "$out\t$GeneOut\n";
 @GeneOut=();
}

close OUT1;
close OUT2;
close OUT3;
close OUT4;

