#!/usr/bin/bash

### input parameters
## fastq file name
fq_file_name=$1
## Read Group
RGID=$2
## library number
library=$3 
## sample ID
sample=$4
## reference genome
reference=$5

### software source
## Trimmomatic: http://www.usadellab.org/cms/?page=trimmomatic
## BWA: http://bio-bwa.sourceforge.net
## GATK: https://gatk.broadinstitute.org/hc/en-us
## SAMtools: http://samtools.sourceforge.net

### Steps
## filter fastq file by trimmomatic
java -jar trimmomatic.jar PE -threads 16 -phred33 ${fq_file_name}_1.fq.gz ${fq_file_name}_2.fq.gz ${fq_file_name}.paired.1.fq.gz ${fq_file_name}.unpaired.1.fq.gz  ${fq_file_name}.paired.2.fq.gz ${fq_file_name}.unpaired.2.fq.gz ILLUMINACLIP:adapter.fa:2:35:4:12:true  LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:5

## map reads by BWA-MEM
bwa mem -t 8 -k 35 -R "@RG\tID:$RGID\tPL:ILLUMINA\tPU:$sample\tLB:$library\tSM:$sample" ${reference} ${fq_file_name}.paired.1.fq.gz ${fq_file_name}.paired.2.fq.gz | samtools view -bS - > ${sample}.bam

## sort BAM file
gatk SortSam --INPUT ${sample}.bam --OUTPUT ${sample}.sorted.bam

## mark PCR duplicates
gatk MarkDuplicates --INPUT ${sample}.sorted.bam --METRICS_FILE ${sample}.markdup_metrics.txt --OUTPUT ${sample}.sorted.markdup.bam

## build BAM index
samtools index ${sample}.sorted.markdup.bam

## generate GCVF by HaplotypeCaller
gatk HaplotypeCaller --reference ${reference} --emit-ref-confidence GVCF --INPUT ${sample}.sorted.markdup.bam --OUTPUT ${sample}.g.vcf.gz
