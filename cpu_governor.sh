#!/bin/bash

# Function to check current CPU governor
check_governor() {
    echo "Current CPU governors:"
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        echo "$(basename $cpu): $(cat $cpu/cpufreq/scaling_governor)"
    done
}

# Function to set CPU governor
set_governor() {
    local governor=$1
    echo "Setting CPU governor to $governor"
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        echo $governor | sudo tee $cpu/cpufreq/scaling_governor > /dev/null
    done
    echo "CPU governor set to $governor for all CPUs."
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
    *)
        echo "Usage: $0 [--check | --performance | --powersave]"
        echo "  --check      : Check current CPU governors"
        echo "  --performance: Set CPU governor to performance"
        echo "  --powersave  : Set CPU governor to powersave"
        exit 1
        ;;
esac

