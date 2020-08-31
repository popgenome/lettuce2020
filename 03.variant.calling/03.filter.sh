#!/usr/bin/bash

### input parameters
## population vcf
pop=$1
## reference genome
reference=$2

### software source
## GATK: https://gatk.broadinstitute.org/hc/en-us

### Steps
## select SNPs from raw vcf
gatk SelectVariants --select-type-to-include SNP --reference ${reference} --variant ${pop}.vcf.gz --output ${pop}.raw.snp.vcf.gz

## perform hard filtering
gatk VariantFiltration --variant ${pop}.raw.snp.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "snp_filter" --genotype-filter-expression "DP < 2 || DP > 50" --genotype-filter-name "dp_fail" --output ${pop}.flag.snp.vcf.gz

## selecting bi-allelic SNPs that pass the filtering
gatk SelectVariants --exclude-filtered true --restrict-alleles-to BIALLELIC --reference ${reference} --variant ${pop}.flag.snp.vcf.gz --output ${pop}.hardfiltered.snp.vcf.gz

## perform population filtering
vcftools --gzvcf ${pop}.hardfiltered.snp.vcf.gz --max-missing 0.9 --maf 0.05 --recode --recode-INFO-all --stdout | bgzip -c >  ${pop}.maffiltered.snp.vcf.gz


## select indels from raw vcf
gatk SelectVariants --select-type-to-include INDEL --reference ${reference} --variant ${pop}.vcf.gz --output ${pop}.raw.indel.vcf.gz

## perform hard filtering
gatk VariantFiltration --variant ${pop}.raw.indel.vcf.gz --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "indel_filter" --output ${pop}.flag.indel.vcf.gz

## selecting indels that pass the filtering
gatk SelectVariants --exclude-filtered true --reference ${reference} --variant ${pop}.flag.indel.vcf.gz --output ${pop}.hardfiltered.indel.vcf.gz
