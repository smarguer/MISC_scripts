#!/usr/bin/perl
#!/usr/bin/perl


use strict;
use warnings;


########################
if (@ARGV != 2) {die "need 2 file name";}
(my $in, my $in1)=@ARGV;

open (IN, $in) or die 'could not find the input file';
open (IN1, $in1) or die 'could not find the chromosome file';
#open (IN2, $reads) or die 'could not find the chromosome file';
#open (OUT, ">", $out) or die 'could not open output file';
#open (OUT2, ">", $out2) or die 'could not open second output file';

########################


my $line;
my $line1;
my $chr;
my $i;
my $test;
my $posreads=0;
my $negreads=0;
my $count=0;
my @holder;
my @count;
my %count;
my %unique;
#####################
while ($line1=<IN1>)
{
chomp ($line1);
@holder=split (/\t/, $line1);
$i=$holder[3];
for ($i=$holder[3];$i <=$holder[4];$i++)
{
#print "$i\n";
#print "$holder[12]\n";
$count[$holder[12]]{$i}=1;
#print "$count[$holder[12]]{$i}";
}
$i=0;
}
#####################
while ($line=<IN>)
{
        
        #$count++;
        
        chomp ($line);

        @holder = split (/ /, $line);
        unless ($holder[0]){next;}
        if ($holder[0] ne "vulgar:"){next;}
        $test=$holder[6]+18;
	$chr=substr($holder[5],2,1);
	#discard MIT MAT reads
	if ($chr eq "T")
	{
	$count++;
	next;
	}
	if ($unique{$holder[1]})
	{
	next;
	}
	else
	{
	$unique{$holder[1]}=1;
	}
	if ($count[$chr]{$test})
        {
        $posreads++;
        }
        else 
        {
        $negreads++;
        }
}

print "Reads mapping at least once to the trarget region:\n$posreads\nReads without a match:\n$negreads\nReads matching MIT or MAT:\n$count\n";
close IN;
close IN1;
#close OUT;

