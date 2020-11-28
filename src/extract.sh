#!/bin/bash
if [ $# -lt 1 ]; then
    echo "./extract_step.sh read "
    exit 1
fi


#INFILE="$1"
#OUTFILE="$2"
#OUTDIR="$3"
type="$1"

TYPES=(write read)
BLOCK_SIZE=(4KB 16KB 64KB)
STEPS=(4 16 32 64)

#for type in "${TYPES[@]}"; do
#  for block_size in "${BLOCK_SIZE[@]}"; do
#      mkdir -p  "data_$type$block_size.step"/
#  done
#done


for block_size in "${BLOCK_SIZE[@]}"; do
  for step in "${STEPS[@]}"; do
    if [ $type = "read" ]; then
       cat  "trace_$type$block_size.step$step.txt" | sed '1d'| sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.step$step.csv"
       sed -i -e "s/d3/d/g" "trace_$type$block_size.step$step.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.step$step.csv"
    fi
    if [ $type = "write" ]; then
       cat  "trace_$type$block_size.step$step.txt" | sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.step$step.csv"
       sed -i -e "s/e3/e/g" "trace_$type$block_size.step$step.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.step$step.csv"
    fi
  done
  mv *.csv "data_$type$block_size.step"/
done
