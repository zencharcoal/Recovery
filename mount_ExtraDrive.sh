#!/bin/bash

# Unmount the current mount point
sudo umount /mnt/ExtraDrive

# Create a new mount point under /media/charcoal
sudo mkdir -p /media/charcoal/ExtraDrive

# Mount the SSD to the new mount point
sudo mount /dev/sda /media/charcoal/ExtraDrive

# Backup the current /etc/fstab
sudo cp /etc/fstab /etc/fstab.bak

# Update /etc/fstab
sudo sed -i 's|/mnt/pandora|/media/charcoal/ExtraDrive|' /etc/fstab

# Verify the new mount point
sudo mount -a

# Display the new mount status
df -h | grep ExtraDrive

