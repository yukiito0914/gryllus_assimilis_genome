### setting ###
INPUT_GFF="/home/yuki_ito/work2/Data/Jamaican/agat_edited_final_annotation.gff"
GENOME_FASTA="/home/yuki_ito/work2/Data/Jamaican/gass_v1.0.genome.sm.fasta"
WOR_DIR="/home/yuki_ito/work2/Data/Jamaican"

### gffread ###
conda activate gffread
cd $WOR_DIR
gffread $INPUT_GFF -g $GENOME_FASTA -w gass_v1.0.mRNA.fasta -x gass_v1.0.CDS.fasta -y gass_v1.0.protein.fasta
gffread -E $INPUT_GFF -g $GENOME_FASTA -T -o agat_edited_final_annotation.gtf
