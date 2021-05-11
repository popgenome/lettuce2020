# Author: Liuxinjiang, Liuxinjiang@genomics.cn

library(GenomicRanges)

# inputfile from introgression.region.pl
# initialization
args <- commandArgs(T)
inputfile <- args[1]
snp.cutoff <- args[2]
ratio.cutoff <- args[3]
outputfile <- args[4]

# read in raw introgression file
raw.data <- read.table(inputfile, header = F, as.is = T)
colnames(raw.data) <- c("chr", "start", "end", "population1", "population2", "ratio", "snp.number")
# perform filtering
filter.data <- raw.data[raw.data$snp.number >= snp.cutoff & raw.data$ratio >= ratio.cutoff, ]

filter.data.rmna <- na.omit(filter.data)
# covert into gr object
gr <- with(filter.data.rmna, GRanges(chr, IRanges(start, end)))

# reduce region
gr.reduce <- reduce(gr)

# generate data frame
result <- as.data.frame(gr.reduce)

# print result
write.table(result, file = outputfile, sep = "\t", quote = F, row.names = F, col.names = F)
