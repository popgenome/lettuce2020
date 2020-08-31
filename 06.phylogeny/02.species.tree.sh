#!/usr/bin/bash

### software source
## OrthoMCL: https://vcftools.github.io
## TranslatorX: https://www.cog-genomics.org/plink
## GBLOCKS: http://phylogeny.lirmm.fr/phylo_cgi/downloads.cgi
## RAxML : http://www.exelixis-lab.org/software.html
## ASTRAL-III: https://github.com/smirarab/ASTRAL
## Phyparts: https://bitbucket.org/blackrim/phyparts/src/master/
## IQ-tree: http://www.iqtree.org
## MrBayes: https://nbisweden.github.io/MrBayes/download.html

### Steps
## nuclear single-copy genes were defined using OrthoMCL 
perl orthomcl_pipelinev1.pl --step 123 --input cds.list -outdir output --list category.txt --verbose --mode 3 --type plant &

## generate single-copy gene list
ls *.cds | awk -F '.' '{print $1}' > single-copy.gene.list

## generate single gene tree
for gene in `less single-copy.gene.list`; do

	# translates DNA sequences into amino acids by TranslatorX, and amino acid alignment by MAFFT
	perl translatorx_vLocal.pl -i ${gene}.fasta -o ${gene} -p F -t F -w 1 -c 5;

	# alignment filtering by GBLOCKS
	Gblocks ${gene}.nt_ali.fasta -b3=8 -b4=5 -b5=h -b6=y;

	# generate single gene tree by RAxML
	raxmlHPC -f a -x 12345 -# 200 -m GTRGAMMA -s ${gene}.nt_ali.fasta-gb -n ${gene}.tre -p 12345;
done

## generate species tree by ASTRAL-III
cat *.tre > all.single.gene.tree.newick
java -jar astral.5.14.2.jar -i all.single.gene.tree.newick -o astral.newick

## demonstrate the topological concordance and conflict between individual gene trees and the species tree by Phyparts
java -jar phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d all.single.gene.tree.newick -m astral.newick -o nt_out
python phypartspiecharts.py astral.newick nt_out 4513

## generate species tree by IQ-tree
iqtree -s concatenated_nuclear_genes_NT.phy -bb 5000 -nt AUTO

# construct phylogenetic trees by MrBayes
mpirun -np 8 ./mb -i concatenated_nuclear_genes_NT.nex

