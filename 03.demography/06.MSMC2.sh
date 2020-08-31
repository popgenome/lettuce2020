#!/usr/bin/bash

### input parameters
## population name
pop=$1
## genome file
genome=$2

### software source
## Beagle：https://faculty.washington.edu/browning/beagle
## SAMtools: http://samtools.sourceforge.net
## BCFtools: https://samtools.github.io/bcftools/
## bamCaller.py: https://github.com/stschiff/msmc-tools
## generate_multihetsep.py: https://github.com/stschiff/msmc-tools
## MSMC2: https://github.com/stschiff/msmc2

### Steps
for chromosome in {1..9}; do
	
	## generate phased VCF by Beagle
	java -jar beagle.16May19.351.jar gt=chr${chromosome}.${pop}.maffiltered.snp.vcf.gz out=chr${chromosome}.${pop}.phased;
	
	## generate consensus sequences for each sample
	for sample in `less ${pop}.txt`; do
		
		## generate mask file by bamCaller.py
		samtools mpileup -q 20 -Q 20 -C 50 -u -r chr${chromosome} -f ${genome} ${sample}.bam | bcftools call -c -V indels | python bamCaller.py 20 chr${chromosome}.${sample}mask.bed.gz | bgzip -c > chr${chromosome}.${sample}.vcf.gz;
		
		## generate VCF file of individual sample
		perl split_individual.pl chr${chromosome}.${pop}.phased.vcf.gz ${sample} chr${chromosome}.${sample}.phased.vcf.gz;
		
	done
	
	## generate the input files for MSMC2
	python generate_multihetsep.py --chr chr${chromosome} --mask ${sample1}.phased.vcf.gz --mask ${sample2}.phased.vcf.gz --mask ${sample3}.phased.vcf.gz --mask ${sample4}.phased.vcf.gz chr${chromosome}.${sample1}.phased.vcf.gz chr${chromosome}.${sample2}.phased.vcf.gz chr${chromosome}.${sample3}.phased.vcf.gz chr${chromosome}.${sample4}.phased.vcf.gz > chr${chromosome}.msmc2.inpu
	
	## generate MSMC2 parameter
	msmc2_list.=" chr${chromosome}.msmc2.input ";
}
done

## estimate effective population size by MSMC2
msmc2 -i 20 -t 10 -o result.msmc2 msmc2_list
