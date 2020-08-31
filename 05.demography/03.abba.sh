#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## parseVCF.py: https://github.com/simonhmartin/genomics_general
## ABBABABAwindows.py: https://github.com/simonhmartin/genomics_general

### Steps
## convert the VCF file into genotype file format by parseVCF.py
python parseVCF.py -i ${pop}.maffiltered.snp.vcf.gz --skipIndels --minQual 30 --gtf | bgzip -c > ${pop}.geno.gz
## calculate the D-statistic in sliding windows across the chromosome by ABBABABAwindows.py
python ABBABABAwindows.py  -g ${pop}.geno.gz -f phased -o ${pop}.abba.csv -w 100000 -m 100 -s 100000 -P1 popA -P2 popB -P3 popC -O popD --minData 0.5 --popsFile ${pop}.txt --writeFailedWindows
