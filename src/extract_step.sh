#!/bin/bash
if [ $# -lt 1 ]; then
    echo "./extract_step.sh read "
    exit 1
fi


#INFILE="$1"
#OUTFILE="$2"
#OUTDIR="$3"
type="$1"

#TYPES=(write read)
BLOCK_SIZE=(4B 16B 64B)
STEPS=(4 16 32 64)


for block_size in "${BLOCK_SIZE[@]}"; do
  for step in "${STEPS[@]}"; do
    if [ $type = "read" ]; then
       #INFILE = "trace_$type$block_size'step'$step.txt"
       cat  "trace_$type$block_size.step$step.txt" | sed '1d'| sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.step$step.csv"
       sed -i -e "s/d3/d/g" "trace_$type$block_size.step$step.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.step$step.csv"
    fi
    if [ $type = "write" ]; then
       #INFILE = "trace_$type$block_size'step'$step.txt"
       cat  "trace_$type$block_size.step$step.txt" | sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > "trace_$type$block_size.step$step.csv"
       sed -i -e "s/e3/e/g" "trace_$type$block_size.step$step.csv"
       sed -i '1itemps type taille latence' "trace_$type$block_size.step$step.csv"
    fi
  done

  mv *.csv "data_$type$block_size.step"/
done

#data_read64B.step
#trace_read64Bstep64.csv

#if [ ! -d $OUTDIR ]; then
#    mkdir -p $OUTDIR
#fi


#if [ $INDEX = "write" ]; then
  # cat  $INFILE | sed '$d' | awk -v FS=" " -v OFS=" " '{print $1, $2, $6, $7}' | tr -d "'<';'>';'(';','" > $OUTFILE
  # sed -i -e "s/e3/e/g" $OUTFILE
  # sed -i '1itemps type taille latence' $OUTFILE
#   mv $OUTFILE $OUTDIR
#fi
