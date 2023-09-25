#!/bin/bash

WORKERS=" 192.168.112.138"

current_dir=`dirname "$0"`
current_dir=`cd "$current_dir"; pwd`
root_dir=${current_dir}/../../../../../
workload_config=${root_dir}/conf/workloads/micro/wordcount.conf
. "${root_dir}/bin/functions/load_bench_config.sh"
energy_dir=${root_dir}bin/functions/energy

for WORKER in $WORKERS; do
    scp $WORKER:/tmp/powerjoular-service.csv $WORKLOAD_RESULT_FOLDER/energy_$WORKER.csv
done

python3 ${energy_dir}/parse_files.py $WORKLOAD_RESULT_FOLDER

