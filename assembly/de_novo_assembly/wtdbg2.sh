### setting ###
WOR_DIR="/home/yuki_ito/work2/Tasks/Gryllus_assimilis/wtdbg2/wtdbg2_dorado"
INPUT="/home/yuki_ito/work2/Src/dorado_Gryllus_assimillis/dorado_J_filtered.fastq"
THREADS=

### wtdbg2 ###
conda activate wtdbg
cd $WOR_DIR
wtdbg2 -t $THREADS -i $INPUTS -fo prefix
wtpoa-cns -t $THREADS -i prefix.ctg.lay.gz -fo prefix.ctg.lay.fa
