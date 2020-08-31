#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## VCF2Dis: https://github.com/BGI-shenzhen/VCF2Dis
## fneighbor: http://evolution.genetics.washington.edu/phylip.html
## consense: http://evolution.genetics.washington.edu/phylip.html

### Steps
## generate 100 neighbor-joining (NJ) tree by PHYLIP
for bootstrap in {1..100}; do 
	VCF2Dis -InPut ${pop}.maffiltered.snp.vcf.gz -OutPut ${pop}.${bootstrap}.mat -Rand 0.25;
	fneighbor -datafile ${pop}.${bootstrap}.mat -outfile ${pop}.${bootstrap}.txt -matrixtype s -treetype n -outtreefile ${pop}.${bootstrap}.tre;
done

## merge 100 NJtree file
cat ${pop}.*.tre > ${pop}.raw.bootstrap.tre

## generate consense input parameter
echo -e "${pop}.raw.bootstrap.tre\ny" > consense.par

## generate final NJtree
consense < consense.par && mv outfile ${pop}.bootstrap.out && mv outtree ${pop}.bootstrap.tre