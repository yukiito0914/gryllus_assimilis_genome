### setting ###
OUT_DIR=/"work3/yuki_ito/stringtie2/Jamaican"
RNAseq_clean="/work3/yuki_ito/hisat2/Jamaican/CLEAN.sorted.bam"
draft_genome="/home/yuki_ito/work2/Tasks/RepeatMask/Jamaican/draft_genome.sort.rename.softmasked.fasta"
THREADS=

### stringtie2 ###
conda activate stringtie
cd $OUT_DIR
stringtie -p $THREADS -o stringtie.gtf $RNAseq_clean

cd $OUT_DIR
gtf_genome_to_cdna_fasta.pl stringtie.gtf $draft_genome > stringtie.fasta
gtf_to_alignment_gff3.pl stringtie.gtf > stringtie.gff3
TransDecoder.LongOrfs -t stringtie.fasta
TransDecoder.Predict -t stringtie.fasta

cd $OUT_DIR
cdna_alignment_orf_to_genome_orf.pl stringtie.fasta.transdecoder.gff3 \
 Futahoshi_stringtie.gff3 stringtie.fasta > stringtie.transdecoder.FINAL.gff3
sed "s/transdecoder/stringtie/g" stringtie.transdecoder.FINAL.gff3 \
 > stringtie.transdecoder.FINAL.edit.gff3
