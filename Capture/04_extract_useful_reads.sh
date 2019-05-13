#!/bin/bash

function usage {
    echo -e "usage : extract_useful_reads.sh -f FILE -u USEFUL -[-n NAME]  [-h]"
    echo -e "Use option -h|--help for more information"
}

function help {
    echo 
    echo "---------------"
    echo "OPTIONS"
    echo
    echo "   -f|--file FILE : fastq file containing all reads: UNZIPPED"
    echo "   -u|--useful USEFUL : file containing useful reads names"
    echo "   [-n|--name NAME] : output file name, DEFAULT OUTPUT.FASTQ"
    echo "   [-h|--help]: help"
    exit;
}



for arg in "$@"; do
  shift
  case "$arg" in
      "--input") set -- "$@" "-i" ;;
      "--start") set -- "$@" "-s" ;;
      "--end") set -- "$@" "-e" ;;
      "--leave") set -- "$@" "-l" ;;
      "--help")   set -- "$@" "-h" ;;
       *)        set -- "$@" "$arg"
  esac
done

FILE=""
USEFUL=""
NAME="OUTPUT.fastq"

while getopts ":u:f:n:h" OPT
do
    case $OPT in
        f) FILE=$OPTARG;;
	u) USEFUL=$OPTARG;;
	n) NAME=$OPTARG;;
        h) help ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done

echo "fastq: $FILE"
echo "name file: $USEFUL"
echo "output: $NAME"


if [ $# -lt 4 ]
then
    usage
    exit
fi

if ! [ -f $FILE ]; then

	echo "$FILE file does not exists!"
	exit
fi
if ! [ -f $USEFUL ]; then

        echo "$USEFUL file does not exists!"
        exit
fi


zcat $FILE  | grep -A 3 -Ff $USEFUL | sed '/^--/ d' >> $NAME 


