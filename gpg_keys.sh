#!/bin/bash

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl could not be found, installing..."
    sudo apt update
    sudo apt install -y curl
fi

# Ensure gnupg is installed
if ! command -v gpg &> /dev/null; then
    echo "gpg could not be found, installing..."
    sudo apt update
    sudo apt install -y gnupg
fi

# Remove problematic GPG files if they exist
sudo rm -f /etc/apt/trusted.gpg.d/google-cloud-sdk.gpg
sudo rm -f /etc/apt/trusted.gpg.d/hashicorp.gpg
sudo rm -f /etc/apt/trusted.gpg.d/mongodb.gpg
sudo rm -f /etc/apt/trusted.gpg.d/nordvpn.gpg
sudo rm -f /etc/apt/trusted.gpg.d/sublime-text.gpg

# Download and convert the keys correctly

# Brave Browser
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg > /dev/null

# Google Cloud SDK
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/cloud.google.gpg > /dev/null

# HashiCorp
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# NordVPN
wget -qnc https://repo.nordvpn.com/gpg/nordvpn_public.asc -O - | gpg --dearmor | sudo tee /usr/share/keyrings/nordvpn-archive-keyring.gpg > /dev/null

# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq-archive-keyring.gpg > /dev/null

# MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor | sudo tee /usr/share/keyrings/mongodb-archive-keyring.gpg > /dev/null

# Update the source list entries to reference the correct keyrings
sudo sed -i 's|signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg|signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg|g' /etc/apt/sources.list.d/brave-browser-release.list
sudo sed -i 's|signed-by=/usr/share/keyrings/cloud.google.gpg|signed-by=/usr/share/keyrings/cloud.google.gpg|g' /etc/apt/sources.list.d/google-cloud-sdk.list
sudo sed -i 's|signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg|signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg|g' /etc/apt/sources.list.d/hashicorp.list
sudo sed -i 's|signed-by=/usr/share/keyrings/nordvpn-archive-keyring.gpg|signed-by=/usr/share/keyrings/nordvpn-archive-keyring.gpg|g' /etc/apt/sources.list.d/nordvpn.list
sudo sed -i 's|signed-by=/usr/share/keyrings/sublimehq-archive-keyring.gpg|signed-by=/usr/share/keyrings/sublimehq-archive-keyring.gpg|g' /etc/apt/sources.list.d/sublime-text.list
sudo sed -i 's|signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg|signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg|g' /etc/apt/sources.list.d/mongodb-org-4.4.list

# Update package list and upgrade
sudo apt update
sudo apt upgrade -y

