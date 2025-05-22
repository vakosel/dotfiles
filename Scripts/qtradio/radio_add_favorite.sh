#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_FILE="$SCRIPT_DIR/radio-status"
TMP_STATIONS="$SCRIPT_DIR/radio_stations.tmp"
FAV_FILE="$SCRIPT_DIR/radio_stations.txt"

# Read current station name (remove emoji and trim)
current_station=$(sed -E 's/^🎧[[:space:]]*//' "$STATUS_FILE" | xargs)

# Debug
echo "Current Station: '$current_station'"

# Check if playing
if [[ -z "$current_station" || "$current_station" == "Off Air" ]]; then
  notify-send "Radio" "No station is currently playing."
  exit 1
fi

# Find station line from tmp list
station_line=$(awk -F '=' -v name="$current_station" '$1 == name { print $0 }' "$TMP_STATIONS")

# Debug
echo "Found Line: '$station_line'"

if [[ -z "$station_line" ]]; then
  notify-send "Radio" "Current station not found in temporary stations list."
  exit 1
fi

# Check if already in favorites
if grep -Fxq "$station_line" "$FAV_FILE"; then
  notify-send "Radio" "Station is already in favorites."
  exit 0
fi

# Add to favorites
echo "$station_line" >>"$FAV_FILE"
notify-send "Radio" "Added '$current_station' to favorites."
