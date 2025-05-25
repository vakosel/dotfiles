#!/usr/bin/env bash

# Define constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IPC_SOCKET="/tmp/mpv-radio-ipc"
STATUS_FILE="$SCRIPT_DIR/radio-status"
LAST_STATION_FILE="$SCRIPT_DIR/radio_stations.tmp"

# Kill any existing mpv instance before starting a new one for a new station
pkill -x mpv 2>/dev/null
rm -f "$IPC_SOCKET" 2>/dev/null # Clean up old socket if it exists

# Get station info from rofi chooser
output=$(python3 "$SCRIPT_DIR/radio_chooser.py")

# Exit if chooser was cancelled or returned empty
if [[ -z "$output" ]]; then
  exit 0
fi

# --- ADJUSTMENT START ---
# Parse station name and URL based on '|||' delimiter
# Use parameter expansion to get parts before and after the last '|||'
station_name="${output%|||*}"
station_url="${output#*|||}"
# --- ADJUSTMENT END ---

# Exit if URL is empty (shouldn't happen with valid chooser output)
if [[ -z "$station_url" ]]; then
  exit 1
fi

# Clean name (remove emojis or leading/trailing spaces for display)
# The `name_part` from radio_chooser.py already cleans leading dash and spaces,
# so this line is more for general cleanup if emojis were present
clean_name=$(echo "$station_name" | xargs) # xargs removes leading/trailing whitespace

# Update widget status file with playing emoji and clean name
echo "🎧 $clean_name" >"$STATUS_FILE"

# Save the last selected station for potential resume on left-click
echo "$clean_name=$station_url" >"$LAST_STATION_FILE"

# Start mpv with IPC socket for control
mpv --no-video --quiet --force-window=no \
  --input-ipc-server="$IPC_SOCKET" \
  --idle=no \
  "$station_url" & # Run in background
