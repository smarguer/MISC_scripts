#!/usr/bin/perl


use strict;
use warnings;
use POSIX;
my $line;
my $line1;
my $count=0;
my $count1=0;
my @holder;
my @sorted;
my $motif="no motif";
my %gene;

#######################
#Takes input
#######################

if (@ARGV != 1) {die "I need 2 file names";}
(my $in)=@ARGV;

open (IN, $in) or die 'could not find the mapping output';

######################################
#parses Exonerate output
######################################
print "name\tmotif\n";

while ($line=<IN>)
{
	
	$count++;
	chomp ($line);

unless(defined($line))
{
next;
}
#print "$count\n";
if ($line =~ /[ATCG]{6}/)
{
 $motif=$line;
 #print "$motif\n";
}
elsif ($line =~ /(gene=\")(S\w+\.\d+\w*)"/)
{
 @holder= ($line =~ m/gene=\"(S\w+\.\d+\w*)"/g);
 #print "@holder";
 #print "\n";
 @sorted = sort { $a cmp $b } @holder;
 #print "@sorted";
 #print "\n";
 
 print "$sorted[0]\t$motif\n";
 @holder=();
 @sorted=();
}


}		
####################################################################################




close IN;
#close OUT;
