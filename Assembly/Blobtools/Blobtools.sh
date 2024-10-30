### setting ###
WOR_DIR=/Users/kosukekataoka/work1/blobtools/blobtools_ito231118/J
FASTA=$WOR_DIR/assembly.fasta
BAM_IN=$WOR_DIR/3polished.bam
BLAST_OUT=$WOR_DIR/assembly.fasta.vs.nt.megablast.out

### blobtools ###
cd $WOR_DIR && blobtools create \
-i $FASTA \
-b $BAM_IN \
-t $BLAST_OUT \
-o blobtools_create_out

blobtools view -i blobtools_create_out.blobDB.json

blobtools plot -i blobtools_create_out.blobDB.json
