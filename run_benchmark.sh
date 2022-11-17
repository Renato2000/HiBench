#!/bin/bash

WORKLOADS="micro/wordcount micro/terasort micro/sort websearch/pagerank"

for WORKLOAD in $WORKLOADS; do
	bin/workloads/${WORKLOAD}/prepare/prepare.sh
	bin/workloads/${WORKLOAD}/spark/run.sh
	WORKLOAD_NAME=(${WORKLOAD//\// })
	hdfs dfs -rm -r /HiBench/${WORKLOAD_NAME[1]^}/
done
