use strict;
use warnings;
use POSIX;

########################
if (@ARGV !=1) {die "need a file and a gff file";}
(my $gff)=@ARGV;
open (IN, $gff) or die 'could not find the gff file';
########################

my @holder;
my $promlength=300;
my %GeneStart;
my %GeneEnd;
my %GeneStrand;
my %GeneChr;
my %Utr5Start;
my %Utr5End;
my %Utr3Start;
my %Utr3End;
my %PromStart;
my %PromEnd;
my %AltPromStart;
my %AltPromEnd;
my %DownStart;
my %DownEnd;
my %AltDownStart;
my %AltDownEnd;
my $out;

####################################
#Reads the gff and store coordinates
####################################

my $line=<IN>;
while ($line=<IN>)
{
 chomp ($line);
 @holder = split (/\t/, $line);
 
 if ($holder[2] eq "gene")
 {
  $GeneChr{$holder[9]}=$holder[12];
  $GeneStrand{$holder[9]}=$holder[6];
  $GeneStart{$holder[9]}=$holder[3];
  $GeneEnd{$holder[9]}=$holder[4];
 
  if($holder[6]  eq "+")
  {
   $AltPromStart{$holder[9]}=$holder[3]-$promlength;
   $AltPromEnd{$holder[9]}=$holder[3]-1;
   $AltDownStart{$holder[9]}=$holder[4]+1;
   $AltDownEnd{$holder[9]}=$holder[4]+$promlength;

  }
  elsif($holder[6]  eq "-")
  {
   $AltPromStart{$holder[9]}=$holder[4]+1;
   $AltPromEnd{$holder[9]}=$holder[4]+$promlength;
   $AltDownStart{$holder[9]}=$holder[3]-$promlength;
   $AltDownEnd{$holder[9]}=$holder[3]-1;
  }
 }
 
 elsif ($holder[2] eq "5\'UTR")
 {
  $Utr5Start{$holder[9]}=$holder[3];
  $Utr5End{$holder[9]}=$holder[4];
  
  if($holder[6]  eq "+")
  {
   $PromStart{$holder[9]}=$holder[3]-$promlength;
   $PromEnd{$holder[9]}=$holder[3]-1;
  }
  elsif($holder[6]  eq "-")
  {
   $PromStart{$holder[9]}=$holder[4]+1;
   $PromEnd{$holder[9]}=$holder[4]+$promlength;
  }
 }
 
 elsif ($holder[2] eq "3\'UTR")
 {
  $Utr3Start{$holder[9]}=$holder[3];
  $Utr3End{$holder[9]}=$holder[4];
  
  if($holder[6]  eq "+")
  {
   $DownStart{$holder[9]}=$holder[4]+1;
   $DownEnd{$holder[9]}=$holder[4]+$promlength;
  }
  elsif($holder[6]  eq "-")
  {
   $DownStart{$holder[9]}=$holder[3]-$promlength;
   $DownEnd{$holder[9]}=$holder[3]-1;
  }
 }
}

close IN;
print "name\tchr\tstrand\tstart\tend\tprom_start\tprom_end\tutr5_start\tutr5_end\tRT_start\tRT_end\tutr3_start\tutr3_end\n";

for $out (keys %GeneChr)
{
 print "$out\t$GeneChr{$out}\t$GeneStrand{$out}\t$GeneStart{$out}\t$GeneEnd{$out}\t";

 if(exists($PromStart{$out}))
 {
  print "$PromStart{$out}\t$PromEnd{$out}\t$Utr5Start{$out}\t$Utr5End{$out}\t";
 }
 else
 {
  print "$AltPromStart{$out}\t$AltPromEnd{$out}\tNA\tNA\t";
 }
 if(exists($DownStart{$out}))
 {
  print "$DownStart{$out}\t$DownEnd{$out}\t$Utr3Start{$out}\t$Utr3End{$out}\n";
 }
 else
 {
  print "$AltDownStart{$out}\t$AltDownEnd{$out}\tNA\tNA\n";
 }
}













