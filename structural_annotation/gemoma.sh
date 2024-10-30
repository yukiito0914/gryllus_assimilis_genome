# GeMoMa runs on the genomes of Apis mellifera, Drosophila melanogaster, Tribolium castaneum and Teleogryllus occipitalis respectively.

### setting ###
RNAseq_clean="/work3/yuki_ito/hisat2/Jamaican/CLEAN.sorted.bam"
OUT_DIR="/work3/yuki_ito/out/gemoma"
DRAFT_GENOME="/home/yuki_ito/work2/Tasks/RepeatMask/Jamaican/draft_genome.sort.rename.softmasked.fasta"
relative_species_OUTPUT="/work3/yuki_ito/out/gemoma/reference_Teleogryllus"
relative_species_genome="/work3/sanno/Data/Teleogryllus_occipitalis/Teleogryllus_occipitalis_DRAFT.fasta"
relative_species_gff="/work3/sanno/Data/Teleogryllus_occipitalis/Tocc_genes_V1.2.UTR.agat.gff3"
THREADS=

conda activate gemoma
### Extract RNA-seq Evidence ###
GeMoMa ERE s=FR_SECOND_STRAND m=$RNAseq_clean outdir=$OUT_DIR

### Check & Denoise Introns ###
GeMoMa CheckIntrons t=$DRAFT_GENOME i=$OUT_DIR/introns.gff outdir=$OUT_DIR
GeMoMa DenoiseIntrons i=$OUT_DIR/introns.gff c=STRANDED \
 coverage_forward=$OUT_DIR/coverage_forward.bedgraph \
 coverage_reverse=$OUT_DIR/coverage_reverse.bedgraph \
 outdir=$OUT_DIR

### Extract CDS Sequences from Reference ###
GeMoMa Extractor a=$relative_species_gff g=$relative_species_genome outdir=$relative_species_OUTPUT

### REFERENCE CDS mapping to draft GENOME ###
cd $OUT_DIR && mkdir TARGET
mmseqs createdb $DRAFT_GENOME TARGET/GenomeDB -v 2
cd $relative_species_OUTPUT
mmseqs createdb cds-parts.fasta cdsDB -v 2

mmseqs search \
 $relative_species_OUTPUT/cdsDB \
 $OUT_DIR/TARGET/GenomeDB \
 $relative_species_OUTPUT/mmseqs.out \
 $relative_species_OUTPUT/mmseqs_tmp \
 -e 100.0 --threads $THREADS -s 8.5 -a --comp-bias-corr 0 --max-seqs 500 --mask 0 --orf-start-mode 1 -v 2

mmseqs convertalis \
 $relative_species_OUTPUT/cdsDB \
 $OUT_DIR/TARGET/GenomeDB \
 $relative_species_OUTPUT/mmseqs.out \
 $relative_species_OUTPUT/search.txt \
 --threads $THREADS \
 --format-output "query,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,empty,raw,nident,empty,empty,empty,qframe,tframe,qaln,taln,qlen,tlen" \
 -v 2

### Gene Model Mapper ###
GeMoMa -Xmx100G GeMoMa s=$relative_species_OUTPUT/search.txt \
 c=$relative_species_OUTPUT/cds-parts.fasta a=$relative_species_OUTPUT/assignment.tabular \
 t=$DRAFT_GENOME sort=true Score=ReAlign i=$OUT_DIR/denoised_introns.gff \
 coverage=STRANDED coverage_forward=$OUT_DIR/coverage_forward.bedgraph \
 coverage_reverse=$OUT_DIR/coverage_reverse.bedgraph \
 outdir=$relative_species_OUTPUT

### GeMoMa Annotation Filter ###
GeMoMa -Xmx100G GAF g=$relative_species_OUTPUT/predicted_annotation.gff outdir=$OUT_DIR/Teleogryllus_GAF

### Annotation Finalizer ###
GeMoMa AnnotationFinalizer g=$DRAFT_GENOME a=$OUT_DIR/filtered_predictions.gff u=YES \
 i=$OUT_DIR/denoised_introns.gff c=STRANDED coverage_forward=$OUT_DIR/coverage_forward.bedgraph \
 coverage_reverse=$OUT_DIR/coverage_reverse.bedgraph rename=NO outdir=$OUT_DIR
