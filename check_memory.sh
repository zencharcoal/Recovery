#!/bin/bash

echo "### Checking Current System Settings ###"

# Update and upgrade system (optional, can be commented out if not needed)
# sudo apt-get update && sudo apt-get upgrade -y

# Check swappiness
echo "Current swappiness: $(cat /proc/sys/vm/swappiness)"

# Check cache pressure
echo "Current cache pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"

# Check I/O scheduler for the root device
ROOT_DEVICE=$(df / | tail -1 | awk '{print $1}')
echo "Root device: $ROOT_DEVICE"
echo "Current I/O scheduler for $ROOT_DEVICE: $(cat /sys/block/$(basename $ROOT_DEVICE)/queue/scheduler)"

# Check file system mount options for root
echo "Current file system mount options for root:"
mount | grep ' on / '

# Check CPU governor for each CPU core
echo "Current CPU governor for each CPU core:"
for CPU in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo "$CPU: $(cat $CPU)"
done

# Check current swap status
echo "Current swap status:"
swapon --show

# Check free memory
echo "Current memory usage:"
free -h

# Check active services
echo "Active services:"
systemctl list-units --type=service --state=running

# Check GPU driver version (assuming NVIDIA, can adjust for other GPUs)
if command -v nvidia-smi &> /dev/null; then
  echo "NVIDIA GPU driver version:"
  nvidia-smi --query-gpu=driver_version --format=csv
else
  echo "NVIDIA GPU driver not found or not installed."
fi

echo "### System Check Completed ###"

