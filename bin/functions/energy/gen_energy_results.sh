#!/bin/bash

WORKERS="cloud39.cluster.lsd.di.uminho.pt cloud63.cluster.lsd.di.uminho.pt cloud69.cluster.lsd.di.uminho.pt"

current_dir=`dirname "$0"`
current_dir=`cd "$current_dir"; pwd`

for WORKER in $WORKERS; do
    scp $WORKER:~/energy.csv ${current_dir}/energy_$WORKER.csv
done

python3 ${current_dir}/parse_files.py ${current_dir}
