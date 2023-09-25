#!/bin/bash

#HOSTS=("192.168.112.6")
HOSTS=("192.168.112.138")
#NUM_CORES_LIST=(1 10 20 30 40 50 60 70 80)
NUM_CORES_LIST=(1 2 3 4 5 6 7 8 9 10 11 12)
#NUM_CORES_LIST=(4)
#FREQ_LIST=(1.2 2.4 3.6) 
FREQ_LIST=(0.8 1.2 2.3 3.4 4.6)
#FREQ_LIST=(2.3)

RESULT_FILE_PATH="tests_results.txt"
rm $RESULT_FILE_PATH
PREFIXES=()
for ((i = 0; i < ${#HOSTS[@]}; i++)); do
    prefix=""
    for ((j = 0; j <= i; j++)); do
        prefix+=" ${HOSTS[j]}"
    done
    PREFIXES+=("$prefix")

    # Define hosts for test
    spark_hosts_path="/usr/local/spark/conf/slaves"
    hadoop_hosts_path="/usr/local/hadoop/etc/hadoop/workers"
    echo -n > $spark_hosts_path 
    echo -n > $hadoop_hosts_path
    for host in $HOSTS; do
        echo $host >> $spark_hosts_path
        echo $host >> $hadoop_hosts_path
    done

    # Change hosts on scripts
    sed -i "s/^WORKERS=.*/WORKERS=\"${PREFIXES[i]}\"/" ~/HiBench/bin/functions/energy/gen_energy_results.sh
    HOSTS_WITH_NEWLINES=$(echo ${PREFIXES[0]} | sed 's/ /\n/g')
    rm bin/functions/energy/hosts.inv
    echo "[workers]" >> bin/functions/energy/hosts.inv
    echo "$HOSTS_WITH_NEWLINES" >> bin/functions/energy/hosts.inv
    echo "" >> bin/functions/energy/hosts.inv
    echo "[main]" >> bin/functions/energy/hosts.inv
    echo "main_node ansible_host=cloud105.cluster.lsd.di.uminho.pt" >> bin/functions/energy/hosts.inv

    # Stop Spark and Hadoop    
    # /usr/local/spark/sbin/stop-all.sh
    # /usr/local/hadoop/sbin/stop-all.sh
    
    # sleep 20

    # Reset Spark and Hadoop
    # ansible-playbook bin/functions/energy/reset_spark.yml -i bin/functions/energy/hosts.inv -e "ansible_become_password=123456" > /dev/null 2>&1
    # ansible-playbook bin/functions/energy/reset_hadoop.yml -i bin/functions/energy/hosts.inv -e "ansible_become_password=123456" > /dev/null 2>&1

    # Start Spark and Hadoop
    # /usr/local/spark/sbin/start-all.sh 
    # /usr/local/hadoop/sbin/start-all.sh

    sleep 20

    for NUM_CORES in "${NUM_CORES_LIST[@]}"; do
        
        # Define number of cores
        spark_conf_path="conf/spark.conf"
        old_value="spark.executor.cores[[:space:]]\+[0-9]\+"
        new_value="spark.executor.cores    $NUM_CORES"
        sed -i "s/$old_value/$new_value/" "$spark_conf_path"

        for FREQ in "${FREQ_LIST[@]}"; do

            # Define frequency
            for HOST in $HOSTS; do
                ssh $HOST "echo '123456' | sudo -S cpupower frequency-set --max ${FREQ}GHz" > /dev/null 2>&1
            done

            # Run the benchmark
            echo "Running benchmark with $NUM_CORES cores and CPU frequency at $FREQ GHz"
            ./run_benchmark.sh
            echo "---------------------------------------------------------" >> $RESULT_FILE_PATH
            echo "Hosts: ${PREFIXES[i]}" >> $RESULT_FILE_PATH
            echo "Cores per executor: $NUM_CORES" >> $RESULT_FILE_PATH
            echo "Frequency: $FREQ" >> $RESULT_FILE_PATH
            echo "" >> $RESULT_FILE_PATH
            cat benchmark_result >> $RESULT_FILE_PATH 
            echo ""
        done

    # Clear Spark work folder
    ansible-playbook bin/functions/energy/clear_spark_work_folder.yml -i bin/functions/energy/hosts.inv -e "ansible_become_password=123456"

    done
done

