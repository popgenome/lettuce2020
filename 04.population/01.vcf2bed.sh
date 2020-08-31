#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## VCFtools: https://vcftools.github.io
## PLNK: https://www.cog-genomics.org/plink

### Steps
## generate PED format by VCFtools
vcftools --gzvcf ${pop}.maffiltered.snp.vcf.gz --plink --out ${pop}.pedformat

## generate BED format by PLINK
plink --file ${pop}.pedformat --make-bed --chr-set 9 --out ${pop}.bedformat
