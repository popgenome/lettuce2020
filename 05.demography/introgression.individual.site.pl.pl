#!/usr/bin/perl -w
=head1 Name
Info
    Version: 20200612
    Author:  liuxinjiang
Usage
perl introgression.individual.site.pl [options]
  --major_allel_file    major allel file
  --vcf_file            vcf file
  --output_name         output name
  --target_sample       target sample name
  --population1_name    population1 name
  --population2_name    population2 name

=head2
Exmaple
#major allel file
  #chromosome	position	population1.genotype	population2.genotype
  chr1	1937	0/0	1/1

=cut

use strict;
use Getopt::Long;

my ($major_allel_file, $vcf_file, $output_name, $target_sample, $population1, $population2, $project, %hash_population1, %hash_population2, $target_sample_pos, $population1_geno, $population2_geno);

GetOptions(
	"major_allel_file:s" =>\$major_allel_file,
	"vcf_file:s" =>\$vcf_file,
	"output_name:s" =>\$output_name,
	"target_sample:s" =>\$target_sample,
	"population1_name:s" =>\$population1,
	"population2_name:s" =>\$population2
);
die `pod2text $0` if(!defined$major_allel_file||!defined$vcf_file||!defined$output_name||!defined$target_sample||!defined$population1||!defined$population2);

## step
# genotype format
my $reference = '0/0';
my $alternative = '1/1';
my $heterozygote = '0/1';
my $missing = './.';
my $other = 'other';

## generate hash of genotype
open MAJOR,"gzip -dc $major_allel_file|";
while(<MAJOR>){
	chomp;
	next if(/^#/);
	my @major_array = split;
	$hash_population1{$major_array[1]} = $major_array[2];
	$hash_population2{$major_array[1]} = $major_array[3];
}
close MAJOR;

open VCF,"gzip -dc $vcf_file|";
open OUT,"|gzip > $output_name";
while(<VCF>){
	chmod;
	next if(/^##/);
	my @sample_array = split;

	# generate sample position
	if(/^#/){
		for (my $sample_pos = 8; $sample_pos <= $#sample_array; $sample_pos++){
			
            # obtain target sample position
			if($sample_array[$sample_pos] eq $target_sample){
					$target_sample_pos = $sample_pos;
			}
		}
	}

	next if(/^#/);

	# obtain genotype of target sample
	my $target_sample_geno = (split/:/,$sample_array[$target_sample_pos])[0];

	# obtain genotype of population1
	$population1_geno = $hash_population1{$sample_array[1]};

	# obtain genotype of population2
	$population2_geno = $hash_population2{$sample_array[1]};

	# exclude missing and heterozygote
	if(($target_sample_geno ne $missing) and ($target_sample_geno ne $heterozygote)){

		# generate genotype of target sample same with population1
		if(($target_sample_geno eq $population1_geno) and ($target_sample_geno ne $population2_geno) and (($population1_geno eq $reference) or ($population1_geno eq $alternative)) and (($population2_geno eq $reference) or ($population2_geno eq $alternative))){
			print OUT "$sample_array[0]\t$sample_array[1]\t$population1\t$target_sample_geno\t$population1_geno\t$population2_geno\n";
		}

		# generate genotype of target sample same with population2
		elsif(($target_sample_geno eq $population2_geno) and ($target_sample_geno ne $population1_geno) and (($population1_geno eq $reference) or ($population1_geno eq $alternative)) and (($population2_geno eq $reference) or ($population2_geno eq $alternative))){
			print OUT "$sample_array[0]\t$sample_array[1]\t$population2\t$target_sample_geno\t$population1_geno\t$population2_geno\n";
		}

		# generate genotype of target sample differ with population1 and population2
		else{
			print OUT "$sample_array[0]\t$sample_array[1]\tother\t$target_sample_geno\t$population1_geno\t$population2_geno\n";
		}
	}
}
close VCF;
close OUT;
######## Sub Routines ##### Good Luck ########
##### No error ### No bug ### No warning #####

