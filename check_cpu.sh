#!/bin/bash

# Output file
OUTPUT_FILE="sysbench_results.txt"

# Function to check current CPU governor
check_governor() {
    echo "Current CPU governors:" | tee -a $OUTPUT_FILE
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        echo "$(basename $cpu): $(cat $cpu/cpufreq/scaling_governor)" | tee -a $OUTPUT_FILE
    done
}

# Function to set CPU governor
set_governor() {
    local governor=$1
    echo "Setting CPU governor to $governor" | tee -a $OUTPUT_FILE
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        echo $governor | sudo tee $cpu/cpufreq/scaling_governor > /dev/null
    done
    echo "CPU governor set to $governor for all CPUs." | tee -a $OUTPUT_FILE
}

# Function to run CPU test
run_cpu_test() {
    echo "Running CPU test..." | tee -a $OUTPUT_FILE
    sysbench cpu --cpu-max-prime=20000 run | tee -a $OUTPUT_FILE
    echo "CPU test completed." | tee -a $OUTPUT_FILE
}

# Function to run memory test
run_memory_test() {
    echo "Running memory test..." | tee -a $OUTPUT_FILE
    sysbench memory --memory-block-size=1M --memory-total-size=10G run | tee -a $OUTPUT_FILE
    echo "Memory test completed." | tee -a $OUTPUT_FILE
}

# Function to run disk I/O test
run_disk_io_test() {
    echo "Preparing disk I/O test..." | tee -a $OUTPUT_FILE
    sysbench fileio --file-total-size=5G prepare | tee -a $OUTPUT_FILE
    echo "Running disk I/O test..." | tee -a $OUTPUT_FILE
    sysbench fileio --file-total-size=5G --file-test-mode=rndrw run | tee -a $OUTPUT_FILE
    echo "Cleaning up disk I/O test files..." | tee -a $OUTPUT_FILE
    sysbench fileio --file-total-size=5G cleanup | tee -a $OUTPUT_FILE
    echo "Disk I/O test completed." | tee -a $OUTPUT_FILE
}

# Main script logic based on CLI arguments
case $1 in
    --check)
        check_governor
        ;;
    --performance)
        set_governor "performance"
        ;;
    --powersave)
        set_governor "powersave"
        ;;
    --run-tests)
        run_cpu_test
        run_memory_test
        run_disk_io_test
        ;;
    *)
        echo "Usage: $0 [--check | --performance | --powersave | --run-tests]"
        echo "  --check      : Check current CPU governors"
        echo "  --performance: Set CPU governor to performance"
        echo "  --powersave  : Set CPU governor to powersave"
        echo "  --run-tests  : Run sysbench tests and save results"
        exit 1
        ;;
esac

