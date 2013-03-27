#!/usr/bin/perl
#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 2) {die "need 2 file names";}
(my $in, my $out)=@ARGV;

open (IN, $in) or die 'could not find the input file';
#open (IN1, $in) or die 'could not find the chromosome file';
#open (IN2, $reads) or die 'could not find the chromosome file';
open (OUT, ">", $out) or die 'could not open output file';
#open (OUT2, ">", $out2) or die 'could not open second output file';

########################


my $line;
my $line1;
my $line2;
my $count=0;
my $count1=0;
my $count2=0;
my $count3=0;
my $chrom;
my $length;
my $holder;
my @holder;
my @holder1;
my @read;
my %reads;
my %seq;

#####################
#while ($line1=<IN1>)
#{
#$count1++;
#$chrom = $chrom.$line1;
#substr($line1,10);
#$chrom=$line1;
#}#
#$length=$count1*60;
#print "contig has been parsed\n";
#####################
while ($line=<IN>)
{
        
        $count++;
        
        chomp ($line);

        @holder = split (/ /, $line);
        #print "$holder[12]\n";
        if ($holder[2] eq "UNMAPPED")
        {
        $holder=$holder[3];
        }
        else
        {
        @holder1 = split (/\t/, $holder[12]);
        $holder=$holder1[1];
        }
        #print "$holder1[1]\n";
        unless ($holder[0]){next;}
        if ($holder[0] ne "vulgar:"){next;}
        #if (($holder[2]*$holder[3])!= 0)
        #{
        #
        #next;
        #}
        if ($reads{$holder[1]})
        {
        $reads{$holder[1]}++;
        }
        else 
        {
        $count2++;
        $reads{$holder[1]}=1;
        $seq{$holder[1]}=$holder;
        }
}
for my $out1 (keys %reads)
{
if ($reads{$out1}==1)
{
$count1++;
print OUT ">$out1\n$seq{$out1}\n";
}
}

print "total: ".$count."\n";
print "reads: ".$count2."\n";
print "unique match: ".$count1."\n";

close IN;
close OUT;
