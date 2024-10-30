### setting ###
WORK_DIR="/home/yuki_ito/work2/Tasks/MaSuRCA/Jamaican/insert_size"
INPUT_BAM="/home/yuki_ito/work2/Tasks/make_BAM/Jamaican/purgehaplotigs_flye/short_to_flye.bam"
THREADS=

### insert size ###
conda activate picard
cd $WORK_DIR
picard CollectInsertSizeMetrics INPUT=$INPUT_BAM OUTPUT=insert_size_metric.tsv H=insert_size_metric.pdf
