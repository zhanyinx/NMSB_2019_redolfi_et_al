#!/bin/bash

##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al

#run after 02_quantification.R


#file used for combining + and - strand of GATC starting uniquely mapped mers;
#Attention: next seq with 3 dark cycles and GA from adaptor, so we skipped 5 reads
#eg if you have 76-mer reads 5bp away from GATC then 
#on + strand you have GATCN+76mers
#on - strand you have 76+NCTAG



if ! [ $# -eq 1 ]; then

	need input file
	exit
fi 

motif=4
skipped=5
input=$1
output="combined"$1

rm $output

awk '{print $0 > $(NF-3)".dat"}' $input
awk 'BEGIN{getline; printf "%s %s %s", $(NF-3),$(NF-2),$(NF-1); for(i=1;i<(NF-3);i++) printf " %s",$i; printf "\n"}' $input > $output

for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX; do
	
	awk 'BEGIN{nmotif="'"$motif"'"-1.; max = -99; min=9999999; nint=0;skipped="'"$skipped"'"+0.}{

		if($(NF-3)=="'"$chr"'"){
			if($(NF)=="+"){
				if(bool[$(NF-2)-skipped,$(NF-2)+nmotif-skipped]!=-1){
					bool[$(NF-2)-skipped,$(NF-2)+nmotif-skipped]=-1
					start[nint]=$(NF-2)-skipped
					end[nint]=$(NF-2)+nmotif-skipped
					nint++
				}
				for(i=1;i<NF-3;i++){
					count[$(NF-2)-skipped,$(NF-2)+nmotif-skipped,i]+=$i
					n[$(NF-2)-skipped,$(NF-2)+nmotif-skipped,i]++
				}
			}
			if($(NF)=="-"){
				for(i=1;i<NF-3;i++){
					count[$(NF-1)-nmotif+skipped,$(NF-1)+skipped,i]+=$i
                                	n[$(NF-1)-nmotif+skipped,$(NF-1)+skipped,i]++
				}
				if(bool[$(NF-1)-nmotif+skipped,$(NF-1)+skipped]!=-1){
					bool[$(NF-1)-nmotif+skipped,$(NF-1)+skipped]=-1
					start[nint]=$(NF-1)-nmotif+skipped
					end[nint]=$(NF-1)+skipped
					nint++
				}
			}
		}	
		

	}END{
		for(i=0;i<nint;i++) {
			printf "%s %d %d ", "'"$chr"'", start[i],end[i]
			for(j=1;j<NF-3;j++) printf " %.5f ", count[start[i],end[i],j]/n[start[i],end[i],j]
			printf "\n"
		}
	
	}' $chr.dat >> $output

done


rm chr*.dat
mv $output $1
sed -i 's/ /\t/g' $1

