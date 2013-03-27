#!/usr/bin/perl


use strict;
use Bio::Seq;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::SeqFeatureI;
use Bio::Location::Simple;
use Bio::Location::SplitLocationI;
use Bio::LocationI;
use warnings;





open (OUT, 'gff_210411.txt')or die 'could not open the output file';


my $feature;
my $loc;
my $loc1;
my $i=0;
my $j=0;
my $k=0;
my $l=0;
my $chr=0;
my $ann;
my $gene;
my $feat;
my $strand;
my @gene;
my @geneOUT;
my @ann;
my @coor;

#load files
################################################################################

my $seqio_obj1 = Bio::SeqIO->new (-file =>"C:\\chromosome1.contig.210411" , -format => "embl");
my $seqio_obj2 = Bio::SeqIO->new (-file =>"C:\\chromosome2.contig.210411" , -format => "embl");
my $seqio_obj3 = Bio::SeqIO->new (-file =>"C:\\chromosome3.contig.210411" , -format => "embl");
my $seq_object1 = $seqio_obj1->next_seq();
my $seq_object2 = $seqio_obj2->next_seq();
my $seq_object3 = $seqio_obj3->next_seq();
my @toDo = ($seq_object1,$seq_object2,$seq_object3);

#main loop through features.
################################################################################
################################################################################

foreach $l (@toDo)
{

$chr++;
for $feature ($l->get_SeqFeatures())
{
unless ($feature->primary_tag eq "repeat_region" ||
        $feature->primary_tag eq "misc_feature"  ||
        $feature->primary_tag eq "intron"        ||
        $feature->primary_tag eq "conflict")
{

#extract annotation and gene
################################################################################

$ann= 'No comment';
$gene=$feature->primary_tag;

for my $tag ($feature->get_all_tags)
{             
  if ($tag eq 'product')
  {
    @ann=$feature->get_tag_values($tag);
    $ann = join "", @ann;
  }
  #if ($tag eq 'gene')
  if ($tag eq 'systematic_id')#extracts also new SPNCRNAs, sam 010508.
  {
    @gene=$feature->get_tag_values($tag);
    
    if (grep (/SP[0-9|a-z|A-Z|\.]+/,@gene))
    {
    @geneOUT = grep (/SP[0-9|a-z|A-Z|\.]+/,@gene);  
    @geneOUT = sort (@geneOUT);
    $gene= $geneOUT[0];
    if ($#geneOUT > 0){print "@geneOUT\n";}
    } 
    else
    {
    @geneOUT = sort (@gene);
    $gene= $geneOUT[0];
    }
  }
      
}    
################################################################################

#strand
################################################################################
if ($feature->strand eq "1") {$strand = "+";}
elsif ($feature->strand eq "-1") {$strand = "-";}
################################################################################


#coordinates
################################################################################

for $loc1 ($feature->location->each_Location)
{
push (@coor, $loc1->start);
push (@coor, $loc1->end);
}
if ($strand eq "-"){@coor = sort @coor;}
################################################################################

#print output
################################################################################

unless ($feature->primary_tag eq "5'UTR" ||
        $feature->primary_tag eq "3'UTR" ||
        $feature->primary_tag eq "promoter" ||
        $feature->primary_tag eq "polyA_site")
{


#gene line
################################################################################
print OUT "chr".$chr."\t".
          "geneDB\t".
          "gene\t".
          $feature->start."\t".
          $feature->end."\t".
          '.'."\t".
          "$strand\t".
          '.'."\t".
          "$ann\t".
          "$gene\t".
          "$chr\n";
}
################################################################################

#intron or CDS lines
################################################################################
for ($i=0 ; $i < $#coor ; $i++)
{

$feat="no data??";
$j=$i+1;
if (($i==0 || $i % 2 == 0) && $j <= $#coor)
{
$feat = $feature->primary_tag;
}
elsif (($i!=0 && $i % 2 != 0) && $j <= $#coor)
{
$feat = "intron";
}

print OUT "chr".$chr."\t".
          "geneDB\t".
          $feat."\t".
          $coor[$i]."\t".
          $coor[$j]."\t".
          '.'."\t".
          "$strand\t".
          '.'."\t".
          "$ann\t".
          "$gene\t".
          "$chr\n";
}
################################################################################

@coor = ();
}
}
}

close OUT;







