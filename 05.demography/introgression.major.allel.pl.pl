#!/usr/bin/perl -w
=head1 Name
Info
    Version: 20200612
    Author:  liuxinjiang
Usage
perl introgression.major.allel.pl [options]
  --vcf_file            vcf file
  --output_name         output name
  --population1_list    population1 population list
  --population2_list    population2 population list
=cut
#The perl will calculate major allel frequence of population, and generate major allel file.

use strict;
use Getopt::Long;

my ($vcf_file, $output_name, $population1_list, $population2_list,$project, @chr, @population1_id_array, @population2_id_array, @population1_pos_array, @population2_pos_array, $population1_geno, $population2_geno);

GetOptions(
	"vcf_file:s" =>\$vcf_file,
	"output_name:s" =>\$output_name,
	"population1_list:s" =>\$population1_list,
	"population2_list:s" =>\$population2_list
);
die `pod2text $0` if(!defined$vcf_file||!defined$output_name||!defined$population1_list||!defined$population2_list);

## generate population1 population array
open POP1,"< $population1_list";
while(<POP1>){
	chomp;
	next if(/^#/);
	my @population1_array = split;
	if($population1_array[0] =~ /^(\S+)/){
		push @population1_id_array, $1;
	}
}
close POP1;

## generate population2 population array
open POP2,"< $population2_list";
while(<POP2>){
	chomp;
	next if(/^#/);
	my @population2_array = split;
	if($population2_array[0] =~ /^(\S+)/){
		push @population2_id_array, $1;
	}
}
close POP2;

## step
# genotype format
my $reference = '0/0';
my $alternative = '1/1';
my $heterozygote = '0/1';
my $missing = './.';
my $other = 'other';

open VCF,"gzip -dc $vcf_file|";
open OUT,"|gzip > $output_name";

# generate header
print OUT "#chromosome\tposition\tpopulation1.genotype\tpopulation2.genotype\n";

while(<VCF>){
	chmod;
	next if(/^##/);
	my @sample_array = split;
	
	# generate sample position
	if(/^#/){
		for (my $sample_pos = 8; $sample_pos <= $#sample_array; $sample_pos++){
			
			# generate position array of population1 population sample
			for my $population1_id(@population1_id_array){
				if($sample_array[$sample_pos] eq $population1_id){
					push @population1_pos_array, $sample_pos;
				}
			}

			# generate position array of population2 population sample
			for my $population2_id(@population2_id_array){
				if($sample_array[$sample_pos] eq $population2_id){
					push @population2_pos_array, $sample_pos;
				}
			}

		}
	}

	# initialization 
	my $population1_ref_num = 0;
	my $population1_alt_num = 0;
	my $population1_ref_rate = 0;
	my $population1_alt_rate = 0;
	
	# count the number of allel
	for my $population1_pos(@population1_pos_array){
		next if (/^#/);
		my $population1_sample_geno = (split/:/, $sample_array[$population1_pos])[0];
		if($population1_sample_geno eq $reference){
			$population1_ref_num = $population1_ref_num + 2;
		}elsif($population1_sample_geno eq $alternative){
			$population1_alt_num = $population1_alt_num + 2;
		}elsif($population1_sample_geno eq $heterozygote){
			$population1_ref_num++;
			$population1_alt_num++;
		}
	}
	my $population1_geno_number = $population1_ref_num + $population1_alt_num;

	# calculate allele frequency of population1 population, and obtain genotype of major allele
	if($population1_geno_number != 0){
		$population1_ref_rate = $population1_ref_num / $population1_geno_number;
		$population1_alt_rate = $population1_alt_num / $population1_geno_number;
		if($population1_ref_rate > $population1_alt_rate){
			$population1_geno = $reference;
		}elsif($population1_alt_rate > $population1_ref_rate){
			$population1_geno = $alternative;
		}else{
			$population1_geno = $other;
		}
	}else{
		$population1_geno = $other;
	}

	# initialization
	my $population2_ref_num = 0;
	my $population2_alt_num = 0;
	my $population2_ref_rate = 0;
	my $population2_alt_rate = 0;

	# count the number of allel
	for my $population2_pos(@population2_pos_array){
		next if (/^#/);
		my $population2_sample_geno = (split/:/, $sample_array[$population2_pos])[0];
		if($population2_sample_geno eq $reference){
			$population2_ref_num = $population2_ref_num + 2;
		}elsif($population2_sample_geno eq $alternative){
			$population2_alt_num = $population2_alt_num + 2;
		}elsif($population2_sample_geno eq $heterozygote){
			$population2_ref_num++;
			$population2_alt_num++;
		}
	}
	my $population2_geno_number = $population2_ref_num + $population2_alt_num;
	
	# calculate allele frequency of population2 population, and obtain genotype of major allele
	if($population2_geno_number !=0){
		$population2_ref_rate =  $population2_ref_num / $population2_geno_number;
		$population2_alt_rate =  $population2_alt_num / $population2_geno_number;
		if($population2_ref_rate > $population2_alt_rate){
			$population2_geno = $reference;
		}elsif($population2_alt_rate > $population2_ref_rate){
			$population2_geno = $alternative;
		}else{
			$population2_geno = $other;
		}
	}else{
		$population2_geno = $other;
	}

	next if(/^#/);
	
	# print genotype of major allele
	print OUT "$sample_array[0]\t$sample_array[1]\t$population1_geno\t$population2_geno\n";
}

close VCF;
close OUT;

######## Sub Routines ##### Good Luck ########
##### No error ### No bug ### No warning #####

