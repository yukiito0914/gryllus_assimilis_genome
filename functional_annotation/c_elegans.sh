### setting ###
WORK_DIR=/home/yuki_ito/work2/Tasks/blast/Jamaican
query=/home/yuki_ito/work2/Data/Jamaican/gass_v1.0.protein.fasta
db_dir=/work2/kataoka/fanflow_db
db_name=(
Caenorhabditis_elegans.WBcel235.pep.all
)
evalue_blast=1e-10
threads=

### blastp ###
conda activate blast
cd $WORK_DIR
for i in ${db_name[@]}; do

blastp \
 -query $query \
 -db $db_dir/${i}.fa \
 -outfmt 6 \
 -max_target_seqs 1 \
 -evalue $evalue_blast \
 -num_threads $threads \
 -out $WORK_DIR/blastp_out_${i}.txt

done
