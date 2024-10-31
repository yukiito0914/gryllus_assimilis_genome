### setting ###
WOR_DIR="/home/yuki_ito/work2/Tasks/gffcompare/Jamaican"
genome="/home/yuki_ito/work2/Data/Jamaican/draft_genome.sort.rename.softmasked.fasta"
BRAKER3="/work3/yuki_ito/out/braker/Braker3_ito/Jamaican/braker.gtf"
gemoma_AP="/work3/yuki_ito/out/gemoma/Apis_GAF/filtered_predictions.gff" 
gemoma_DM="/work3/yuki_ito/out/gemoma/dmel_GAF/filtered_predictions.gff" 
gemoma_TC="/work3/yuki_ito/out/gemoma/trib_GAF/filtered_predictions.gff"
gemoma_Teleogryllus="/work3/yuki_ito/out/gemoma/Teleogryllus_GAF/filtered_predictions.gff"
stringtie="/work3/yuki_ito/stringtie2/Jamaican/stringtie.transdecoder.FINAL.edit.gff3"

### gffcompare ###
conda activate gffcompare
cd $WOR_DIR
mkdir ./braker3
mkdir ./gemoma_AP
mkdir ./gemoma_DM
mkdir ./gemoma_TC
mkdir ./gemoma_Teleogryllus
mkdir ./stringtie2

### first step ###
gffcompare \
 $gemoma_AP \
 -r $BRAKER3 \
 -o ./gemoma_AP/gffcmp

gffcompare \
 $gemoma_DM \
 -r $BRAKER3 \
 -o ./gemoma_DM/gffcmp

gffcompare \
 $gemoma_TC \
 -r $BRAKER3 \
 -o ./gemoma_TC/gffcmp

gffcompare \
 $gemoma_Teleogryllus \
 -r $BRAKER3 \
 -o ./gemoma_Teleogryllus/gffcmp

gffcompare \
 $stringtie \
 -r $BRAKER3 \
 -o ./stringtie2/gffcmp

### second step ###
## i, y, u ##
cat ./gemoma_AP/gffcmp.tracking | awk '$4=="u" || $4=="i" || $4=="y" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_AP/GeMoMa_AP.keep.list
cat $gemoma_AP | grep -wf ./gemoma_AP/GeMoMa_AP.keep.list > ./gemoma_AP/gemoma_AP_keep.gff

cat ./gemoma_DM/gffcmp.tracking | awk '$4=="u" || $4=="i" || $4=="y" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_DM/GeMoMa_DM.keep.list
cat $gemoma_DM | grep -wf ./gemoma_DM/GeMoMa_DM.keep.list > ./gemoma_DM/gemoma_DM_keep.gff

cat ./gemoma_TC/gffcmp.tracking | awk '$4=="u" || $4=="i" || $4=="y" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_TC/GeMoMa_TC.keep.list
cat $gemoma_TC | grep -wf ./gemoma_TC/GeMoMa_TC.keep.list > ./gemoma_TC/gemoma_TC_keep.gff

cat ./gemoma_Teleogryllus/gffcmp.tracking | awk '$4=="u" || $4=="i" || $4=="y" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_Teleogryllus/GeMoMa_Teleogryllus.keep.list
cat $gemoma_Teleogryllus | grep -wf ./gemoma_Teleogryllus/GeMoMa_Teleogryllus.keep.list > ./gemoma_Teleogryllus/gemoma_Teleogryllus_keep.gff

cat ./stringtie2/gffcmp.tracking | awk '$4=="u" || $4=="i" || $4=="y" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' > ./stringtie2/stringtie2.keep.list
cat $stringtie | grep -wf ./stringtie2/stringtie2.keep.list > ./stringtie2/stringtie2_keep.gff

## u ##
# cat ./gemoma_AP/gffcmp.tracking | awk '$4=="u" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_AP/GeMoMa_AP.keep.list
# cat $gemoma_AP | grep -wf ./gemoma_AP/GeMoMa_AP.keep.list > ./gemoma_AP/gemoma_AP_keep.gff

