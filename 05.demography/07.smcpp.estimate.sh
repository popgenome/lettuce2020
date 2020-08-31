#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## SMC++: https://github.com/popgenmethods/smcpp

### Steps
## generate vcf2smc parameter
for sample_id in `less ${pop}.txt`; do
	pop_list.="${sample_id},";
}

## converts VCF data to the format used by SMC++
for chromosome in {1..9}; do
	for sample in `less ${pop}.txt`; do
		smc++ vcf2smc --mask ${pop}.mask.bed.gz -d ${sample} ${sample} ${pop}.maffiltered.snp.vcf.gz chr${chromosome}.${pop}.${sample}.smc.gz chr${chromosome} ${pop}: ${pop_list};
	done
done

## estimate effective population size by SMC++
smc++ estimate --knots 20 -o ${pop} -v 4e-8 chr*.${pop}.${sample}.smc.gz

## plot by SMC++
smc++ plot ${pop}.png ${pop}/model1.json -x 1 1000000 --csv
