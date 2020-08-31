#!/usr/bin/bash

### input parameters
## population name
pop=$1

### software source
## Sweed: https://cme.h-its.org/exelixis/web/software/sweed/

### Steps
## Detect selective sweeps by Sweed
SweeD -name chr1.${pop} -input ${pop}.maffiltered.snp.vcf -grid 2148
SweeD -name chr2.${pop} -input ${pop}.maffiltered.snp.vcf -grid 2172
SweeD -name chr3.${pop} -input ${pop}.maffiltered.snp.vcf -grid 2579
SweeD -name chr4.${pop} -input ${pop}.maffiltered.snp.vcf -grid 3775
SweeD -name chr5.${pop} -input ${pop}.maffiltered.snp.vcf -grid 3396
SweeD -name chr6.${pop} -input ${pop}.maffiltered.snp.vcf -grid 1931
SweeD -name chr7.${pop} -input ${pop}.maffiltered.snp.vcf -grid 1957
SweeD -name chr8.${pop} -input ${pop}.maffiltered.snp.vcf -grid 3097
SweeD -name chr9.${pop} -input ${pop}.maffiltered.snp.vcf -grid 2043
