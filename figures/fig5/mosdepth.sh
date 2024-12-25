### SETTING ###
WORK_DIR=/home/yuki_ito/work2/Tasks/mosdepth/Jamaican_v1.1
THREADS=
BAM_INPUT=/home/yuki_ito/work2/Tasks/mosdepth/Jamaican_v1.1/Jamaican_chr_1-15.bam
PRFIX=Gass_cov

### mosdepth ###
conda activate mosdepth
cd $WORK_DIR
mosdepth -t $THREADS --no-per-base --fast-mode --by 500000 $PRFIX $BAM_INPUT
