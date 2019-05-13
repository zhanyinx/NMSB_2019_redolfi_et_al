##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al


#first script


#file containing the fastq files information: for more info https://bioconductor.org/packages/release/bioc/vignettes/QuasR/inst/doc/QuasR.html
samplefile="samples.txt" 

library(QuasR) 
clObj <- makeCluster(4)

#alignment
proj <- qAlign(samplefile,
               "BSgenome.Mmusculus.UCSC.mm9",
               clObj=clObj,
               auxiliaryFile = "auxiliaryFile.txt")

#quality check
qQCReport(proj,paste("QCReports.pdf",sep = ""),clObj=clObj)
