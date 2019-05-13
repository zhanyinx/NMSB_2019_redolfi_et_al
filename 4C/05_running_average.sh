#!/bin/bash


##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al

#run after 04_filtering_2maximum.sh


if ! [ $# -eq 4 ]; then
	echo "Need 4 inputs:
1-number of steps 
2-input file 
3-output file
4-chromosome
"
	exit
fi

rm $3
steps=$1

awk '{if($1=="'"$4"'") print $0}' $2 > appo
sort -k1,1 -k2,2n appo > appo1

awk 'BEGIN{ min=999999;max=-99; steps="'"$steps"'"+0.; conta=0}{


	if($1=="'"$4"'"){
		if(conta==0){
			for(j=4;j<=NF;j++) value[0,j]=$j
			start[0]=$2
			end[0]=$3
			for(i=1;i<steps;i++){
				getline;
				for(j=4;j<=NF;j++){
					value[i,j]=$j;
				}
				start[i]=$2
                        	end[i]=$3
			}
			conta++
		}
		else{
			for(i=0;i<steps-1;i++) {
				for(j=4;j<=NF;j++){
					value[i,j]=value[i+1,j]
				}
				start[i]=start[i+1]
				end[i]=end[i+1]
			}
			for(j=4;j<=NF;j++){
				value[steps-1,j]=$j
			}
			end[steps-1]=$3
			start[steps-1]=$2
		}
		for(j=4;j<=NF;j++)	sum[j]=0;

		for(i=0;i<steps;i++) {
			for(j=4;j<=NF;j++) sum[j]+=value[i,j]
		}

		for(j=4;j<=NF;j++) sum[j]=sum[j]/steps;

		printf "%s %d %d ", $1,start[int(steps/2)],end[int(steps/2)]
		for(j=4;j<=NF;j++) printf "%.7f ", sum[j]
		printf "\n"

		
	}

}' appo1 >> $3

sed -i 's/ /\t/g' $3

rm appo*
