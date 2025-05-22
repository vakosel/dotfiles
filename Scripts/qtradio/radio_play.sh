#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="/tmp/radio_play_debug.log"

echo "---- $(date) ----" >>"$LOG"

pkill -x mpv 2>/dev/null

output=$(python3 "$SCRIPT_DIR/radio_chooser.py")
echo "Chooser Output: $output" >>"$LOG"

if [[ -z "$output" ]]; then
  echo "No output from chooser, exiting." >>"$LOG"
  exit 0
fi

station_name=$(echo "$output" | cut -d '|' -f1)
station_url=$(echo "$output" | cut -d '|' -f4)

echo "Parsed Name: '$station_name'" >>"$LOG"
echo "Parsed URL: '$station_url'" >>"$LOG"

if [[ -z "$station_url" ]]; then
  echo "No URL found, exiting." >>"$LOG"
  exit 1
fi

# Clean name (remove emojis and extra spaces)
clean_name=$(echo "$station_name" | sed -E 's/^🎧 //g' | xargs)

echo "Clean Name: '$clean_name'" >>"$LOG"

# Write status (with emoji) for widget
echo "🎧 $clean_name" >"$SCRIPT_DIR/radio-status"

# Write tmp stations file in exact same clean format
echo "$clean_name=$station_url" >"$SCRIPT_DIR/radio_stations.tmp"

# Print contents for debugging
echo "Contents of radio-status:" >>"$LOG"
cat "$SCRIPT_DIR/radio-status" >>"$LOG"

echo "Contents of radio_stations.tmp:" >>"$LOG"
cat "$SCRIPT_DIR/radio_stations.tmp" >>"$LOG"

mpv --no-video --quiet --force-window=no "$station_url" &>>"$LOG" &

echo "mpv started." >>"$LOG"
exit 0
