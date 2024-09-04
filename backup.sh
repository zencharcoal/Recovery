#!/bin/bash

LOGFILE="backup_log.txt"
SOFTWARE_LIST="installed_software.yaml"
BACKUP_DIR="/media/charcoal/Black Hole/Backup/$(date +'%Y-%m-%d')"

# Check for dry run argument
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup a directory
backup_directory() {
  local dir=$1
  local dest=$BACKUP_DIR/$(basename "$dir")
  if [ "$DRY_RUN" = true ]; then
    echo "Dry run: Backing up $dir to $dest..."
    rsync -aAXvn --info=progress2 "$dir" "$dest" >> "$LOGFILE" 2>&1
  else
    echo "Backing up $dir to $dest..."
    rsync -aAXv --info=progress2 "$dir" "$dest" >> "$LOGFILE" 2>&1
  fi
}

# Function to backup a file
backup_file() {
  local file=$1
  local dest=$BACKUP_DIR/$(dirname "$file")
  if [ "$DRY_RUN" = true ]; then
    echo "Dry run: Backing up $file to $dest..."
    mkdir -p "$dest"
    rsync -aAXvn --info=progress2 "$file" "$dest" >> "$LOGFILE" 2>&1
  else
    echo "Backing up $file to $dest..."
    mkdir -p "$dest"
    rsync -aAXv --info=progress2 "$file" "$dest" >> "$LOGFILE" 2>&1
  fi
}

# Start backup of user data
echo "Starting backup..." | tee -a "$LOGFILE"
USER_DIRS=(
  "$HOME/Documents"
  "$HOME/Downloads"
  "$HOME/Pictures"
  "$HOME/Videos"
  "$HOME/Music"
  "$HOME/.config"
  "$HOME/.local"

)

for dir in "${USER_DIRS[@]}"; do
  [ -d "$dir" ] && backup_directory "$dir"
done

# Backup browser data
echo "Backing up browser data..." | tee -a "$LOGFILE"
BROWSER_FILES=(
  "$HOME/.config/google-chrome/Default/Bookmarks"
  "$HOME/.config/google-chrome/Default/Login Data"
  "$HOME/snap/firefox/common/.mozilla/firefox/sc60yqvl.default/places.sqlite"
  "$HOME/snap/firefox/common/.mozilla/firefox/sc60yqvl.default/logins.json"
  "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Bookmarks"
  "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/Default/Login Data"
)

for file in "${BROWSER_FILES[@]}"; do
  [ -f "$file" ] && backup_file "$file"
done

# Create YAML configuration for installed software
echo "Generating software installation configuration..." | tee -a "$LOGFILE"
{
  echo "apt_packages:"
  dpkg-query -f '${binary:Package}\n' -W
  echo -e "\nsnap_packages:"
  snap list | awk 'NR>1 {print "  - "$1}'
  echo -e "\nflatpak_packages:"
  flatpak list --app | awk '{print "  - "$1}'
} > "$BACKUP_DIR/$SOFTWARE_LIST"

echo "Backup complete. Check $LOGFILE for details and $SOFTWARE_LIST for software list."

