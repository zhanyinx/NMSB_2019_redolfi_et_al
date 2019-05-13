##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al


#run after 01_alignment.R


#file containing the fastq files information: for more info https://bioconductor.org/packages/release/bioc/vignettes/QuasR/inst/doc/QuasR.html
samplefile="samples.txt"

#number of exp samples
trimmed=0

##########END options



library(Biostrings) # string matching
library(BSgenome.Mmusculus.UCSC.mm9) # mouse genome
library(QuasR)
library(GenomicFeatures)
library(ggplot2)
clObj <- makeCluster(4)



proj <- qAlign(samplefile, 
               "BSgenome.Mmusculus.UCSC.mm9",
               clObj=clObj,
               alignmentsDir="./bam/",
               paired='no')


gr_sites_GATC_reduced=readRDS("GATC76mers_4C.rds")

counts_qcount = qCount(proj = proj,query = gr_sites_GATC_reduced,clObj=clObj,orientation="same")
appo=counts_qcount[,-1]

#normalise and rescale with min of Lambda
appo1=as.data.frame(appo)
appo1$CHR=as.vector(seqnames(gr_sites_GATC_reduced))
appo1$START=as.vector(start(gr_sites_GATC_reduced))
appo1$END=as.vector(end(gr_sites_GATC_reduced))
appo1$STRAND=as.vector(strand(gr_sites_GATC_reduced))
write.table(x=appo1,file="GATC_quantification.txt",quote=F,row.names=F)
            
            

