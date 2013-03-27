#!/usr/bin/perl
#!/usr/bin/perl


use strict;
use warnings;

my $totest=$ARGV[0];
print "$totest\n";
my @RNA=('RRNA','TRNA','SNRNA','SNORNA','NCRNA','LTR','MIT','MTR');
my $tot = `wc -l $totest*.5mis.ALL*col`;
$tot =~ /(\d{1,15})\stotal/;
$tot =$1;
print "mappable: $tot\n";
for (@RNA)
{
my $RNA=$_;
my $toDo=0;
my @toDo=();
my $total=0;
$toDo = `grep -hc '$RNA' $totest*gff_090511.txt`;
@toDo=split(/\n/,$toDo);
for (@toDo){$_=~s/^\s+|\s+$//g};
#print "@toDo\n";
($total+=$_) for @toDo;
print "$RNA: $total\n";
}

#$TRNA += `grep -hc 'TRNA' *gff_090511.txt`;
#print "tRNA: $TRNA\n";

#$SNRNA += `grep -hc 'SNRNA' *gff_090511.txt`;
#print "snRNA: $SNRNA\n";

#$SNORNA += `grep -hc 'SNORNA' *gff_090511.txt`;
#print "snoRNA: $SNORNA\n";

#$LTR += `grep -hc 'LTR' *gff_090511.txt`;
#print "LTR: $LTR\n";


