#!/bin/bash

WORKERS="cloud39.cluster.lsd.di.uminho.pt cloud63.cluster.lsd.di.uminho.pt cloud69.cluster.lsd.di.uminho.pt"

current_dir=`dirname "$0"`
current_dir=`cd "$current_dir"; pwd`
root_dir=${current_dir}/../../../../../
workload_config=${root_dir}/conf/workloads/micro/wordcount.conf
. "${root_dir}/bin/functions/load_bench_config.sh"
energy_dir=${root_dir}/bin/functions/energy

for WORKER in $WORKERS; do
    scp $WORKER:~/energy.csv ${energy_dir}/energy_$WORKER.csv
done

echo gen_energy_result PID: $$ > /dev/stderr
python3 ${energy_dir}/parse_files.py ${energy_dir}
