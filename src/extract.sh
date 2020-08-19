#!/bin/bash
if [ $# -lt 3 ]; then
    echo "./extract.sh  INFILE OUTFILE read "
    exit 1
fi


INFILE="$1"
OUTFILE="$2"
OUTDIR="$3"
INDEX="$4"


if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR
fi

#'N;$!P;$!D;

if [ $INDEX = "read" ]; then
   cat  $INFILE | sed '1d'| sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > $OUTFILE
   sed -i -e "s/d3/d/g" $OUTFILE
   sed -i '1itemps type taille latence' $OUTFILE
   mv $OUTFILE $OUTDIR
fi

if [ $INDEX = "write" ]; then
   cat  $INFILE | sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > $OUTFILE
   sed -i -e "s/e3/e/g" $OUTFILE
   sed -i '1itemps type taille latence' $OUTFILE
   mv $OUTFILE $OUTDIR
fi
