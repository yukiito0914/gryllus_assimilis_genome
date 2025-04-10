WORK_DIR=/work/sanno/Orthofinder/output/analysis/trimal
cd $WORK_DIR

iqtree \
-sp partition.nexus \
-nt AUTO \
-bb 1000 \
-m MFP \
-alrt 1000 \
-T 16
