#!/bin/bash

LOGFILE="recovery_log.txt"
exec > >(tee -a "$LOGFILE") 2>&1

echo "Starting recovery script..."

# Define the source and destination directories
SOURCE="/media/charcoal/Black Hole/Backup/home/charcoal"
DESTINATION="$HOME"

# Function to perform rsync with all file attributes preserved
sync_directory() {
  local src=$1
  local dest=$2
  echo "Syncing $src to $dest..."
  rsync -aAXv --info=progress2 "$src" "$dest"
}

# Function to show a progress bar
progress() {
  while :; do
    echo -n "."
    sleep 1
  done
}

# Start the progress bar in the background
progress &
PROGRESS_PID=$!

# Sync specified directories
for dir in dark Downloads Pictures Videos Music vmware cross-compile Documents Paradox Recovery Tools ZF; do
  sync_directory "$SOURCE/$dir/" "$DESTINATION/$dir"
done

# Sync special case directories
sync_directory "$SOURCE/seeds/" "$DESTINATION/dark/seeds"
sync_directory "$SOURCE/Certs/" "$DESTINATION/Documents/Certs"

# Restore Google Chrome bookmarks and passwords
echo "Restoring Google Chrome bookmarks and passwords..."
sync_directory "$SOURCE/.config/google-chrome/Default/Bookmarks" "$DESTINATION/.config/google-chrome/Default/Bookmarks"
sync_directory "$SOURCE/.config/google-chrome/Default/Login Data" "$DESTINATION/.config/google-chrome/Default/Login Data"

# Restore Brave Browser bookmarks and passwords
echo "Restoring Brave Browser bookmarks and passwords..."
sync_directory "$SOURCE/.config/BraveSoftware/Brave-Browser/Default/Bookmarks" "$DESTINATION/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Bookmarks"
sync_directory "$SOURCE/.config/BraveSoftware/Brave-Browser/Default/Login Data" "$DESTINATION/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Login Data"

# Restore Firefox bookmarks and passwords (assuming Firefox is installed via Snap)
echo "Restoring Firefox bookmarks and passwords..."
sync_directory "$SOURCE/.mozilla/firefox/y7g13oyf.default-release/places.sqlite" "$DESTINATION/snap/firefox/common/.mozilla/firefox/sc60yqvl.default/places.sqlite"
sync_directory "$SOURCE/.mozilla/firefox/y7g13oyf.default-release/logins.json" "$DESTINATION/snap/firefox/common/.mozilla/firefox/sc60yqvl.default/logins.json"

# Stop the progress bar
kill $PROGRESS_PID

echo "Recovery complete."

