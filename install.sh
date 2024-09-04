#!/bin/bash
print "WARNING, APT is not suitable for SCRIPTS. This will break wither interactive installation like wireshark! You should take this information at tranlsate to ansible or terraform"
LOGFILE="install_log.txt"
exec > >(tee -a "$LOGFILE") 2>&1

# Function to show a progress meter
progress() {
  while :; do
    echo -n "."
    sleep 1
  done
}

echo "Starting installation script..."

# Attach Ubuntu Advantage
sudo pro attach 

# Start the progress meter in the background
progress &
PROGRESS_PID=$!

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

echo "Installing system tools..."
# Install system tools
sudo apt install -y \
  ubuntu-advantage-tools \
  git \
  curl \
  wget \
  net-tools \
  snapd \
  docker.io \
  docker-compose \
  ssh \
  gnome-tweaks \
  gnome-shell-extensions \
  gnome-screenshot \
  flameshot \
  htop \
  tmux \
  clamav \
  clamav-daemon \
  sysstat \
  glances \
  iftop \ 
  speedtest-cli

# Enable and start ClamAV
sudo systemctl enable clamav-freshclam
sudo systemctl start clamav-freshclam
sudo systemctl enable clamav-daemon
sudo systemctl start clamav-daemon

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Install caffeine-indicator
sudo apt install -y caffeine

echo "Installing programming languages and development tools..."
# Install programming languages and development tools
sudo apt install -y \
  python3 \
  python3-dev \
  python3-pip \
  golang \
  openjdk-11-jdk \
  npm \
  nodejs \
  ruby \
  rustc \
  cargo \
  build-essential \
  cmake \
  clang \
  llvm \
  mingw-w64 \
  virtualenv \
  php \
  elixir \
  julia \
  perl \
  vim-gtk3

# Install additional development tools
sudo snap install code --classic
sudo snap install pycharm-community --classic
sudo snap install sublime-text --classic

# PowerShell installation
sudo snap install powershell --classic
pwsh -Command "Install-Module -Name Az -AllowClobber -Force"

# Azure CLI installation
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Google Cloud SDK installation
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg -y
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
sudo apt-get update && sudo apt-get install google-cloud-sdk -y

# AWS CLI installation
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# Vagrant installation
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant -y

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor -o /usr/share/keyrings/sublimehq-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/sublimehq-archive-keyring.gpg] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install -y sublime-text

# Install XMind
wget https://dl3.xmind.net/XMind-2023-for-Linux-64bit.deb
sudo apt install -y ./XMind-2023-for-Linux-64bit.deb
rm XMind-2023-for-Linux-64bit.deb

# Install FreeMind
sudo snap install freemind

# Install Eclipse
wget https://ftp.osuosl.org/pub/eclipse/oomph/epp/2024-03/R/eclipse-inst-jre-linux64.tar.gz
tar -xzf eclipse-inst-jre-linux64.tar.gz
cd eclipse-installer
./eclipse-inst
cd ..
rm -rf eclipse-inst-jre-linux64.tar.gz eclipse-installer

# Install Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

echo "Installing MongoDB..."
# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

echo "Installing security and penetration testing tools..."
# Install security and penetration testing tools
sudo apt install -y \
  nmap \
  ffuf \
  nikto \
  gobuster \
  radare2 \
  gdb \
  aircrack-ng \
  hydra \
  john \
  sqlmap \
  tcpdump \
  binwalk \
  yara \
  netcat-openbsd

# Snap packages for security tools
sudo snap install rustscan
sudo snap install metasploit-framework

echo "Installing multimedia and miscellaneous tools..."
# Install multimedia and miscellaneous tools
sudo apt install -y \
  vlc \
  gimp \
  audacity \
  obs-studio \
  shotwell \
  inkscape \
  blender \
  krita

# Install latest MuseScore
wget https://github.com/musescore/MuseScore/releases/download/v4.1/MuseScore-4.1-x86_64.AppImage
chmod +x MuseScore-4.1-x86_64.AppImage
sudo mv MuseScore-4.1-x86_64.AppImage /usr/local/bin/musescore

# Snap packages for additional tools
sudo snap install teams-for-linux
sudo snap install postman
sudo snap install spotify
sudo snap install discord
sudo snap install firefox
sudo snap install notepad-plus-plus
sudo snap install canonical-livepatch
sudo snap install thunderbird 

# Install Wine from APT
sudo apt install -y wine


# Install Warpinator
sudo snap install warpinator --edge

# Clean up
sudo apt autoremove -y
sudo apt clean

# Stop the progress meter
kill $PROGRESS_PID

echo "Installation complete. Please run the manual installation script for additional software."

