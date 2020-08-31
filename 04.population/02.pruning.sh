#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## PLNK: https://www.cog-genomics.org/plink

### Steps
## perform prune filter by PLINK
plink --bfile ${pop}.bedformat --indep-pairwise 10'kb' 1 0.5 --out ${pop} --chr-set 9
plink --bfile ${pop}.bedformat --extract ${pop}.prune.in --make-bed --out ${pop}.prune --chr-set 9