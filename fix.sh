#!/bin/bash

# Function to add a GPG key from a URL and save it to a specific keyring
add_gpg_key() {
    local url=$1
    local keyring=$2

    echo "Adding GPG key from $url to $keyring"
    curl -fsSL $url | gpg --dearmor | sudo tee $keyring > /dev/null
}

# Add Brave Browser GPG key and repository
add_gpg_key "https://brave-browser-apt-release.s3.brave.com/brave-core.asc" "/usr/share/keyrings/brave-browser-archive-keyring.gpg"
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Add HashiCorp GPG key and repository
add_gpg_key "https://apt.releases.hashicorp.com/gpg" "/usr/share/keyrings/hashicorp-archive-keyring.gpg"
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Add Google Cloud SDK GPG key and repository
add_gpg_key "https://packages.cloud.google.com/apt/doc/apt-key.gpg" "/usr/share/keyrings/cloud-google.gpg"
echo "deb [signed-by=/usr/share/keyrings/cloud-google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Update package lists and upgrade
sudo apt update && sudo apt upgrade -y

