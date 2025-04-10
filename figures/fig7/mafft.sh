### setting ###
INPUT_DIR=/work/sanno/Orthofinder/output/analysis/rename
mafft_DIR=/work/sanno/Orthofinder/output/analysis/mafft
trimal_DIR=/work/sanno/Orthofinder/output/analysis/trimal

### mafft ###
cd $INPUT_DIR

input=`ls -1`

for i in ${input[@]}; do mafft --auto --inputorder $INPUT_DIR/$i > $mafft_DIR/${i}.aln; done
for i in ${input[@]}; do trimal -in $mafft_DIR/${i}.aln -out $trimal_DIR/${i}.trimal.aln -automated1; done
