# First, the RNA-seq data is assembled once before mapping it to the genome, then reads are mapped to the resulting transcript sequences, and only the reads that can be mapped are recovered. This takes advantage of the fact that a minority of reads, such as those shown in the figure above, are ignored in de novo assembly.

### setting ###
trinity_OUTPUT_DIR="/work3/yuki_ito/out/trinity/Jamaican"
hisat_OUTPUT_DIR="/work3/yuki_ito/out/hisat2/Jamaican"
RNAseq_1="/work3/korogi/RNA_Seq_Jamaican/data/share/project/rawdata_manager/fastq_management/result/RH23108158/RNAseq_1.fastq.gz"
RNAseq_2="/work3/korogi/RNA_Seq_Jamaican/data/share/project/rawdata_manager/fastq_management/result/RH23108158/RNAseq_2.fastq.gz"
draft_ganome="/home/yuki_ito/work2/Tasks/RepeatMask/Jamaican/draft_genome.sort.rename.fasta"
thread=
# No need to use repeat-masked sequences
max_memory="64G"
maxintronlen="100000"

### trinity ###
conda activate trinity

Trinity \
--seqType fq \
--left $RNAseq_1 \
--right $RNAseq_2 \
--CPU $thread \
--max_memory $max_memory \
--no_salmon \
--output $trinity_OUTPUT_DIR/trinity_out_dir

### mapping ###
conda activate hisat2
cd $hisat_OUTPUT_DIR
hisat2-build -p $thread $trinity_OUTPUT_DIR/trinity_out_dir.Trinity.fasta INDEX
hisat2 -x INDEX -1 $RNAseq_1 -2 $RNAseq_2 -p $thread -S Trinity.sam
samtools view -f 0x2 -bh Trinity.sam > temp.bam
samtools sort -@$thread -o Trinity.bam temp.bam
samtools index -@$thread Trinity.bam
rm temp.bam

samtools bam2fq -n -1 CLEAN_1.fastq.gz -2 CLEAN_2.fastq.gz Trinity.bam

hisat2-build -p 8 $draft_ganome GENOME
hisat2 -x GENOME -1 CLEAN_1.fastq.gz -2 CLEAN_2.fastq.gz -p $thread --max-intronlen $maxintronlen -S CLEAN.sam
samtools view -bh CLEAN.sam > CLEAN.bam
samtools sort -@$thread -o CLEAN.sorted.bam CLEAN.bam
samtools index -@$thread CLEAN.sorted.bam

###  Trinity genome-guided RNA-Seq assemblies ###
conda activate trinity

cd $trinity_GG_OUTPUT_DIR
Trinity \
--genome_guided_bam $hisat_OUTPUT_DIR/CLEAN.sorted.bam \
--max_memory $max_memory \
--genome_guided_max_intron $maxintronlen \
--CPU $thread
