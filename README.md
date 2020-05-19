# Fastq files can be downloaded here:
[GSE128017](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE128017){:target="_blank"}


# damC analysis (directory damC)
1) Alignment using QuasR: 01_alignment.R
2) Quanfication of methylated GATC sites: 02_quantification.R
3) Combining GATC on the plus and the minus strand: ./03_combine_strands_76mers.sh GATC_counts.txt
4) Extract the sample you are interested in with the genomic coordinates from point 3
5) Running average using the script: ./04_running_average.sh 21 input output chr

# Model prediction (Directory Model)
<font color="red"> **You need Mathematica to run this** </font>
1) Make all the plots from damC kinetic model: damC_kinetic_model.nb
2) Stiffness model for the bending at short distances: damC_stiffness_model.nb

# Capture analysis (Directory Capture)
1) Trim too long reads based on quality (quality of reads can be check using fastqc): 01_trim_fastq.sh -i input -l 50
2) Map reads of each sample to the ectopic genome treat paired-end as single-end: 02_mapping2cassette.R
3) Combine paired-end information to extract valid reads, i.e. those where only one end map to the ectopic genome: 03_extracting_useful_reads_name.R
4) Extract useful reads (given the name list) from fastqfiles: 04_extract_useful_reads.sh
5) Align reads to genome and quantify using csaw: 05_mapping2genome.R

# 4C analysis (directory 4C)
1) Alignment using QuasR: 01_alignment.R
2) Quanfication of methylated GATC sites: 02_quantification.R
3) Combining GATC on the plus and the minus strand: ./03_combine_strands_76mers_rawdata_4C.sh GATC_quantification.txt
4) Extract the sample you are interested in with the genomic coordinates from point 3
5) Filtering the two closest GATC sites to the intergration sites: ./04_filtering_2maximum.sh 4C_input SUBCLONE3_27kb_integrationsites.dat
6) Running average using the script: ./05_running_average.sh 21 input output chr
