#!/usr/bin/bash

### Input parameters
## sample list
samples_list=$1
## reference genome
reference=$2
## population vcf
pop=$3

### software source
## GATK: https://gatk.broadinstitute.org/hc/en-us


### Steps
## generate --variant parameter
for sample in `ls $samples_list`; do
		sample_gvcfs=${sample_gvcfs}"--variant ${sample}.g.vcf.gz "
done

## joint calling
gatk CombineGVCFs --reference ${reference} ${sample_gvcfs} --output ${pop}.g.vcf.gz

## genotype
gatk GenotypeGVCFs --reference ${reference} --variant ${pop}.g.vcf.gz --output ${pop}.vcf.gz
