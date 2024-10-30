### setting ###
memory="1G"
genome_fasta="/home/yuki_ito/work2/Tasks/Gryllus_assimilis/flye/dorado_new/assembly.fasta"
OUT_DIR="/home/yuki_ito/work2/Tasks/Gryllus_assimilis/POLCA/J_flye_new"
thread=

### POLCA ###
conda activate polca
mkdir $OUT_DIR/polca_1
cd $OUT_DIR/polca_1
cp $genome_fasta genome.fa
polca.sh -a genome.fa -r '/home/yuki_ito/work2/Src/Gryllus_short_read/out_pair1.fq /home/yuki_ito/work2/Src/Gryllus_short_read/out_pair2.fq' -t $thread -m $memory
mv genome.fa.PolcaCorrected.fa polca_1.fa
rm genome.fa

mkdir $OUT_DIR/polca_2
cd $OUT_DIR/polca_2
polca.sh -a $OUT_DIR/polca_1/polca_1.fa -r '/home/yuki_ito/work2/Src/Gryllus_short_read/out_pair1.fq /home/yuki_ito/work2/Src/Gryllus_short_read/out_pair2.fq' -t $thread -m $memory
mv polca_1.fa.PolcaCorrected.fa polca_2.fa

mkdir $OUT_DIR/polca_3
cd $OUT_DIR/polca_3
polca.sh -a $OUT_DIR/polca_2/polca_2.fa -r '/home/yuki_ito/work2/Src/Gryllus_short_read/out_pair1.fq /home/yuki_ito/work2/Src/Gryllus_short_read/out_pair2.fq' -t $thread -m $memory
mv polca_2.fa.PolcaCorrected.fa polca_3.fa
