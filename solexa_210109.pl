use strict;
use warnings;


########################
if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (OUT, ">", $out) or die 'could not open output file';
########################


my $line;
my $line1;
my $mid;
my $chr;
my $gene;
my $count=0;
my $check=0;

my @holder;
my @holder1;

my $trna=0;
my $snorna=0;
my $snrna=0;
my $ncrna=0;
my $rrna=0;
my $genes=0;
my $intron=0;
my $inter=0;

my $Ttrna=0;
my $Tsnorna=0;
my $Tsnrna=0;
my $Tncrna=0;
my $Trrna=0;
my $Tgenes=0;
my $Tintron;
my $Tinter=0;

my $signal=0;
my $rand=0;
my $tot;
while ($line=<IN>)
{
        $count++;
        chomp ($line);

        @holder = split (/\t/, $line);
        if ($holder[4] =~ /TRNA/){$Ttrna++;}
        elsif ($holder[4] =~ /SPSNORNA/){$Tsnorna++;}
        elsif ($holder[4] =~ /SPSNRNA/){$Tsnrna++;}
        elsif ($holder[4] =~ /SPRRNA/){$Trrna++;}
        elsif ($holder[4] =~ /SPNCRNA/){$Tncrna++;}
        elsif ($holder[4] =~ /INTERGENIC/){$Tinter++;}
        elsif ($holder[4] =~ /INTRON/){$Tintron++;}
        else {$Tgenes++;}        
        
            
}
close IN;

open (IN, $in) or die 'could not find the input file';

print OUT "count\ttrna\tsnorna\tsnrna\trrna\tncrna\tinter\tintron\tgenes\trandom\tsignal\tXXX\tcount\ttrna\tsnorna\tsnrna\trrna\tncrna\tinter\tintron\tgenes\trandom\tsignal\n";
$tot=$count/2;
$count=0;
@holder=0;
print "$Ttrna\n$Tsnorna\n$Tsnrna\n$Trrna\n$Tncrna\n$Tinter\n$Tintron\n$Tgenes\n";

while ($line=<IN>)
{
        $count++;
        chomp ($line);

        @holder = split (/\t/, $line);
        if ($holder[4] =~ /TRNA/){$trna++;}
        elsif ($holder[4] =~ /SPSNORNA/){$snorna++;}
        elsif ($holder[4] =~ /SPSNRNA/){$snrna++;}
        elsif ($holder[4] =~ /SPRRNA/){$rrna++;}
        elsif ($holder[4] =~ /SPNCRNA/){$ncrna++;}
        elsif ($holder[4] =~ /INTERGENIC/){$inter++;}
        elsif ($holder[4] =~ /INTRON/){$intron++;}
        else {$genes++;}        
        $mid=int(rand(2));
        $rand=$rand+$mid;
        
        $signal = $holder[3];

print OUT "$count\t$trna\t$snorna\t$snrna\t$rrna\t$ncrna\t$inter\t$intron\t$genes\t$rand\t$signal\tXXX\t$count\t".($trna/$Ttrna*100)."\t".($snorna/$Tsnorna*100)."\t".($snrna/$Tsnrna*100)."\t".($rrna/$Trrna*100)."\t".($ncrna/$Tncrna*100)."\t".($inter/$Tinter*100)."\t".($intron/$Tintron*100)."\t".($genes/$Tgenes*100)."\t".($rand/$tot*100)."\t$signal\n";

}
close IN;
close OUT;
