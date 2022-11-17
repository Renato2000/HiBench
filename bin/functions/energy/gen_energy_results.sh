#!/bin/bash

WORKERS="cloud135.cluster.lsd.di.uminho.pt cloud136.cluster.lsd.di.uminho.pt cloud138.cluster.lsd.di.uminho.pt"

current_dir=`dirname "$0"`
current_dir=`cd "$current_dir"; pwd`
root_dir=${current_dir}/../../../../../
workload_config=${root_dir}/conf/workloads/micro/wordcount.conf
. "${root_dir}/bin/functions/load_bench_config.sh"
energy_dir=${root_dir}bin/functions/energy

for WORKER in $WORKERS; do
    scp $WORKER:/tmp/powerjoular-service.csv ${energy_dir}/energy_$WORKER.csv
done

echo "Sleeping for 10s"
sleep 10
python3 ${energy_dir}/parse_files.py ${energy_dir}
