
echo "creating bed file"
perl /jurg/homedir/samuel/POMBE_SEQ/analysis/SCRIPTS/MISC_scripts/MAPtoBED.pl $1
echo "computing normalisation factor"
depth=`wc -l $1.bed | cut -f1 -d' '`
depth=`echo "scale=8; $depth / 1000000" | bc`
fac=`echo "scale=5; 1 / $depth" | bc`
echo "the depth is: $depth"
echo "the normalisation factor is: $fac"
echo "creating bedgraph files"
/data02/software/bedtools-master/bin/genomeCoverageBed -i $1.bed -g ALLchromosomes.090511.genome -split -bg -scale $fac > $1.bedgraph                            
echo "creating BigWig files"
/data02/software/bedGraphToBigWig $1.bedgraph ALLchromosomes.090511.genome $1.bw
echo "creating BAM file with index"
/data02/software/bedtools-master/bin/bedToBam -i $1.bed -g ALLchromosomes.090511.genome > $1.bam
samtools index $1.bam
echo "cleaning up"
rm -f $1.bed
rm -f $1.bedgraph




