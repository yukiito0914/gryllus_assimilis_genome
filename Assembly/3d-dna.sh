### Setting ###
juicer_path="/home/yuki_ito/work2/App/juicer"
three_d_DNA_path="/home/yuki_ito/work2/App/3d_dna"
WORK_DIR="/work3/yuki_ito/3D_DNA/Jamaican"
genome="/home/yuki_ito/work2/Tasks/purge_haplotigs/Jamaican/curated.fasta"
OmniC_read_1="/work3/korogi/Omni-C/Jamaican/RH23097898/rawdata/Jamaican_1.fq.gz"
OmniC_read_2="/work3/korogi/Omni-C/Jamaican/RH23097898/rawdata/Jamaican_2.fq.gz"
thread=

conda activate omniC
### Preparation ###
cd $WORK_DIR
ln -s $juicer_path/CPU scripts
cd scripts/common
wget https://hicfiles.tc4ga.com/public/juicer/juicer_tools.1.9.9_jcuda.0.8.jar
# check the latest
ln -s juicer_tools.1.9.9_jcuda.0.8.jar  juicer_tools.jar
cd $WORK_DIR
mkdir references && cd references
ln -s $genome draft.fasta
cd $WORK_DIR
mkdir fastq && cd fastq
ln -s $OmniC_read_1 OmniC_R1.fastq.gz
ln -s $OmniC_read_2 OmniC_R2.fastq.gz
# Not recognised without ‘R1’ or ‘R2’.

### 3D-DNA ###
cd $WORK_DIR/references
bwa index draft.fasta

cd $WORK_DIR
$WORK_DIR/scripts/juicer.sh \
-D $WORK_DIR \
-g $WORK_DIR/references/draft.fasta \
-s none \
-z $WORK_DIR/references/draft.fasta \
-p assembly \
-S early \
-t $thread

# If merged_nodups.txt was not created, try the following
samtools view \
-@ $thread \
-O SAM \
-F 1024 \
$WORK_DIR/aligned/merged_dedup.bam | \
awk \
-v mnd=1 \
-f $WORK_DIR/scripts/common/sam_to_pre.awk > $WORK_DIR/aligned/merged_nodups.txt


cd $WORK_DIR
$three_d_DNA_path/run-asm-pipeline.sh \
$WORK_DIR/references/draft.fasta \
$WORK_DIR/aligned/merged_nodups.txt

cd $WORK_DIR
$three_d_DNA_path/run-asm-pipeline-post-review.sh -r \
$WORK_DIR/final_curated.review.assembly \
$WORK_DIR/references/draft.fasta \
$WORK_DIR/aligned/merged_nodups.txt
