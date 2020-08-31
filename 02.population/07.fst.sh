#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## VCFtools: https://vcftools.github.io

### Steps
## calculate genetic differentiation (Fst) by VCFtools
vcftools --gzvcf ${pop}.maffiltered.snp.vcf.gz --weir-fst-pop population1.txt --weir-fst-pop population2.txt --fst-window-size 100000 --fst-window-step 100000 --out ${pop}.100kbwindow_100kbstep