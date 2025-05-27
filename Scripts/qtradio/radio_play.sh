#!/usr/bin/env bash

# Define constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IPC_SOCKET="/tmp/mpv-radio-ipc"
STATUS_FILE="$SCRIPT_DIR/radio-status"
LAST_STATION_FILE="$SCRIPT_DIR/radio_stations.tmp"
RADIO_SONG_FILE="$SCRIPT_DIR/radio-song.txt" # Define the path for the new file

# Kill any existing mpv instance before starting a new one for a new station
pkill -x mpv 2>/dev/null
rm -f "$IPC_SOCKET" 2>/dev/null # Clean up old socket if it exists

# IMPORTANT: Also kill any old metadata monitor processes
# This ensures a clean start and avoids multiple monitors writing to the same file
pkill -f "radio_metadata_monitor.py" 2>/dev/null

# Clear the radio-song.txt file or set a "Loading..." message
echo "Loading song info..." >"$RADIO_SONG_FILE"

# Get station info from rofi chooser
output=$(python3 "$SCRIPT_DIR/radio_chooser.py")

# Exit if chooser was cancelled or returned empty
if [[ -z "$output" ]]; then
  # If cancelled, clean up the status and song files
  echo "Radio Off" >"$STATUS_FILE"
  echo "Radio Off" >"$RADIO_SONG_FILE"
  exit 0
fi

# --- ADJUSTMENT START ---
# Parse station name and URL based on '|||' delimiter
station_name="${output%|||*}"
station_url="${output#*|||}"
# --- ADJUSTMENT END ---

# Exit if URL is empty (shouldn't happen with valid chooser output)
if [[ -z "$station_url" ]]; then
  echo "Error: Empty URL" >"$STATUS_FILE"
  echo "Error: Empty URL" >"$RADIO_SONG_FILE"
  exit 1
fi

# Clean name (remove emojis or leading/trailing spaces for display)
clean_name=$(echo "$station_name" | xargs) # xargs removes leading/trailing whitespace

# Update widget status file with playing emoji and clean name
echo "🎧 $clean_name" >"$STATUS_FILE"

# Save the last selected station for potential resume on left-click
echo "$clean_name=$station_url" >"$LAST_STATION_FILE"

# Start mpv with IPC socket for control
# Adding `--no-terminal` to ensure mpv doesn't open its own terminal window
mpv --no-video --quiet --force-window=no \
  --input-ipc-server="$IPC_SOCKET" \
  --no-terminal \
  --idle=no \
  "$station_url" &

# IMPORTANT: Launch the Python metadata monitor in the background
# It needs to be launched AFTER mpv starts to ensure the socket exists.
# We're redirecting its stderr to a log file for debugging in case of issues.
# stdout is not redirected so `print` statements go to the terminal where `radio-play.sh` is run.
python3 "$SCRIPT_DIR/radio_metadata_monitor.py" &
disown # Detach the background process from the shell

# The script finishes, but mpv and the monitor keep running in the background.
