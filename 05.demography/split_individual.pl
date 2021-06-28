#!usr/bin/perl
use strict;
use warnings;
use File::Basename;

#this perl script can split the mutiple sample vcf file into single file

my $kg=shift;#1000g III shapeit phased vcf file
my $sample_no=shift;#the sample number
my $out=shift;#output file

if($kg =~ /.gz/){
	open KG,"gzip -dc $kg| ";
}else{
	open KG,"< $kg";
}



open OUT,"|gzip > $out";

my $number;
while (my $line=<KG>){
        chomp($line);
	if($line=~/^##/){#print out the header infomation
		print OUT "$line\n";
		next;
	}
        if($line=~/^#CHROM/){#print out the sample information
                my @temp=split /\t/,$line;
                foreach my $num (0..$#temp){
			if($temp[$num] eq $sample_no){
				$number=$num;
				print OUT "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]\t$temp[5]\t$temp[6]\t$temp[7]\t$temp[8]\t$temp[$number]\n";
               	 	}
        	}
	}
	my @temp=split /\t/,$line;
	if(length($temp[4])==1 and length($temp[3])==1 and $temp[0]!~/#/){#print out snp site, filter the indels DELs and sample row
		print OUT "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]\t$temp[5]\t$temp[6]\t$temp[7]\t$temp[8]\t$temp[$number]\n";
	}
}
close KG;
close OUT;
