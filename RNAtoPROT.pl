#!/usr/bin/perl

use warnings;
use strict;

########

if (@ARGV != 2) {die "need 2 arguments";}

(my $in, my $out)=@ARGV;

#open (IN1, "/jurg/homedir/samuel/POMBE_SEQ/analysis/ALLchromosomes.str") or die 'Could not find the chromosome file';
open (IN1, "/jurg/homedir/samuel/POMBE_SEQ/analysis/ALLchromosomes.str") or die 'Could not find the chromosome file';
open (IN, $in) or die 'Could not find the input file';
open (OUT, ">", $out) or die 'Could not find the output file';

#########################
##reads in the chromosome fasta file
#########################

my $line1;
my $line=<IN>;
our %dna;
my $current;
my $name;
my $seq=0;
my @holder=();
my @test=();

while ($line1=<IN1>)
{
 chomp($line1);
 if ($line1 =~ />/)
 {
  $dna{$line1}=0;
  $current=$line1;
 }
 else
 {
  $dna{$current}=$line1;
 }
}

while ($line=<IN>)
{
 chomp ($line);
 @holder= split /\t/, $line;
 if ($holder[2] ne "gene") {next;}
 if ($holder[6] eq '.')    {next;}
 if ($holder [4] < $holder[3]) {next;}
 $name=$holder[9];
 $seq=getDNA($holder[12],$holder[3],$holder[4],$holder[6]);

###test pack####
#my $seq="ATGGAAGAAGAAATCGCAGCGTTGGTTATTGATAATGGCTCTGGTATGTGCAAAGCCGGTTTCGCTGGAGATGATGCCCCTAGAGCTGTATTCCCCTCGATTGTCGGTAGACCCCGTCACCATGGTATTATGGTAGGTATGGGACAAAAGGATTCCTACG";
#$name="frag.2.1476149.1477276.-";
#$seq=getDNA(2,1476149,1477276,"-");
#print "$seq\n\n";
################
 if ($seq =~ /[^ACGTacgt]/)
 {
 print "$holder[9]\n$seq\n\n";
 next;
 }
 
 @test= getORFs($seq,$name);
 print OUT "@test";
}

close IN1;
close IN;
close OUT;

####################################################################################
###subroutines######################################################################
####################################################################################

############
#get DNA
###########

sub getDNA
{
#my %seq1=shift;
 my $chr=shift;
 my $start=shift;
 my $end=shift;
 my $length;
 my $strand=shift;
 my $out;

#print "$chr\t$start\t$end\t$strand\n";

 
 if ($chr == 1){$chr = ">CH1_bases"}
 elsif($chr == 2){$chr = ">CH2_bases"}
 elsif($chr == 3){$chr = ">CH3_bases"}
 #elsif($chr == 4){$chr = ">MIT_bases"}
 #elsif($chr == 5){$chr = ">MAT_bases"}
 elsif($chr == 4){$chr = ">CH4_bases"}
 elsif($chr == 5){$chr = ">CH5_bases"}
 elsif($chr == 6){$chr = ">CH6_bases"}

 $length=$end-$start;

 $out=substr($dna{$chr},$start,$length);
 if ($strand eq "-")
 {
  $out=reverse($out);
  $out=~ tr/ACGTacgt/TGCAtgca/;
 }
 if ($out =~ /[^ACGTacgt]/)
 {
  $out="This is not a DNA sequence...Gap?";
 }
 return($out)
#print "$chr\t$start\t$end\t$strand\n";
#print "$out\n";
}

############
#get ORF
############

