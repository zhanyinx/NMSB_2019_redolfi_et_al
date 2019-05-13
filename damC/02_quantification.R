##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al


#run after 01_alignment.R


#file containing the aligned bam file information: for more info https://bioconductor.org/packages/release/bioc/vignettes/QuasR/inst/doc/QuasR.html
samples="sample_bamfiles.txt"

pseudocount=0.2 #this correspond to the number added if the normalised library size is 10M reads



library(Biostrings) # string matching
library(BSgenome.Mmusculus.UCSC.mm9) # mouse genome
library(QuasR)
library(GenomicFeatures)
library(ggplot2)
clObj <- makeCluster(4)



proj <- qAlign(samples, 
               "BSgenome.Mmusculus.UCSC.mm9",
               clObj=clObj,
               paired='no')

##Reading the mappable GATC sites
gr_sites_GATC_reduced=readRDS("GATC76mers.rds")

##quantification of reads
counts_qcount = qCount(proj = proj,query = gr_sites_GATC_reduced,clObj=clObj,orientation="same")
appo1=counts_qcount[,-1]

#library size normalisation and pseudocount adding
appo1=t(t(appo1)/colSums(appo1)*1e7)
appo1 = appo1 + pseudocount

##saving data
appo1=as.data.frame(appo1)
appo1$CHR=as.vector(seqnames(gr_sites_GATC_reduced))
appo1$START=as.vector(start(gr_sites_GATC_reduced))
appo1$END=as.vector(end(gr_sites_GATC_reduced))
appo1$STRAND=as.vector(strand(gr_sites_GATC_reduced))
write.table(x=appo1,file="GATC_counts.txt",quote=F,row.names=F)

