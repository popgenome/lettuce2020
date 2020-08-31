#!/usr/bin/bash

### input parameters
## population name
pop=$1
## phenotype file
phenotype=$2

### software source
## PLNK: https://www.cog-genomics.org/plink
## EMMAX: http://genetics.cs.ucla.edu/emmax/

### Steps
## convert the BED format into tped/tfam format by PLINK
plink --bfile ${pop}.bedformat --recode12 --output-missing-genotype 0 --transpose --chr-set 9 --out ${pop}

## generate Balding-Nichols(BN) kinship matrix by EMMAX
emmax-kin -v -h -d 10 ${pop}

## perform GWAS using Balding-Nichols(BN) kinship matrix by EMMAX
emmax -v -d 10 -t ${pop} -p ${phenotype}.txt -k ${pop}.hBN.kinf -c ${pop}.eigenvec -o ${pop}.gwas
