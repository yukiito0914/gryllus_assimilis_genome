### setting ###
WORK_DIR="/home/yuki_ito/work2/Tasks/purge_haplotigs/Jamaican"
INPUT_BAM="/home/yuki_ito/work2/Tasks/make_BAM/Jamaican/purge_haplotigs.bam"
INPUT_FASTA="/home/yuki_ito/work2/Tasks/blobtools/Jamaican/flye_new/J_No_contami.fa"
THREADS=

### purge_haplotigs ###
conda activate purge_haplotigs
cd $WORK_DIR
purge_haplotigs  hist  -b $INPUT_BAM  -g $INPUT_FASTA  -t $THREADS
purge_haplotigs  cov -i /home/yuki_ito/work2/Tasks/purge_haplotigs/Jamaican/purge_haplotigs.bam.gencov  -l 3  -m 53  -h 10000  
purge_haplotigs purge -g $INPUT_FASTA -c coverage_stats.csv -t $THREADS
