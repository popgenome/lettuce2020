#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## PopLDdecay: https://github.com/BGI-shenzhen/PopLDdecay

### Steps
## calculate linkage disequilibrium (LD) decay by PopLDdecay
PopLDdecay -InVCF ${pop}.maffiltered.snp.vcf.gz -MaxDist 500 -MAF 0 -Het 1 -Miss 1 -OutStat ${pop}
