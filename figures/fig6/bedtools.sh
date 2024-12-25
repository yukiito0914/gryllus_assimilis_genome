### setting ###
# INPUT_GFF=/work3/korogi/Adom/Adom_genes_v2.0.r.gff3
# OUT_DIR=/home/yuki_ito/work2/Tasks/MCScanX/bedtools/Jamaican
INPUT_GFF=/home/yuki_ito/work2/Data/Jamaican_v3/UTR/gass_v1.1.structual_annotation.gff
OUT_DIR=/home/yuki_ito/work2/Tasks/MCScanX/Jamaican_v1.1


conda activate bedtools
cd $OUT_DIR
# sortBed -i $INPUT_GFF | gff2bed > Acheta_domesticus.bed
sortBed -i $INPUT_GFF | gff2bed > Gryllus_assimilis.bed
