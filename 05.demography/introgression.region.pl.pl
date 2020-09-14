#!/usr/bin/perl -w
=head1 Name
Info
    Version: 20200612
    Author:  liuxinjiang
Usage
perl introgression.region.pl [options]
  --site_file           introgression of individual site (from introgression.step2)	
  --window_list         window list  
  --output_name	        output name
  --population1_name    population1 name
  --population2_name    population2 name
=cut

use strict;
use Getopt::Long;

my ($site_file, $window_list, $output_name, $population1, $population2, %hash_introgression_site, %hash_snp);

GetOptions(
	"site_file:s" =>\$site_file,
	"window_list:s" =>\$window_list,
	"output_name:s" =>\$output_name,
	"population1_name:s" =>\$population1,
	"population2_name:s" =>\$population2
);
die `pod2text $0` if(!defined$site_file||!defined$window_list||!defined$output_name||!defined$population1||!defined$population2);

## generate hash of introgression of individual site
open SITE,"gzip -dc $site_file|";
while(<SITE>){
	chomp;
	next if(/^#/);
	my @introgression_array = split;

	# generate hash of introgression of individual site
	$hash_introgression_site{$introgression_array[1]} = $introgression_array[2];
	
	# generate hash of SNP of target sample
	$hash_snp{$introgression_array[1]} = $introgression_array[3];
}
close SITE;

open WINDOW,"< $window_list";
open REGION,"> $output_name";

## print header of file
print REGION "#chr\tstart\tend\t$population1.number\t$population2.number\t$population2.$population1.ratio\tsnp.number\n";

while(<WINDOW>){
	chomp;
	next if(/^#/);
	my @window_array = split;
	my $window_start = $window_array[1];
	my $window_end = $window_array[2];
	
	# initialization
	my $population1_number = 0;
	my $population2_number = 0;
	my $snp_number = 0;
	my $population2_population1_ratio = 0;

	foreach my $site_pos($window_start..$window_end){
		$hash_introgression_site{$site_pos} || next;

		# count the number of population1
		if($hash_introgression_site{$site_pos} eq $population1){
			$population1_number++;

		# count the number of population2
		}elsif($hash_introgression_site{$site_pos} eq $population2){
			$population2_number++;
		}

		# count the number of SNPs
		my $alternative = '1/1';
		if($hash_snp{$site_pos} eq $alternative){
			$snp_number++;
		}
	}

	if($population1_number != 0){

		# calculate the ratio of population2 to population1
		$population2_population1_ratio = $population2_number / $population1_number;
		
		# print result
		print REGION "$window_array[0]\t$window_array[1]\t$window_array[2]\t$population1_number\t$population2_number\t$population2_population1_ratio\t$snp_number\n";
	}else{
		print REGION "$window_array[0]\t$window_array[1]\t$window_array[2]\t$population1_number\t$population2_number\tNA\t$snp_number\n";
	}
}

close WINDOW;
close REGION;


######## Sub Routines ##### Good Luck ########
##### No error ### No bug ### No warning #####

