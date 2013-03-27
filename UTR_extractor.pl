use strict;
use warnings;
use POSIX;

########################
if (@ARGV !=2) {die "need a file and a gff file";}
(my $in, my $gff)=@ARGV;
open (IN, $gff) or die 'could not find the gff file';
open (IN1, $in) or die 'could not find the sequence file';


open (OUT1, ">", "5utr.120712.fasta") or die 'could not open output file 1';
open (OUT2, ">", "3utr.120712.fasta") or die 'could not open output file 2';
########################

####################################
#Reads the gff and store coordinates
####################################


my @holder;
my $default=100;
my %GeneStart;
my %GeneEnd;
my %GeneStrand;
my %GeneChr;
my %FiveStart;
my %FiveEnd;
my %ThreeStart;
my %ThreeEnd;
my $gene;

my $line=<IN>;
while ($line=<IN>)
{
 chomp ($line);
 @holder = split (/\t/, $line);
 
 $GeneChr{$holder[9]}=$holder[12];
 $GeneStrand{$holder[9]}=$holder[6];

## 
 if ($holder[2] eq "gene")
 {
   $GeneStart{$holder[9]}=$holder[3];
   $GeneEnd{$holder[9]}=$holder[4];
 }

##
 elsif ($holder[2] eq "5\'UTR")
 {
   $FiveStart{$holder[9]}=$holder[3];
   $FiveEnd{$holder[9]}=$holder[4];
 }

##
 elsif ($holder[2] eq "3\'UTR")
 {
   $ThreeStart{$holder[9]}=$holder[3];
   $ThreeEnd{$holder[9]}=$holder[4];
 }

}
## 

for $gene (keys %GeneStart )
{
 
 unless (exists $FiveStart{$gene})
 {
  if($GeneStrand{$gene} eq "+")
  {
   $FiveStart{$gene}=$GeneStart{$gene}-$default;
   $FiveEnd{$gene}=$GeneStart{$gene}-1;
  }
  
  elsif($GeneStrand{$gene} eq "-")
  {
   $FiveStart{$gene}=$GeneEnd{$gene}+1;
   $FiveEnd{$gene}=$GeneEnd{$gene}+$default;
  }
 }
 
 unless (exists $ThreeStart{$gene})
 {
  if($GeneStrand{$gene} eq "-")
  {
   $ThreeStart{$gene}=$GeneStart{$gene}-$default;
   $ThreeEnd{$gene}=$GeneStart{$gene}-1;
  }
   
  elsif($GeneStrand{$gene} eq "+")
  {
   $ThreeStart{$gene}=$GeneEnd{$gene}+1;
   $ThreeEnd{$gene}=$GeneEnd{$gene}+$default;
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
my $five;
my $three;

##################################
##Exrtact and print data for Genes
##################################
 
foreach my $out (keys %GeneStart)
{
 $chr=">CH".$GeneChr{$out}."_bases";

 $gene=substr($chr{$chr},$GeneStart{$out},($GeneEnd{$out}-$GeneStart{$out}));
 $gene=uc($gene);
 if ($GeneStrand{$out} eq "-")
 {
  $gene = reverse($gene);
  $gene =~ tr/ACGTacgt/TGCAtgca/;
 }

 if(($FiveStart{$out} < 1)||($FiveEnd{$out} > length($chr{$chr})))
 {
  $five = "A";  
 }
 else
 {
  $five=substr($chr{$chr},$FiveStart{$out},($FiveEnd{$out}-$FiveStart{$out}));
  $five=uc($five);
  if ($GeneStrand{$out} eq "-")
  {
   $five = reverse($five);
   $five =~ tr/ACGTacgt/TGCAtgca/;
  }
 }

 if(($ThreeStart{$out} < 1)||($ThreeEnd{$out} > length($chr{$chr})))
 {
  $five = "A";  
 }
 else
 {
  $three=substr($chr{$chr},$ThreeStart{$out},($ThreeEnd{$out}-$ThreeStart{$out}));
  $three=uc($three);
  if ($GeneStrand{$out} eq "-")
  {
   $three = reverse($three);
   $three =~ tr/ACGTacgt/TGCAtgca/;
  }
 }
 print OUT1 ">".$out."\n".$five."\n";
 print OUT2 ">".$out."\n".$three."\n";

}

###
###
close OUT1;
close OUT2;

