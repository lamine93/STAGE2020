#!/bin/bash
if [ $# -lt 1 ]; then
    echo "./extract.sh <type>: read or write or rwrite ou rread"
    exit 1
fi


type="$1"

BLOCK_SIZE=(4KB 16KB 64KB)
#if [ ! -d $OUTDIR ]; then
#    mkdir -p $OUTDIR
#fi

#'N;$!P;$!D;
for block_size in "${BLOCK_SIZE[@]}"; do
    if [ $type = "read" ]; then
       cat  "trace_$type$block_size.txt" | sed '1d'| sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.csv"
       sed -i -e "s/d3/d/g" "trace_$type$block_size.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.csv"
    fi
    if [ $type = "rread" ]; then
       cat  "trace_$type$block_size.txt" | sed '1d'| sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.csv"
       sed -i -e "s/d3/d/g" "trace_$type$block_size.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.csv"
    fi
    if [ $type = "write" ]; then
       cat  "trace_$type$block_size.txt" | sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.csv"
       sed -i -e "s/e3/e/g" "trace_$type$block_size.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.csv"
    fi
    if [ $type = "rwrite" ]; then
       cat  "trace_$type$block_size.txt" | sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.csv"
       sed -i -e "s/e3/e/g" "trace_$type$block_size.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.csv"
    fi
    mv *.csv  "data_$type"/
done
