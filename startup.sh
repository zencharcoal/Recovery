#!/bin/bash

# Configuration
SHORT_WAIT=5   # Wait time between starting each application
LONG_WAIT=20   # Reduced time to wait for all applications to initialize
LOG_FILE="$HOME/startup.log"

# Function to log messages
log_message() {
  local message=$1
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Function to check for application dependencies
check_dependency() {
  local app=$1
  if ! command -v "$app" &>/dev/null; then
    log_message "Dependency check failed: $app is not installed."
    exit 1
  fi
}

# Function to start an application and log the status
start_app() {
  local app=$1
  log_message "Starting $app..."
  if command -v "$app" &>/dev/null; then
    # Launch application and detach it from terminal
    "$app" &>/dev/null &
    local pid=$!
    sleep "$SHORT_WAIT"  # Short wait to allow the app to initialize
    if ps -p "$pid" > /dev/null; then
      log_message "$app launched successfully."
      return 0
    else
      log_message "Failed to launch: $app"
      return 1
    fi
  else
    log_message "Command not found: $app"
    return 1
  fi
}

# Function to check if an application is running
check_app_running() {
  local app=$1
  local match_name=$2
  if pgrep -f "$match_name" > /dev/null; then
    log_message "$app is running."
    return 0
  else
    log_message "Failed to start: $app"
    return 1
  fi
}

# Clear the log file at the start
> "$LOG_FILE"

# Check dependencies
check_dependency "nordvpn"
declare -a apps=("vmware" "kate" "teams-for-linux" "thunderbird" "firefox" "google-chrome-stable" "discord" "xmind" "signal-desktop" "spotify")
declare -a match_names=("vmware" "kate" "teams-for-linux" "thunderbird" "firefox" "google-chrome-stable" "discord" "xmind" "signal-desktop" "spotify")

for app in "${apps[@]}"; do
  check_dependency "$app"
done

# Connect to VPN
if nordvpn connect; then
  log_message "VPN connected successfully"
else
  log_message "Failed to connect to VPN"
  exit 1
fi

# Start applications in the background
all_started=true
for app in "${apps[@]}"; do
  if ! start_app "$app"; then
    all_started=false
  fi
done

# Wait for all applications to start
log_message "Waiting for applications to initialize..."
sleep "$LONG_WAIT"

# Check if all applications are running
all_running=true
for i in "${!apps[@]}"; do
  app="${apps[$i]}"
  match_name="${match_names[$i]}"
  if ! check_app_running "$app" "$match_name"; then
    all_running=false
  fi
done

# Open GNOME Control Center if all applications started successfully
if $all_running; then
  gnome-control-center &
  log_message "Startup Successful"
else
  log_message "Startup Failed"
fi

