#!/bin/bash

echo "### Applying Optimized System Settings ###"

# Update and upgrade system
sudo apt-get update && sudo apt-get upgrade -y

# Set swappiness to 10 (already set, ensure persistence)
sudo sysctl -w vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

# Set cache pressure to 50 (already set, ensure persistence)
sudo sysctl -w vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# Install cpufrequtils if not installed
if ! command -v cpufreq-set &> /dev/null; then
  sudo apt-get install -y cpufrequtils
fi

# Set CPU governor to performance for all cores
for CPU in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  CPU_NUM=$(echo $CPU | grep -o '[0-9]\+')
  sudo cpufreq-set -c $CPU_NUM -g performance
done

# Ensure the CPU governor setting is persistent
echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils

# Update mount options for root to include noatime and discard (TRIM)
UUID=$(blkid -s UUID -o value /dev/mapper/ubuntu--vg-ubuntu--lv)
sudo sed -i "s|UUID=$UUID / ext4 .*|UUID=$UUID / ext4 defaults,noatime,discard 0 1|" /etc/fstab

# Verify the current settings and swap status
echo "Current swappiness: $(cat /proc/sys/vm/swappiness)"
echo "Current cache pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"
echo "Current CPU governor:"
for CPU in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo "$CPU: $(cat $CPU)"
done
echo "Current swap status:"
swapon --show
free -h

echo "### System Configuration Completed ###"
echo "Please review the changes and reboot your system to apply all changes."

