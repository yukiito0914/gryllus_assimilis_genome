### setting ###
WORK_DIR="/work3/yuki_ito/out/RepeatMask/Jamaican"
INPUT_FASTA="/home/yuki_ito/work2/Tasks/RepeatMask/Jamaican/draft_genome.sort.rename.fasta"
THREADS=

### RepeatMasking ###
conda activate repeatmasking
cd $WORK_DIR
BuildDatabase -name genome_database $INPUT_FASTA
RepeatModeler -database genome_database -threads $THREADS
RepeatMasker $INPUT_FASTA -pa $THREADS -a -lib /work3/yuki_ito/out/RepeatMask/Jamaican/RM_12025.SunMar311001542024/consensi.fa.classified
