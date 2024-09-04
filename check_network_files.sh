#!/bin/bash

# List of network interfaces to check
interfaces=("wlp0s20f3" "enp0s31f6" "enx34298f766d06" "docker0" "vmnet1" "vmnet8")

# Function to check a file for each interface
check_file() {
    local interface=$1
    local file=$2

    echo "Checking $file for $interface..."
    
    if [ -f "/sys/class/net/$interface/$file" ]; then
        cat "/sys/class/net/$interface/$file" > /dev/null
        if [ $? -eq 0 ]; then
            echo "Success: $file for $interface"
        else
            echo "Error reading: $file for $interface"
        fi
    else
        echo "File not found: /sys/class/net/$interface/$file"
    fi
}

# Iterate over each interface and check critical files
for interface in "${interfaces[@]}"; do
    echo "=== Checking $interface ==="
    check_file $interface "carrier"
    check_file $interface "speed"
    check_file $interface "operstate"
    check_file $interface "statistics/rx_bytes"
    check_file $interface "statistics/tx_bytes"
    check_file $interface "device/driver/module"
    check_file $interface "device/modalias"
    echo ""
done

