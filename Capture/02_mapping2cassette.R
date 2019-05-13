##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al


#file containing the fastq files information: for more info https://bioconductor.org/packages/release/bioc/vignettes/QuasR/inst/doc/QuasR.html
samples_27kb_teto="samples.txt"
genomefile_27kb_teto = "27kb_TetO.fa"


library(QuasR)
library(Rsamtools)
clObj <- makeCluster(4)

#alignment
proj_27 <- qAlign(samples_27kb_teto,
                   genomefile_27kb_teto,
                   clObj=clObj,
                   maxHits = 1000)
#quality check
qQCReport(proj_27,"QCReport.pdf",clObj=clObj)






