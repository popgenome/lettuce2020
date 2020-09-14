#-----Genome (these are always required)
#genome sequence (fasta file or fasta embeded in GFF3 file)
#genome sequence (fasta file or fasta embeded in GFF3 file)
genome= 
#eukaryotic or prokaryotic. Default is eukaryotic
organism_type=eukaryotic 

#-----Re-annotation Using MAKER Derived GFF3
#MAKER derived GFF3 file
maker_gff= 
#use ESTs in maker_gff: 1 = yes, 0 = no
est_pass=1
#use alternate organism ESTs in maker_gff: 1 = yes, 0 = no
altest_pass=0 
#use protein alignments in maker_gff: 1 = yes, 0 = no
protein_pass=0
#use repeats in maker_gff: 1 = yes, 0 = no 
rm_pass=0 
#use gene models in maker_gff: 1 = yes, 0 = no
model_pass=0
#use ab-initio predictions in maker_gff: 1 = yes, 0 = no 
pred_pass=0 
#passthrough anyything else in maker_gff: 1 = yes, 0 = no
other_pass=0

#-----EST Evidence (for best results provide a file for at least one)
#set of ESTs or assembled mRNA-seq in fasta format
est= 
#EST/cDNA sequence file in fasta format from an alternate organism
altest= 
#aligned ESTs or mRNA-seq from an external GFF3 file
est_gff= 
#aligned ESTs from a closly relate species in GFF3 format
altest_gff= 

#-----Protein Homology Evidence (for best results provide a file for at least one)
#protein sequence file in fasta format (i.e. from mutiple oransisms)
protein= 
#aligned protein homology evidence from an external GFF3 file
protein_gff=  

#-----Repeat Masking (leave values blank to skip repeat masking)
#select a model organism for RepBase masking in RepeatMasker
model_org=all
#provide an organism specific repeat library in fasta format for RepeatMasker 
rmlib= 
#provide a fasta file of transposable element proteins for RepeatRunner
repeat_protein=te_proteins.fasta 
#pre-identified repeat elements from an external GFF3 file
rm_gff= 
#forces MAKER to repeatmask prokaryotes (no reason to change this), 1 = yes, 0 = no
prok_rm=0 
#use soft-masking rather than hard-masking in BLAST (i.e. seg and dust filtering)
softmask=1 

#-----Gene Prediction
#SNAP HMM file
snaphmm= 
#GeneMark HMM file
gmhmm=gmhmm.mod 
#Augustus gene prediction species model
augustus_species=arabidopsis
#FGENESH parameter file 
fgenesh_par_file= 
#ab-initio predictions from an external GFF3 file
pred_gff= 
#annotated gene models from an external GFF3 file (annotation pass-through)
model_gff= 
#infer gene predictions directly from ESTs, 1 = yes, 0 = no
est2genome=0 
#infer predictions from protein homology, 1 = yes, 0 = no
protein2genome=1
#find tRNAs with tRNAscan, 1 = yes, 0 = no 
trna=1 
#rRNA file to have Snoscan find snoRNAs
snoscan_rrna=
#also run ab-initio prediction programs on unmasked sequence, 1 = yes, 0 = no 
unmask=0 

#-----Other Annotation Feature Types (features MAKER doesn't recognize)
#extra features to pass-through to final MAKER generated GFF3 file
other_gff= 

#-----External Application Behavior Options
#amino acid used to replace non-standard amino acids in BLAST databases
alt_peptide=C
#max number of cpus to use in BLAST and RepeatMasker (not for MPI, leave 1 when using MPI) 
cpus=1 

#-----MAKER Behavior Options
#length for dividing up contigs into chunks (increases/decreases memory usage)
max_dna_len=100000
#skip genome contigs below this length 
min_contig=1000 
#flank for extending evidence clusters sent to gene predictors
pred_flank=200
#report AED and QI statistics for all predictions as well as models 
pred_stats=0 
#Maximum Annotation Edit Distance allowed (bound by 0 and 1)
AED_threshold=1
#require at least this many amino acids in predicted proteins 
min_protein=0
#Take extra steps to try and find alternative splicing, 1 = yes, 0 = no 
alt_splice=0 
#extra steps to force start and stop codons, 1 = yes, 0 = no
always_complete=1
#map names and attributes forward from old GFF3 genes, 1 = yes, 0 = no 
map_forward=0
#Concordance threshold to add unsupported gene prediction (bound by 0 and 1) 
keep_preds=0 
#length for the splitting of hits (expected max intron size for evidence alignments)
split_hit=10000
#consider single exon EST evidence when generating annotations, 1 = yes, 0 = no 
single_exon=0 
#min length required for single exon ESTs if 'single_exon is enabled'
single_length=250 
#limits use of ESTs in annotation to avoid fusion genes
correct_est_fusion=0 
#number of times to try a contig if there is a failure for some reason
tries=2 
#remove all data from previous run before retrying, 1 = yes, 0 = no
clean_try=0
#removes theVoid directory with individual analysis files, 1 = yes, 0 = no 
clean_up=0 
#specify a directory other than the system default temporary directory for temporary files
TMP=tmp