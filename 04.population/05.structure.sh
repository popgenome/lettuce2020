#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## ADMIXTURE: http://dalexander.github.io/admixture/download.html
## CLUMPP: https://rosenberglab.stanford.edu/clumpp.html

### Steps
## population structure analysis by ADMIXTURE
for K in {1..20}; do 
	for repeat in {1..20}; do 
		admixture --cv ${pop}.prune.bed ${K} -j4 -s ${repeat} | tee log${K}.${repeat}.out;
	done
done

## align structure result by CLUMPP
for K in {1..20}; do
	CLUMPP admixture_k${K}.paramfile;
done