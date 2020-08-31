#!/usr/bin/bash

### input parameters
## population name
pop=$1

### Steps
## generate genotype file of major allele
perl bin/introgression.major.allel.pl --vcf_file ${pop}.maffiltered.snp.vcf.gz --output_name ${pop}.txt.gz --population1_list population1.txt --population2_list population2.txt

for sample in `less population1.txt`; do
	## generate introgression of individual site
	perl bin/introgression.individual.site.pl --vcf_file ${pop}.maffiltered.snp.vcf.gz --major_allel_file ${pop}.txt.gz --output_name ${sample}.${pop}.txt.gz --target_sample ${sample} --population1_name population1 --population2_name population2;

	## generate introgression region
	perl bin/introgression.region.pl --site_file ${sample}.${pop}.txt.gz --window_list window.txt --output_name ${sample}.${pop}.region.txt --population1_name population1 --population2_name population2;

	## perform filtering and combine overlap region
	Rscript bin/introgression.filter.R ${sample}.${pop}.region.txt 20 2 result.{sample}.${pop}.region.txt;
done
