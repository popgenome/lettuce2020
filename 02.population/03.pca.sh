#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## GCTA: https://cnsgenomics.com/software/gcta

### Steps
## generate genetic relationship matrix by GCTA
gcta64 --bfile ${pop}.bedformat --make-grm --autosome-num 9 --out ${pop}

## principal component analysis by GCTA
gcta64 --grm ${pop} --pca 10 --out ${pop}.pca