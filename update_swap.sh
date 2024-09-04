#!/bin/bash

echo "### Fixing and Configuring Swap File ###"

# Turn off any active swap file
echo "Turning off current swap file..."
sudo swapoff /swapfile

# Rename the swap file if not already done
if [ -f /swap.img ]; then
  echo "Renaming swap file..."
  sudo mv /swap.img /swapfile
fi

# Ensure appropriate permissions
echo "Setting correct permissions..."
sudo chmod 600 /swapfile

# Create a new swap file of the desired size
echo "Please choose the swap file size:"
echo "1. 4GB"
echo "2. 8GB"
read -p "Enter choice [1 or 2]: " choice

case $choice in
  1)
    echo "Creating new swap file of 4GB..."
    sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
    ;;
  2)
    echo "Creating new swap file of 8GB..."
    sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# Set up the swap area
echo "Setting up the swap area..."
sudo mkswap /swapfile

# Turn on the swap file
echo "Turning on the swap file..."
sudo swapon /swapfile

# Update /etc/fstab to reflect the new swap file name
echo "Updating /etc/fstab..."
sudo sed -i 's|/swap.img|/swapfile|' /etc/fstab

# Verify the swap status
echo "Verifying swap status..."
swapon --show
free -h

echo "### Swap File Configuration Completed ###"

