#!/bin/bash

# Variables
output_file="performance_data.csv"
sar_interval=1  # Interval in seconds for sar measurements
time_output="time_output.txt"  # Temporary file for time command output
exec_file="executions.txt"  # Input file containing execution commands
num_runs=5  # Number of times to run each command

# Ensure the output CSV exists and has headers if it's newly created
if [ ! -f Results/"$output_file" ]; then
    echo "Date,Time,Run,Framework,Workload,Dataset,CPU Usage (%), CPU IO wait (%), CPU Idle (%), Memory Used (MB), Memory Used (%), Memory Cached (MB), IO Read/Write (tps), Execution Time (s)" > Results/"$output_file"
fi

# Read each execution line from the file
while IFS=, read -r framework workload dataset command; do
    for (( i=1; i<=num_runs; i++ )); do
        echo "Run $i: $framework $workload on dataset $dataset"
        
        # Start sar to collect CPU, memory, and I/O statistics in the background
        sar -u -r -b $sar_interval > sar_output.txt &
        sar_pid=$!

        # Run the command from the file
        

        /usr/bin/time -f "%e" -o $time_output bash -c "eval $command"
	# Read the execution time from the time_output file
        execution_time=$(<"$time_output")
        if [$execution_time <1]; then 
        sleep 1
	fi
        # Wait for the command to complete and then kill the sar process
        kill $sar_pid
        wait $sar_pid 2>/dev/null

        

        # Process sar output to extract average CPU and memory usage
        # Process sar output to extract average CPU and memory usage
	cpu_avg=$(awk 'NR > 2 && NR % 9 == 4 {cpu += $5 + $7; count++} END {print cpu/count}' sar_output.txt)
	cpu_wait_avg=$(awk 'NR > 2 && NR % 9 == 4 {cpu_wait += $8; count++} END {print cpu_wait/count}' sar_output.txt)
	cpu_idle_avg=$(awk 'NR > 2 && NR % 9 == 4 {cpu_idle += $10; count++} END {print cpu_idle/count}' sar_output.txt)
	mem_mb_avg=$(awk 'NR > 2 && NR % 9 == 1 {mem_mb += $10/1024; count++} END {print mem_mb/count}' sar_output.txt)
	mem_avg=$(awk 'NR > 2 && NR % 9 == 1 {mem += $11; count++} END {print mem/count}' sar_output.txt)
	mem_cached_avg=$(awk 'NR > 2 && NR % 9 == 1 {mem_cached += $13/1024; count++} END {print mem_cached/count}' sar_output.txt)
	io_avg=$(awk 'NR > 2 && NR % 9 == 7 {io += $9; count++} END {print io/count}' sar_output.txt)

        # Get date and time for the record
        record_date=$(date "+%Y-%m-%d")
        record_time=$(date "+%H:%M:%S")

        # Append data to CSV
        echo "$record_date,$record_time,$i,$framework,$workload,$dataset,$cpu_avg,$cpu_wait_avg,$cpu_idle_avg,$mem_mb_avg,$mem_avg,$mem_cached_avg,$io_avg,$execution_time" >> Results/"$output_file"

        # Display the contents of the CSV file
        cat Results/"$output_file"
    done
done < "$exec_file"

# Cleanup temporary file
rm "$time_output"

