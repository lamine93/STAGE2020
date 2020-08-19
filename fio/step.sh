#!/bin/bash


if [ $# -lt 2 ]; then
    echo "run first"
    echo "fallocate -l 1MB data/file.dat"
    echo "./step.sh file.dat fio_output"
    exit 1
fi

size_=1m
run_time=300s


TYPES=(write read)
BLOCK_SIZE=(4B 16B 64B)
STEPS=(4B 16B 32B 64B)



DEV="$1"
OUTDIR="$2"

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR
fi


gen_job_file()
{

    type=$1
    block_size=$2
    step=$3

    echo "[global]" > "$type.$block_size.$step"
    echo "numjobs=1" >> "$type.$block_size.$step"
    echo "runtime=$run_time">> "$type.$block_size.$step"
    echo "size=$size_">> "$type.$block_size.$step"
    echo "blocksize=$block_size">> "$type.$block_size.$step"
    echo "offset=0">> "$type.$block_size.$step"
    echo "kb_base=1000">> "$type.$block_size.$step"
    echo "ioengine=sync" >> "$type.$block_size.$step"
    echo "sync=1" >> "$type.$block_size.$step"
    echo "invalidate=1" >> "$type.$block_size.$step"
    echo "zero_buffers" >> "$type.$block_size.$step"
    echo "bs_is_seq_rand=1" >> "$type.$block_size.$step"
    echo "log_offset=1" >> "$type.$block_size.$step"
    echo "ioengine=sync" >> "$type.$block_size.$step"
    echo "clocksource=clock_gettime" >> "$type.$block_size.$step"
    echo "log_offset=1" >> "$type.$block_size.$step"
    echo "per_job_logs=0" >> "$type.$block_size.$step"
    echo "disable_clat=1" >> "$type.$block_size.$step"
    echo "disable_slat=1" >> "$type.$block_size.$step"
    echo "filename=$DEV" >> "$type.$block_size.$step"


    echo "[$type.$block_size.$step]">> "$type.$block_size.$step"
    echo "stonewall">> "$type.$block_size.$step"
    echo "rw=$type:$step">> "$type.$block_size.$step"
    echo "write_bw_log=trace_$type$block_size.step$step"  >> "$type.$block_size.$step"
    echo "write_lat_log=trace_$type$block_size.step$step" >> "$type.$block_size.$step"

}

cleanup()
{
    for type in "${TYPES[@]}"; do
      for block_size in "${BLOCK_SIZE[@]}"; do
        for step in "${STEPS[@]}"; do
           rm -f "$type.$block_size.$step"
        done
      done
    done
    rm -f *.tmp
}

cleanuplog()
{
    for type in "${TYPES[@]}"; do
      for block_size in "${BLOCK_SIZE[@]}"; do
        rm -f "trace_$type$block_size.step"/*.log
      done
    done
}


run_fio()
{
    type=$1
    block_size=$2
    step=$3


    if [ $# -lt 3 ]; then
    output="$OUTDIR/fio.$type.$block_size.$step.1.log"
    else
        output="$OUTDIR/fio.$type.$block_size.$step.3.1.log"
    fi
    fio --output="$output" "$type.$block_size.$step"
}

cleanuplog

# run all the jobs
format=*.log
for type in "${TYPES[@]}"; do
  for block_size in "${BLOCK_SIZE[@]}"; do
     for step in "${STEPS[@]}"; do
        echo "run $type in $block_size by $step step"
        gen_job_file $type $block_size $step
        run_fio $type $block_size $step
     done
   for file in *.log
   do
     if [ ! -s $file ]; then
       rm -f "$file"
     fi
   done
   if [ "$type" = "write" ] && [ "$block_size" = "4B" ]; then
       mv *.log "trace_$type$block_size.step"/
   fi
   if [ "$type" = "write" ] && [ "$block_size" = "16B" ]; then
       mv *.log "trace_$type$block_size.step"/
   fi
   if [ "$type" = "write" ] && [ "$block_size" = "64B" ]; then
       mv *.log "trace_$type$block_size.step"/
   fi
   if [ "$type" = "read" ] && [ "$block_size" = "4B" ]; then
       mv *.log "trace_$type$block_size.step"/
   fi
   if [ "$type" = "read" ] && [ "$block_size" = "16B" ]; then
       mv *.log "trace_$type$block_size.step"/
   fi
   if [ "$type" = "read" ] && [ "$block_size" = "64B" ]; then
       mv *.log "trace_$type$block_size.step"/
   fi
  done
done

cleanup
