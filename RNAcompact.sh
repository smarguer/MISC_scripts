gff=gff_090511.txt
ls -l > image.txt
echo "target is $1"
echo "##Converting ALLchr##"
toDo=$1.ALLchr
perl /jurg/homedir/samuel/POMBE_SEQ/analysis/SCRIPTS/MISC_scripts/MAPtoBED.pl $toDo
/data02/software/bedtools-master/bin/bedToBam -i $toDo.bed -g /jurg/homedir/samuel/POMBE_SEQ/analysis/GENOMES/ALLchromosomes.090511.genome > $toDo.bam
samtools index $toDo.bam
echo "cleaning up"
rm -f $toDo.bed

echo "##dealing with ALLchr.5mis.col##"
echo "creating bed file"
toDo=$1.5mis.ALLchr.col
perl /jurg/homedir/samuel/POMBE_SEQ/analysis/SCRIPTS/MISC_scripts/MAPtoBED.pl $toDo
echo "computing normalisation factor"
depth=`wc -l $toDo.bed | cut -f1 -d' '`
depth=`echo "scale=8; $depth / 1000000" | bc`
fac=`echo "scale=5; 1 / $depth" | bc`
echo "the depth is: $depth"
echo "the normalisation factor is: $fac"
echo "creating bedgraph files"
/data02/software/bedtools-master/bin/genomeCoverageBed -i $toDo.bed -g /jurg/homedir/samuel/POMBE_SEQ/analysis/GENOMES/ALLchromosomes.090511.genome -split -bg -strand + -scale $fac > $toDo.plus.bedgraph
/data02/software/bedtools-master/bin/genomeCoverageBed -i $toDo.bed -g /jurg/homedir/samuel/POMBE_SEQ/analysis/GENOMES/ALLchromosomes.090511.genome -split -bg -strand - -scale $fac > $toDo.minus.bedgraph 
echo "creating BigWig files"
/data02/software/bedGraphToBigWig $toDo.plus.bedgraph /jurg/homedir/samuel/POMBE_SEQ/analysis/GENOMES/ALLchromosomes.090511.genome $toDo.plus.bw
/data02/software/bedGraphToBigWig $toDo.minus.bedgraph /jurg/homedir/samuel/POMBE_SEQ/analysis/GENOMES/ALLchromosomes.090511.genome $toDo.minus.bw
echo "creating BAM file with index"
/data02/software/bedtools-master/bin/bedToBam -i $toDo.bed -g /jurg/homedir/samuel/POMBE_SEQ/analysis/GENOMES/ALLchromosomes.090511.genome > $toDo.bam
samtools index $toDo.bam
echo "cleaning up"
rm -f $toDo.bed
rm -f $toDo.plus.bedgraph
rm -f $toDo.minus.bedgraph

echo "##compress left files##"
bzip2 $1.5mis.ALLchr.left
bzip2 $1.5mis.ALLtrs.left
bzip2 $1.ALLtrs
bzip2 $1.5mis.ALLtrs.GEN.col

#echo "##delete more stuff##"
#rm -f $1.ALLchr
#rm -f $1.fasta
#rm -f $1.5mis.ALLchr
#rm -f $1.5mis.ALLtrs
#rm -f $1.5mis.ALLchr.col.mapIV.$gff
#rm -f $1.5mis.ALLtrs.GEN.col.mapV.$gff
#rm -f $1.5mis.ALLchr.col





