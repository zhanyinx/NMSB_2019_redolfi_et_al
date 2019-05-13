# NMSB 2019 redolfi et al

How to run damC analysis (directory damC)
1) Alignment using QuasR: 01_alignment.R
2) Quanfication of methylated GATC sites: 02_quantification.R
3) Combining GATC on the plus and the minus strand: ./03_combine_strands_76mers.sh GATC_counts.txt
4) Extract the sample you are interested in with the genomic coordinates from point 3
5) Running average using the script: ./04_running_average.sh 21 input output chr
