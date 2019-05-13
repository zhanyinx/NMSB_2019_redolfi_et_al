##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al


###CHANGE THESE ACCORDINGLY
bam1 <- "bamfile_read1"
bam2 <- "bamfile_read2"
name1 <- "name1"
name2 <- "name2"


###

library(Rsamtools)

###

##Extracting information from bamfiles
flag_unmapped <-scanBamFlag(isPaired = NA, isProperPair = NA, isUnmappedQuery = TRUE, 
                            hasUnmappedMate = NA, isMinusStrand = NA, isMateMinusStrand = NA,
                            isFirstMateRead = NA, isSecondMateRead = NA, 
                            isSecondaryAlignment = NA, isNotPassingQualityControls = NA,
                            isDuplicate = NA)
bampar_unmapped <- ScanBamParam(flag = flag_unmapped, simpleCigar = FALSE,
                                reverseComplement = FALSE, tag = character(0), tagFilter = list(),
                                what = c("qname"),  mapqFilter=NA_integer_)

flag_mapped <-scanBamFlag(isPaired = NA, isProperPair = NA, isUnmappedQuery = FALSE, 
                          hasUnmappedMate = NA, isMinusStrand = NA, isMateMinusStrand = NA,
                          isFirstMateRead = NA, isSecondMateRead = NA, 
                          isSecondaryAlignment = NA, isNotPassingQualityControls = NA,
                          isDuplicate = NA)
bampar_mapped <- ScanBamParam(flag = flag_mapped, simpleCigar = FALSE,
                              reverseComplement = FALSE, tag = character(0), tagFilter = list(),
                              what = c("qname"),  mapqFilter=NA_integer_)


file1=bam1
baifile1=paste0(file1,".bai")
file1_unmapped <- unlist(scanBam(file1,index=baifile1, param=bampar_unmapped))
file1_mapped <- unlist(scanBam(file1,index=baifile1, param=bampar_mapped))

file2=bam2
baifile2=paste0(file2,".bai")
file2_unmapped <- unlist(scanBam(file2,index=baifile2, param=bampar_unmapped))
file2_mapped <- unlist(scanBam(file2,index=baifile2, param=bampar_mapped))

useful1 = file1_unmapped[which(file1_unmapped %in% file2_mapped)]
useful2 = file2_unmapped[which(file2_unmapped %in% file1_mapped)]


write.table(file=paste0(name1,"_useful.dat"),x=useful1,quote=F,row.names=F,col.names=F)
write.table(file=paste0(name2,"_useful.dat"),x=useful2,quote=F,row.names=F,col.names=F)
