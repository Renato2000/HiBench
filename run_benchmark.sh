#!/bin/bash

#WORKLOADS="micro/terasort micro/sort websearch/pagerank"
#WORKLOADS="websearch/pagerank"
WORKLOADS="micro/terasort"
#WORKLOADS="micro/sort"

N_RUNS=4

RESULT_FILE="benchmark_result"
EVENT_LOGS_FOLDER="/tmp/spark-events"

SPACING=14

rm $RESULT_FILE
rm -rf $EVENT_LOGS_FOLDER
touch $RESULT_FILE
mkdir $EVENT_LOGS_FOLDER
printf "%-${SPACING}s %-${SPACING}s %-${SPACING}s %-${SPACING}s\n" "Workload" "Avg_Energy" "Avg_Time" "Avg_CPU(%)" >> $RESULT_FILE

for WORKLOAD in $WORKLOADS; do
	WORKLOAD_NAME=$(cut -d '/' -f 2 <<< $WORKLOAD)
	
	bin/workloads/${WORKLOAD}/prepare/prepare.sh
	
	TOTAL_ENERGY=0
	TOTAL_TIME=0
	TOTAL_CPU=0

	for i in $(seq 1 $N_RUNS); do
		bin/workloads/${WORKLOAD}/spark/run.sh
	
		ENERGY=$(python3 bin/functions/energy/getTotalEnergy.py report/$WORKLOAD_NAME/spark/)
		TOTAL_ENERGY=$(echo "$TOTAL_ENERGY + $ENERGY" | bc -l)
		
		TIME=$(python3 bin/functions/energy/getTotalTime.py report/hibench.report)
		TOTAL_TIME=$(echo "$TOTAL_TIME + $TIME" | bc -l)
	
		CPU=$(python3 bin/functions/energy/getCpuUsage.py report/$WORKLOAD_NAME/spark/monitor.html)
		TOTAL_CPU=$(echo "$TOTAL_CPU + $CPU" | bc -l)
	done

	AVERAGE_ENERGY=$(echo "$TOTAL_ENERGY / $N_RUNS" | bc -l)
	AVERAGE_TIME=$(echo "$TOTAL_TIME / $N_RUNS" | bc -l)
	AVERAGE_CPU=$(echo "$TOTAL_CPU / $N_RUNS" | bc -l)

	LC_NUMERIC="en_US.UTF-8" printf "%-${SPACING}s %-${SPACING}.4f %-${SPACING}.4f %-${SPACING}.4f\n" $WORKLOAD_NAME $AVERAGE_ENERGY $AVERAGE_TIME $AVERAGE_CPU >> $RESULT_FILE

	hdfs dfs -rm -r /HiBench/${WORKLOAD_NAME^}/
done
