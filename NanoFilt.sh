### setting ###
INPUT="/home/yuki_ito/work2/Src/dorado_Gryllus_assimillis/dorado_J.fastq"
OUTPUT="/home/yuki_ito/work2/Src/dorado_Gryllus_assimillis/dorado_J_filtered.fastq"

### NanoFilt ###
conda activate nanofilt
cat $INPUT |NanoFilt -q 10 > $OUTPUT
