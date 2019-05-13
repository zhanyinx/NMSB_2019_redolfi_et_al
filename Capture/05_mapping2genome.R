##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al


#run after 04_extract_useful_reads.sh

#global options
#file containing the fastq files information of the valid reads: for more info https://bioconductor.org/packages/release/bioc/vignettes/QuasR/inst/doc/QuasR.html
samplefile = "samples.txt"
genomefile = "BSgenome.Mmusculus.UCSC.mm9"


sizepeak = 100 # size of integration site peak in capture
###end global options

library(QuasR)
library(Rsamtools)
library(csaw)
clObj <- makeCluster(4)

proj <- qAlign(samplefile,
                   genomefile,
                   clObj=clObj,
                   alignmentsDir="./")

qQCReport(proj,"QCReport.pdf",clObj=clObj)

bamfiles = (alignments(proj)$genome)$FileName
samples = (alignments(proj)$genome)$SampleName
parm=readParam(dedup=T,minq=28)

for(i in 1:length(bamfiles)){
  counts_csaw=windowCounts(bam.files = bamfiles[i],width = 25,bin=T,param = parm,ext=45)
  gr=rowRanges(counts_csaw)
  data=assay(counts_csaw)
  mcols(gr)=data
  gr <- sortSeqlevels(gr)
  gr <- sort(gr)
  df=data.frame(gr)[,c(1,2,3,6)]
  write.table(x=df,file = paste0(samples[i],"_mouse.bedGraph"),quote=F,col.names=F,row.names=F,sep="\t")
}


###Strategy 3 (expand no-zero sites and merge then; check density of non-zero sites)
counts_csaw=windowCounts(bam.files = bamfiles[1],width = 25,bin=T,param = parm,ext=45)
gr=rowRanges(counts_csaw)
data=assay(counts_csaw)
mcols(gr)=data
gr_reduced = gr

#Expand
end(gr_reduced) = end(gr_reduced)+sizepeak/2
start(gr_reduced) = start(gr_reduced)-sizepeak/2
gr_reduced=trim(gr_reduced)

#merge and filter on merged
gr_reduced = reduce(gr_reduced)
gr_reduced = gr_reduced[width(gr_reduced)>sizepeak]
plot(density(as.vector(width(gr_reduced))),ylim=c(0,0.0001),xlim=c(100,(500)))

abline(v=400,col=2)
gr_reduced = gr_reduced[width(gr_reduced)>400]

##check density of non-zero sites
overlap= findOverlaps(subject = gr, query = gr_reduced)
npeaks = table(queryHits(overlap))
sizespeaks = width(gr_reduced)
h=hist(npeaks,breaks = 300)
plot(log2(h$mids),log2(h$counts),xlab="# of no-zero (log2)",ylab="frequency")
abline(v=3.6,col=2)
gr_final = gr_reduced[as.vector(npeaks>2^(3.6))]

df = data.frame(gr_final)[,c(1,2,3)]
write.table(x=df,file="integration_sites.dat",quote=F,row.names=F,col.names=F)








