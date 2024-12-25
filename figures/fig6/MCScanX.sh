

### setting ###
MCScanX=/home/yuki_ito/work2/App/MCScanX/MCScanX
INPUT_PROTEIN1=/home/yuki_ito/work2/Data/Jamaican_v3/UTR/gass_v1.1.protein.fasta
INPUT_PROTEIN2=/home/yuki_ito/work2/Tasks/orthofinder/Jamaican_tree/db/Acheta_domesticus.fasta
WOR_DIR=/home/yuki_ito/work2/Tasks/MCScanX/Jamaican_v1.1
db_name=Gass_Adom

conda activate blast
cd $WOR_DIR
cat $INPUT_PROTEIN1 $INPUT_PROTEIN2 > merged_protein.fa

makeblastdb -in merged_protein.fa -out $db_name -dbtype prot -parse_seqids
blastp -query $INPUT_PROTEIN1 -db $db_name -evalue 1e-10 -outfmt 6 -max_target_seqs 5 -out Gryllus_assimilis.blast
blastp -query $INPUT_PROTEIN2 -db $db_name -evalue 1e-10 -outfmt 6 -max_target_seqs 5 -out Acheta_domesticus.blast
cat Gryllus_assimilis.blast Acheta_domesticus.blast > Gass_Adom.blast

### MCScanX ###
# Move db_name.blast and db_name.gff to WOR_DIR
$MCScanX $db_name
