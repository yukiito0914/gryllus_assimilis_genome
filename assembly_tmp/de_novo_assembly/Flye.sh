### setting ###
INPUT="/home/yuki_ito/work2/Src/dorado_Gryllus_assimillis/dorado_J_filtered.fastq"
OUT_DIR="/home/yuki_ito/work2/Tasks/Gryllus_assimilis/flye/dorado_new"
THREADS=

### flye ###
conda activate flye_latest
flye --nano-raw $INPUT  --out-dir $OUT_DIR --threads $THREADS
