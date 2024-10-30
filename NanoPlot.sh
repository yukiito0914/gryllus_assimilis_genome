###setting###
INPUT_FASTQ="/home/yuki_ito/work2/Src/dorado_Gryllus_assimillis/dorado_J_filtered.fastq"
OUT_DIR="/home/yuki_ito/work2/Tasks/Gryllus_assimilis/nanoplot/output_dorado_filtered"
THREADS=

conda activate nanoplot
###NanoPlot###
NanoPlot --fastq $INPUT_FASTQ -t $THREADS -o $OUT_DIR
