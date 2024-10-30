### Settong ###
jellyfish_path="/home/yuki_ito/work2/App/jellyfish-2.3.0"
genomescope_path="/home/yuki_ito/work2/App/genomescope"
fastq_path="/home/yuki_ito/work2/Src/dorado_Gryllus_assimillis/dorado_J_filtered.fastq"
WORK_DIR="/home/yuki_ito/work2/Tasks/genomescope/Jamaican"
thread=

conda activate genomescope
### genomescope ###
cd $jellyfish_path

### fastq
jellyfish count -C -m 21 -s 1000000000 -t $thread $fastq_path -o $WORK_DIR/reads.jf

jellyfish histo -t $thread $WORK_DIR/reads.jf > $WORK_DIR/reads.histogram
cd $genomescope_path
Rscript genomescope.R $WORK_DIR/reads.histogram 21 301 $WORK_DIR/output_dir
