#!/usr/bin/bash

### input parameters
## population name
pop=$1
## population1 name
pop1=$1
## population2 name
pop2=$1

### software source
## SMC++: https://github.com/popgenmethods/smcpp

### Steps
## generate vcf2smc parameter of population1
for pop1_sample in `less ${pop1}.txt`; do
	pop1_list.="${pop1_sample},";
}

## generate vcf2smc parameter of population2
for pop2_sample in `less ${pop2}.txt`; do
	pop2_list.="${pop2_sample},";
}

## converts VCF data to the format used by SMC++
for chromosome in {1..9}; do
	
	# create datasets containing the joint frequency spectrum for population1
	for pop1_id in `less ${pop1}.txt`; do
		smc++ vcf2smc --mask ${pop}.mask.bed.gz -d ${pop1_id} ${pop1_id} ${pop}.maffiltered.snp.vcf.gz chr${chromosome}.${pop1}.${sample}.smc.gz chr${chromosome} ${pop1}: ${pop1_list};
	done

	# create datasets containing the joint frequency spectrum for population2
	for pop2_id in `less ${pop2}.txt`; do
		smc++ vcf2smc --mask ${pop}.mask.bed.gz -d ${pop2_id} ${pop2_id} ${pop}.maffiltered.snp.vcf.gz chr${chromosome}.${pop2}.${sample}.smc.gz chr${chromosome} ${pop2}: ${pop2_list};
	done
	
	# create datasets containing the joint frequency spectrum for both populations
	smc++ vcf2smc ${pop}.maffiltered.snp.vcf.gz chr${chromosome}.pop1.pop2.smc.gz chr${chromosome} ${pop1}: ${pop1_list} ${pop2}: ${pop2_list};
	smc++ vcf2smc ${pop}.maffiltered.snp.vcf.gz chr${chromosome}.pop2.pop1.smc.gz chr${chromosome} ${pop2}: ${pop2_list} ${pop1}: ${pop1_list};
done

## estimate effective population size by SMC++
smc++ estimate --knots 20 -o ${pop1} --spline cubic -v 4e-8 chr*.${pop1}.${sample}.smc.gz
smc++ estimate --knots 20 -o ${pop2} --spline cubic -v 4e-8 chr*.${pop2}.${sample}.smc.gz

## estimate divergence time by SMC++
smc++ split -o ${pop} ${pop1}/model1.json ${pop2}/model1.json chr*.smc.gz

## plot by SMC++
smc++ plot ${pop}.png ${pop}/model1.json -x 1 1000000 --csv