sub getORFs
{
 my(%genetic_code) = (
     'TCA'=>'S', #Serine
     'TCC'=>'S', #Serine
     'TCG'=>'S', #Serine
     'TCT'=>'S', #Serine
     'TTC'=>'F', #Phenylalanine
     'TTT'=>'F', #Phenylalanine
     'TTA'=>'L', #Leucine
     'TTG'=>'L', #Leucine
     'TAC'=>'Y', #Tyrosine
     'TAT'=>'Y', #Tyrosine
     'TAA'=>'_', #Stop
     'TAG'=>'_', #Stop
     'TGC'=>'C', #Cysteine
     'TGT'=>'C', #Cysteine
     'TGA'=>'_', #Stop
     'TGG'=>'W', #Tryptophan
     'CTA'=>'L', #Leucine
     'CTC'=>'L', #Leucine
     'CTG'=>'L', #Leucine
     'CTT'=>'L', #Leucine
     'CCA'=>'P', #Proline
     'CAT'=>'H', #Histidine
     'CAA'=>'Q', #Glutamine
     'CAG'=>'Q', #Glutamine
     'CGA'=>'R', #Arginine
     'CGC'=>'R', #Arginine
     'CGG'=>'R', #Arginine
     'CGT'=>'R', #Arginine
     'ATA'=>'I', #Isoleucine
     'ATC'=>'I', #Isoleucine
     'ATT'=>'I', #Isoleucine
     'ATG'=>'M', #Methionine
     'ACA'=>'T', #Threonine
     'ACC'=>'T', #Threonine
     'ACG'=>'T', #Threonine
     'ACT'=>'T', #Threonine
     'AAC'=>'N', #Asparagine
     'AAT'=>'N', #Asparagine
     'AAA'=>'K', #Lysine
     'AAG'=>'K', #Lysine
     'AGC'=>'S', #Serine
     'AGT'=>'S', #Serine
     'AGA'=>'R', #Arginine
     'AGG'=>'R', #Arginine
     'CCC'=>'P', #Proline
     'CCG'=>'P', #Proline
     'CCT'=>'P', #Proline
     'CAC'=>'H', #Histidine
     'GTA'=>'V', #Valine
     'GTC'=>'V', #Valine
     'GTG'=>'V', #Valine
     'GTT'=>'V', #Valine
     'GCA'=>'A', #Alanine
     'GCC'=>'A', #Alanine
     'GCG'=>'A', #Alanine
     'GCT'=>'A', #Alanine
     'GAC'=>'D', #Aspartic Acid
     'GAT'=>'D', #Aspartic Acid
     'GAA'=>'E', #Glutamic Acid
     'GAG'=>'E', #Glutamic Acid
     'GGA'=>'G', #Glycine
     'GGC'=>'G', #Glycine
     'GGG'=>'G', #Glycine
     'GGT'=>'G', #Glycine

     ); 

 my $codon=0;
 my $i=0;
 my $j=0;
 my $k=0;
 my $l=0;
 my $len=0;
 my @seq=();
 my $sequence=shift;
 my $name=shift;
 my @out=();
 my $limit=20;

##print "$sequence\n\n\n\n\n";

 for ($i=0;$i<=2;$i++) 
 {
  for ($j=$i; $j<= (length($sequence)-3); $j=$j+3)
  {
   $codon=substr($sequence,$j,3);
   $codon=uc($codon);
#print "$codon\n\n";
#print "$genetic_code{$codon}";
   push (@{$seq[$i]}, $genetic_code{$codon});
  }
#print "\n@{$seq[$i]}\n";
#print "\n\n";
  $len=$#{$seq[$i]};
  for ($k=0;$k<=$len;$k++) 
  {
#print "$seq[$i][$k]\n";
   if ($seq[$i][$k] eq "_")
   {
    if ($k-$l > $limit)
    {
#print "@{$seq[$i]}[$l..($k-1)]\n";
     push (@out,">$name.".($i+1).".".($l+1).' '.$name."\n".join('',@{$seq[$i]}[$l..($k-1)])."\n");
    }  
   $l=$k+1;
   } 

   if ($k==$len)
   {
    if ($k-$l > $limit)
    {
#print "@{$seq[$i]}[$l..$k]\n";
     push (@out,">$name.".($i+1).".".($l+1).' '.$name."\n".join('',@{$seq[$i]}[$l..($k-1)])."\n");
    }
   }
  }
   $l=0;
##print"\n\n";
 }
return(@out)
}

