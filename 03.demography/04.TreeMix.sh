#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## PLNK: https://www.cog-genomics.org/plink
## plink2treemix.py: https://bitbucket.org/nygcresearch/treemix/wiki/Home
## TreeMix: https://bitbucket.org/nygcresearch/treemix/wiki/Home
## plotting_funcs.R: https://bitbucket.org/nygcresearch/treemix/wiki/Home

### Steps
## calculate minor allele frequency (MAF) by PLINK
plink --bfile ${pop}.bedformat --chr-set 9 --freq gz --missing --within ${pop}.information.txt --out ${pop}

## generate allele frequency file by plink2treemix.py
python plink2treemix.py ${pop}.frq.strat.gz ${pop}.frq.gz

## estimate the historical relationships by TreeMix
for migration in {1..10}; do 
	for repeat in {1..20}; do 
		treemix -i ${pop}.frq.gz -bootstrap 5000 -global -root Virosa -m ${migration} -o ${pop}.M${migration}.repeat${repeat};
		Rscript plotting_funcs.R ${pop}.M${migration}.repeat${repeat} ${pop}.M${migration}.repeat${repeat}.pdf;
	done
done
