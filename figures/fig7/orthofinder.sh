### setting ###
WORK_DIR=/work/sanno/Orthofinder/output
THREADS=

#### orthofinder ##
cd $WORK_DIR
orthofinder -f $WORK_DIR -t $THREADS -a $THREADS -S blast
