#!/usr/bin/perl


use strict;
use warnings;

my $line;
my $line1;
my $count=0;
my $count1=0;
my $count2=0;
my $holder;
my @holder;
my @holder1;
my %map;

if (@ARGV != 3) {die "need 3 file names";}
(my $in, my $in1, my $out)=@ARGV;

open (IN, $in) or die 'could not find mapping output file';
open (IN1, $in1) or die 'could not find fasta file';
open (OUT, ">", $out) or die 'could not open output file';

print "reading mapped reads file...\n";

while ($line=<IN>)
	{
		
		$count++;
		
	
		chomp ($line);

		$holder = $line;
		if ($map{$holder}) {$map{$holder}++;}
		else {$map{$holder} = 1;}
		
	}


#print "sorting reads...\n";
#
while ($line1=<IN1>)
{
	$count1++;
	@holder = split (/ /, $line1);	
#	if ($line1 =~ /[>]/)
#	{
#	chomp($line1);
#	$holder=substr($line1,1);
#keeps reads which are not in the list		
##########################################################		
		if ($map{$holder[1]})
		{
		print OUT "$line1";
		$count2=0;
		}
		else
		{
		next;
		$count2=1;
		}
#keeps reads in the list		
##########################################################	
                #if ($map{$holder})
                #{
                #print OUT "$holder\t$map{$holder}\t1\n";
                #print OUT1 ">$holder\n";
		#$count2=1;
                #}
                #else
                #{
                #print OUT "$holder\t0\t0\n";
                #print OUT1 ">$holder\n";
                #$count2=0;
                #}
			
#	}
#	
#	elsif ($count2==1)
#	
#	{
#	print OUT1 "$line1";
#	}
	
}

#print "$holder\n\n";


#print "Done\n";

close IN;
close IN1;
close OUT;
#close OUT1;





