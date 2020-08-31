#!/usr/bin/bash

### input parameters
## population 1 name
pop1=$1
## population 2 name
pop2=$2

### software source
## XP-CLR: https://reich.hms.harvard.edu/software


### Steps
## Detect selective sweeps by XP-CLR
XPCLR -xpclr chr1.${pop1}.geno chr1.${pop2}.geno chr1.maf.snp chr1.xpclr -w1 0.005 100 2000 1 -p0 0.7
XPCLR -xpclr chr2.${pop1}.geno chr2.${pop2}.geno chr2.maf.snp chr2.xpclr -w1 0.005 100 2000 2 -p0 0.7
XPCLR -xpclr chr3.${pop1}.geno chr3.${pop2}.geno chr3.maf.snp chr3.xpclr -w1 0.005 100 2000 3 -p0 0.7
XPCLR -xpclr chr4.${pop1}.geno chr4.${pop2}.geno chr4.maf.snp chr4.xpclr -w1 0.005 100 2000 4 -p0 0.7
XPCLR -xpclr chr5.${pop1}.geno chr5.${pop2}.geno chr5.maf.snp chr5.xpclr -w1 0.005 100 2000 5 -p0 0.7
XPCLR -xpclr chr6.${pop1}.geno chr6.${pop2}.geno chr6.maf.snp chr6.xpclr -w1 0.005 100 2000 6 -p0 0.7
XPCLR -xpclr chr7.${pop1}.geno chr7.${pop2}.geno chr7.maf.snp chr7.xpclr -w1 0.005 100 2000 7 -p0 0.7
XPCLR -xpclr chr8.${pop1}.geno chr8.${pop2}.geno chr8.maf.snp chr8.xpclr -w1 0.005 100 2000 8 -p0 0.7
XPCLR -xpclr chr9.${pop1}.geno chr9.${pop2}.geno chr9.maf.snp chr9.xpclr -w1 0.005 100 2000 9 -p0 0.7
