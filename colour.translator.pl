#!/usr/bin/perl
use warnings;
use strict;

if (@ARGV != 1) {die "need 1 sequence";}
(my $in)=@ARGV;


my $i;
my $out1;
my $out2;
my $line;
my @trans;
my $count=0;
my $count1=0;
my $point;
my $dir;

@trans=split(//, $in);

if (grep(/[0123]/,@trans))
{
 $dir = "cs";
}
elsif (grep(/[ATCG]/,@trans))
{
 $dir = "sc";
}
else
{
die "can't regognise the input format";
}

print "$dir\n";

if ($dir eq "sc")
{
 for ($i = 0; $i <= $#trans-1; $i++)
 {
  print $trans[$i];

  if ($trans[$i] eq "A")
  {
   if ($trans[$i+1] eq "A"){$trans[$i]=0;}
   elsif ($trans[$i+1] eq "C"){$trans[$i]=1;}
   elsif ($trans[$i+1] eq "G"){$trans[$i]=2;}
   elsif ($trans[$i+1] eq "T"){$trans[$i]=3;}
  }
  elsif ($trans[$i] eq "C")
  {
   if($trans[$i+1] eq "C"){$trans[$i]=0;}
   elsif ($trans[$i+1] eq "A"){$trans[$i]=1;}
   elsif ($trans[$i+1] eq "T"){$trans[$i]=2;}
   elsif ($trans[$i+1] eq "G"){$trans[$i]=3;}
  }
  elsif ($trans[$i] eq "G")
  {     
   if ($trans[$i+1] eq "G"){$trans[$i]=0;}
   elsif($trans[$i+1] eq "T"){$trans[$i]=1;}
   elsif ($trans[$i+1] eq "A"){$trans[$i]=2;}
   elsif ($trans[$i+1] eq "C"){$trans[$i]=3;}
  }	
  elsif ($trans[$i] eq "T")
  {
   if ($trans[$i+1] eq "T"){$trans[$i]=0;}
   elsif ($trans[$i+1] eq "G"){$trans[$i]=1;}
   elsif ($trans[$i+1] eq "C"){$trans[$i]=2;}
   elsif ($trans[$i+1] eq "A"){$trans[$i]=3;}
  }
 }
}

elsif ($dir eq "cs")
{
 for ($i = 1; $i <= $#trans; $i++)
 {
  print $trans[$i];
  if ($trans[$i-1] eq "A")
  {
   if ($trans[$i] == 0){$trans[$i]="A";}
   elsif ($trans[$i] == 1){$trans[$i]="C";}
   elsif ($trans[$i] == 2){$trans[$i]="G";}
   elsif ($trans[$i] == 3){$trans[$i]="T";}
  }
  elsif ($trans[$i-1] eq "C")
  {
   if($trans[$i] == 0){$trans[$i]="C";}
   elsif ($trans[$i] == 1){$trans[$i]="A";}
   elsif ($trans[$i] == 2){$trans[$i]="T";}
   elsif ($trans[$i] == 3){$trans[$i]="G";}
  }
  elsif ($trans[$i-1] eq "G")
  {  
   if ($trans[$i] == 0){$trans[$i]="G";}
   elsif($trans[$i] == 1){$trans[$i]="T";}
   elsif ($trans[$i] == 2){$trans[$i]="A";}
   elsif ($trans[$i] == 3){$trans[$i]="C";}
  }       
  elsif ($trans[$i-1] eq "T")
  {
   if ($trans[$i] == 0){$trans[$i]="T";}
   elsif ($trans[$i] == 1){$trans[$i]="G";}
   elsif ($trans[$i] == 2){$trans[$i]="C";}
   elsif ($trans[$i] == 3){$trans[$i]="A";}
  }
 }
}

my $out =join("",@trans);
chop $out;
print "\n$out\n";


