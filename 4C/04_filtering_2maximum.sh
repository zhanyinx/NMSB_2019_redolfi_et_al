#!/bin/bash

##Author: Yinxiu Zhan
##Date: 2019.05.13
##NSMB Redolfi et al

#run after 03_combine_strands_76mers_rawdata_4C.sh


if ! [ $# -eq 2 ]; then

	echo "Usage: Input file 4C single fragment and peakfile needed"
	exit

fi


awk '
	function abs(absolute){
		if(absolute<0) absolute=-absolute
		return absolute
	}
	BEGIN{fn=0; np=0; n=0;nn=0; nint=0}{

	if(FNR==1) fn++
	if(fn==1){
		if($1!="track" && $1!="chr"){			
			chr[np]=$1
			start[np]=$2
			end[np]=$3
			minp[np]=999999999
			minn[np]=999999999
			excluden[np]=-1
			excludep[np]=-1
			np++
		}
	
	}

	if(fn==2){

		for(i=0;i<np;i++){
			if($1==chr[i]){
				if(($2-start[i])<0){
					dist=abs($2-start[i])
					if(dist<minn[i]){
						minn[i]=dist
						excluden[i]=nint
					}
				}
				if(($2-start[i])>0){
			
                                        dist=abs($2-start[i])
                                        if(dist<minp[i]){
                                                minp[i]=dist
                                                excludep[i]=nint
                                        }
                                }	
			}
		
		}
		nint++

	}

	if(fn==3){
		bool=-1
		for(i=0;i<np;i++){
			if(nn==excluden[i] || nn==excludep[i]){
				bool=1
				break
			}
			
		}

		if(bool==-1) print $0 > "filtered2Maximum""'"$1"'"
		else print $0 > "Excluded""'"$1"'"
		nn++
	}

}' $2 $1 $1
