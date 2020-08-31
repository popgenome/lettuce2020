#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## VCFtools: https://vcftools.github.io

### Steps
## calculate singleton SNPs by VCFtools
vcftools --gzvcf ${pop}.hardfiltered.snp.vcf.gz --singletons --out ${pop}.hardfiltered.snp