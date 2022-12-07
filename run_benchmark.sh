#!/bin/bash

#WORKLOADS="micro/terasort micro/sort websearch/pagerank"
WORKLOADS="micro/sort"

N_RUNS=5

RESULT_FILE="benchmark_result"

rm $RESULT_FILE
touch $RESULT_FILE
echo "Workload   Energy   Time" >> $RESULT_FILE

for WORKLOAD in $WORKLOADS; do
	WORKLOAD_NAME=$(cut -d '/' -f 2 <<< $WORKLOAD)
	
	bin/workloads/${WORKLOAD}/prepare/prepare.sh
	
	TOTAL_ENERGY=0
	TOTAL_TIME=0

	for i in $(seq 1 $N_RUNS); do
		bin/workloads/${WORKLOAD}/spark/run.sh
	
		ENERGY=$(python3 bin/functions/energy/getTotalEnergy.py report/$WORKLOAD_NAME/spark/)
		TOTAL_ENERGY=$(echo "$TOTAL_ENERGY + $ENERGY" | bc -l)
		
		TIME=$(python3 bin/functions/energy/getTotalTime.py report/hibench.report)
		TOTAL_TIME=$(echo "$TOTAL_TIME + $TIME" | bc -l)
	done

	AVERAGE_ENERGY=$(echo "$TOTAL_ENERGY / $N_RUNS" | bc -l)
	AVERAGE_TIME=$(echo "$TOTAL_TIME / $N_RUNS" | bc -l)

	LC_NUMERIC="en_US.UTF-8" printf "%s   %.4f   %.4f\n" $WORKLOAD_NAME $AVERAGE_ENERGY $AVERAGE_TIME >> $RESULT_FILE

	hdfs dfs -rm -r /HiBench/${WORKLOAD_NAME^}/
done
