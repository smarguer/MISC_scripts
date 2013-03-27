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




my $in  = Bio::SeqIO->new(-file => "chromosome1.contig" , -format => "embl");

    while ( my $seq = $in->next_seq() ) {
       print "Sequence ",$seq->id," first 10 bases ",$seq->subseq(1,10),"\n";
    }