# cat ./gemoma_DM/gffcmp.tracking | awk '$4=="u" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_DM/GeMoMa_DM.keep.list
# cat $gemoma_DM | grep -wf ./gemoma_DM/GeMoMa_DM.keep.list > ./gemoma_DM/gemoma_DM_keep.gff

# cat ./gemoma_TC/gffcmp.tracking | awk '$4=="u" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_TC/GeMoMa_TC.keep.list
# cat $gemoma_TC | grep -wf ./gemoma_TC/GeMoMa_TC.keep.list > ./gemoma_TC/gemoma_TC_keep.gff

# cat ./gemoma_Teleogryllus/gffcmp.tracking | awk '$4=="u" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' | sed '/^$/d' > ./gemoma_Teleogryllus/GeMoMa_Teleogryllus.keep.list
# cat $gemoma_TC | grep -wf ./gemoma_Teleogryllus/GeMoMa_Teleogryllus.keep.list > ./gemoma_Teleogryllus/gemoma_Teleogryllus_keep.gff

# cat ./stringtie2/gffcmp.tracking | awk '$4=="u" {print $5}' | awk -F ":" '{print $2}' |  awk -F "|" '{print $2}' > ./stringtie2/stringtie2.keep.list
# cat $stringtie | grep -wf ./stringtie2/stringtie2.keep.list > ./stringtie2/stringtie2_keep.gff

### GeMoMa ###
conda activate gemoma

GeMoMa AnnotationEvidence a=$BRAKER3 g=$genome outdir=./braker3
GeMoMa AnnotationEvidence a=./gemoma_AP/gemoma_AP_keep.gff g=$genome outdir=./gemoma_AP 
GeMoMa AnnotationEvidence a=./gemoma_DM/gemoma_DM_keep.gff g=$genome outdir=./gemoma_DM
GeMoMa AnnotationEvidence a=./gemoma_TC/gemoma_TC_keep.gff g=$genome outdir=./gemoma_TC
GeMoMa AnnotationEvidence a=./gemoma_Teleogryllus/gemoma_Teleogryllus_keep.gff g=$genome outdir=./gemoma_Teleogryllus
GeMoMa AnnotationEvidence a=./stringtie2/stringtie2_keep.gff g=$genome outdir=./stringtie2

GeMoMa GAF g=./braker3/annotation_with_attributes.gff \
 g=./gemoma_AP/annotation_with_attributes.gff \
 g=./gemoma_DM/annotation_with_attributes.gff \
 g=./gemoma_TC/annotation_with_attributes.gff \
 g=./gemoma_Teleogryllus/annotation_with_attributes.gff \
 g=./stringtie2/annotation_with_attributes.gff \
 tf=true \
 outdir=$WOR_DIR

### AnnotationFinalizer (NO UTR)###
mkdir ./NO_UTR
GeMoMa AnnotationFinalizer \
 g=$genome \
 a=$WOR_DIR/filtered_predictions.gff \
 u=NO \
 tf=true \
 rename=COMPOSED \
 p=Gbim \
 infix=G \
 d=6 \
 outdir=$WOR_DIR/NO_UTR

### AnnotationFinalizer (UTR)###
denoised_introns=/work3/yuki_ito/out/gemoma/denoised_introns.gff
coverage_forward=/work3/yuki_ito/out/gemoma/coverage_forward.bedgraph
coverage_reverse=/work3/yuki_ito/out/gemoma/coverage_reverse.bedgraph

mkdir ./UTR
GeMoMa AnnotationFinalizer \
 g=$genome \
 a=$WOR_DIR/filtered_predictions.gff \
 u=YES \
 i=$denoised_introns \
 c=STRANDED \
 coverage_forward=$coverage_forward \
 coverage_reverse=$coverage_reverse \
 tf=true \
 rename=COMPOSED \
 p=Gbim \
 infix=G \
 d=6 \
 outdir=$WOR_DIR/UTR
