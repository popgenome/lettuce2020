#!/usr/bin/bash

### input parameters
## sample name
sample=$1

###software 
## Genemark: http://exon.gatech.edu/GeneMark/gmes_instructions.html
## RepeatMasker: http://www.repeatmasker.org/RMDownload.html
## RepeatProteinMask: https://github.com/rmhubley/RepeatMasker/blob/master/RepeatProteinMask
## TRF: https://tandem.bu.edu/trf/trf.download.html
## RepeatModeler: http://www.repeatmasker.org/RepeatModeler/
## maker: https://www.yandell-lab.org/software/maker.html
## annotation code method cite: Draft genome of the leopard gecko, Eublepharis macularius

### Steps

## run genemark to get required model for maker by gmes_petap.pl
perl gmes_petap.pl --ES --sequence ${sample}.fa

## repeat annotation using database
# repeat annotation by RepeatMasker
RepeatMasker -nolow -no_is -norna -engine ncbi -parallel 1 -lib RepeatMaskerLib.embl.lib ${sample}.fa > ${sample}.log 2> ${sample}.stderr.log

# convert RepeatMasker result to gff format by RepeatMasker.repeat_to_gff.pl
perl bin/RepeatMasker.repeat_to_gff.pl ${sample}.RepeatMasker.out 
mv ${sample}.RepeatMasker.out.gff ${sample}.RepeatMasker.gff

# repeat annotation by RepeatProteinMask
RepeatProteinMask -engine ncbi -noLowSimple -pvalue 0.0001  ${sample}.fa

# convert RepeatProteinMask result to gff format by RepeatProtein.Masker.repeat_to_gff.pl
perl bin/RepeatProtein.Masker.repeat_to_gff.pl ${sample}.RepeatProteinMask.annot
mv ${sample}.RepeatProteinMask.annot.gff ${sample}.RepeatProteinMask.gff

#repeat annotation by TRF
trf ${sample}.fa 2 7 7 80 10 50 2000 -d -h 

#convert TRF result to gff format by TRF.repeat_to_gff.pl
perl bin/TRF.repeat_to_gff.pl ${sample}.TRF.dat
mv ${sample}.TRF.dat.gff ${sample}.TRF.gff

## denovo repeat annotation
# build database by RepeatModeler
BuildDatabase -engine ncbi -name mydb ${sample}.fa > ${sample}.fa.repeatmodeler.log

# repeat annotation by RepeatModeler
RepeatModeler -engine ncbi -database mydb -pa 9 > run.out

# repeat annotation by RepeatMasker use repeatmodeler results as evidence
RepeatMasker -nolow -no_is -norna -engine ncbi  -parallel 1 -lib consensi.fa.classified ${sample}.fa > ${sample}.fa.log 2> ${sample}.stderr.log

# convert RepeatMasker result to gff format by RepeatMasker.repeat_to_gff.pl
perl bin/RepeatMasker.repeat_to_gff.pl ${sample}.RepeatMasker.out
mv ${sample}.RepeatMasker.out.gff ${sample}.denovo.RepeatMasker.gff 


## sequence masker
# merge four software results
cat ${sample}.RepeatMasker.gff ${sample}.RepeatProteinMask.annot.gff ${sample}.TRF.gff ${sample}.denovo.RepeatMasker.gff > ${sample}.four.software.merge.gff

# mask repeat sequence by repeat_maksed_to_n.pl
perl bin/repeat_maksed_to_n.pl  ${sample}.four.software.merge.gff > ${sample}.masked.fa

## annotation by maker
maker bin/maker_opts.ctl bin/maker_bopts.ctl bin/maker_exe.ctl -RM_off --ignore_nfs_tmp

## merge maker results by maker
gff3_merge -d ${sample}.maker.output/${sample}_master_datastore_index.log

## filter annotation maker result
cat ${sample}.maker.gff | grep -P "\smaker\s" > ${sample}.maker.filter.gff

## extract CDS and protein from genome file
perl bin/getGene.pl -type mrna ${sample}.maker.filter.gff ${sample}.fa > ${sample}.maker.annotation.cds
perl bin/cds2aa.pl ${sample}.maker.annotation.cds > ${sample}.maker.annotation.pep