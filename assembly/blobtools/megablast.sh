### setting ###
WOR_DIR=/Users/kosukekataoka/work1/blobtools/blobtools_ito231118/J
FASTA=$WOR_DIR/assembly.fasta
FATSA_NAME=assembly.fasta

### megablast ###
cd $WOR_DIR
blastn \
-query ${FATSA_NAME} \
-task megablast \
-db nt \
-outfmt '6 qseqid staxids bitscore std sscinames sskingdoms stitle' \
-culling_limit 10 \
-num_threads 20 \
-evalue 1e-25 \
-out ${FATSA_NAME}.vs.nt.megablast.out
