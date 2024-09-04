#!/bin/bash

LOGFILE="manual_install_log.txt"
exec > >(tee -a "$LOGFILE") 2>&1

echo "Installing manually downloaded packages..."

# Install manually downloaded .deb packages
for deb in *.deb; do
  if [[ -f "$deb" ]]; then
    echo "Installing $deb..."
    sudo dpkg -i "$deb"
    sudo apt-get install -f -y  # Fix dependencies if needed
  fi
done

# Install .bundle files
if [[ -f "vmware-workstation.bundle" ]]; then
  echo "Installing VMware Workstation..."
  sudo bash vmware-workstation.bundle
fi

# Install Burp Suite Pro
if [[ -f "burpsuitepro.sh" ]]; then
  echo "Installing Burp Suite Pro..."
  sudo bash burpsuitepro.sh
fi

# Install Maltego
if [[ -f "maltego.v4.2.15.deb" ]]; then
  echo "Installing Maltego..."
  sudo dpkg -i maltego.v4.2.15.deb
  sudo apt-get install -f -y  # Fix dependencies if needed
fi

echo "Manual installation complete."

