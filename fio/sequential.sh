#!/bin/bash


if [ $# -lt 2 ]; then
    echo "run first"
    echo "fallocate -l 1MB data/file.dat"
    echo "./sequential.sh file.dat fio_output"
    exit 1
fi

size_=1m
run_time=300s


TYPES=(write read randwrite randread)
BLOCK_SIZE=(4B 16B 64B)

DEV="$1"
OUTDIR="$2"

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR
fi


gen_job_file()
{

    type=$1
    block_size=$2


    echo "[global]" > $type$block_size
    echo "numjobs=1" >> $type$block_size
    echo "runtime=$run_time">> $type$block_size
    #echo "ramp_time=10s">> $type$block_size
    echo "blocksize=$block_size">> $type$block_size
    echo "size=$size_">> $type$block_size
    echo "kb_base=1000">> $type$block_size
    echo "ioengine=sync" >> $type$block_size
    echo "sync=1" >> $type$block_size
    echo "invalidate=1" >> $type$block_size
    echo "zero_buffers" >> $type$block_size
    echo "bs_is_seq_rand=1" >> $type$block_size
    echo "log_offset=1" >> $type$block_size
    echo "ioengine=sync" >> $type$block_size
    echo "clocksource=clock_gettime" >> $type$block_size
    echo "log_offset=1" >> $type$block_size
    echo "per_job_logs=0" >> $type$block_size
    echo "disable_clat=1" >> $type$block_size
    echo "disable_slat=1" >> $type$block_size
    echo "filename=$DEV" >> $type$block_size


    echo "[$type$block_size]">> $type$block_size
    echo "stonewall">> $type$block_size
    echo "rw=$type">> $type$block_size
    echo "write_bw_log=trace_$type$block_size">> $type$block_size
    echo "write_lat_log=trace_$type$block_size">> $type$block_size

}

cleanup()
{
    for type in "${TYPES[@]}"
    do
      for block_size in "${BLOCK_SIZE[@]}"
      do
        rm -f $type$block_size
      done
    done
    rm -f *.tmp
}
cleanuplog()
{
    for type in "${TYPES[@]}"
    do
      rm -f "$type"/*.log
    done
}


run_fio()
{
    type=$1
    block_size=$2


    if [ $# -lt 3 ]; then
    output="$OUTDIR/fio.$type.$block_size.1.log"
    else
        output="$OUTDIR/fio.$type.$block_size.3.1.log"
    fi
    fio --output="$output" $type$block_size
}

cleanuplog

# run all the jobs
format=*.log
for type in "${TYPES[@]}"
do
  for block_size in "${BLOCK_SIZE[@]}"
  do
    # generate type file for current job
     echo "run $type in $block_size"
     gen_job_file $type $block_size
     run_fio $type $block_size
  done

  for file in *.log
  do
     if [ ! -s $file ]; then
         rm -f "$file"
     fi
  done

  if [ "$type" = "write" ]; then
      mv *.log write/
  fi
  if [ "$type" = "read" ]; then
      mv *.log read/
  fi
  if [ "$type" = "randwrite" ]; then
      mv *.log randwrite/
  fi
  if [ "$type" = "randread" ]; then
      mv *.log randread/
  fi


done

cleanup
