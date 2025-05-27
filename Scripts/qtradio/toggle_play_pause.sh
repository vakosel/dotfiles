#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IPC_SOCKET="/tmp/mpv-radio-ipc"
STATUS_FILE="$SCRIPT_DIR/radio-status"
RADIO_SONG_FILE="$SCRIPT_DIR/radio-song.txt" # Define path for the song file
LAST_STATION_FILE="$SCRIPT_DIR/radio_stations.tmp"

# Check if mpv is running AND the IPC socket exists
if pgrep -x mpv >/dev/null && [ -S "$IPC_SOCKET" ]; then
  # Send the cycle pause command to mpv
  echo '{ "command": ["cycle", "pause"] }' | socat - "$IPC_SOCKET"

  # Get the current status from the status file
  current_status=$(cat "$STATUS_FILE" 2>/dev/null)

  # Determine the new status and update both status files
  if [[ "$current_status" == *"🎧"* ]]; then
    # Currently playing, so we are pausing
    sed -i 's/🎧 /⏸️ /g' "$STATUS_FILE"
    echo "Paused" >"$RADIO_SONG_FILE" # Set song file to Paused
  elif [[ "$current_status" == *"⏸️"* ]]; then
    # Currently paused, so we are resuming
    sed -i 's/⏸️ /🎧 /g' "$STATUS_FILE"
    # When resuming, write a temporary "Resuming..." message
    # The Python monitor will soon overwrite this with actual song info
    echo "Resuming..." >"$RADIO_SONG_FILE"
    # Also, tell the monitor to refresh metadata immediately
    # This sends a get_property command to mpv via the monitor's socket
    # This is a bit advanced, but it helps ensure quick update.
    # Ensure the monitor is running and socket exists before trying to send.
    if pgrep -f "radio_metadata_monitor.py" >/dev/null; then
      # Send a command to the monitor to trigger a metadata refresh
      # This requires the monitor to have an IPC socket or similar mechanism
      # A simpler way is to just rely on the monitor's existing 'pause' property listener.
      # The 'Resuming...' message provides immediate feedback.
      # The monitor will eventually get the actual song.
      : # No direct command to monitor needed here, rely on its internal logic
    fi
  else
    # Fallback if status is neither playing nor paused (shouldn't happen if properly managed)
    echo "⏸️ Radio (Paused)" >"$STATUS_FILE"
    echo "Paused" >"$RADIO_SONG_FILE"
  fi
else
  # mpv is not running or socket is missing, so start it if a last station exists
  if [ -f "$LAST_STATION_FILE" ]; then
    last_station_line=$(cat "$LAST_STATION_FILE" 2>/dev/null)
    station_name="${last_station_line%=*}"
    station_url="${last_station_line#*=}"

    if [[ -n "$station_url" ]]; then
      # Kill any old mpv or monitor processes for a clean start
      pkill -x mpv 2>/dev/null
      pkill -f "radio_metadata_monitor.py" 2>/dev/null
      rm -f "$IPC_SOCKET" 2>/dev/null # Clean up old socket

      # Set initial status and song info
      echo "Loading song info..." >"$RADIO_SONG_FILE" # Set song file to loading
      echo "🎧 $station_name" >"$STATUS_FILE"

      # Start mpv
      mpv --no-video --quiet --force-window=no \
        --input-ipc-server="$IPC_SOCKET" \
        --no-terminal \
        --idle=no \
        "$station_url" &

      # Launch the Python metadata monitor in the background
      python3 "$SCRIPT_DIR/radio_metadata_monitor.py" &
      disown # Detach the background process
    else
      echo "🔴 No Station" >"$STATUS_FILE"
      echo "🔴 No Station" >"$RADIO_SONG_FILE" # Clear song file
    fi
  else
    echo "🔴 No Station" >"$STATUS_FILE"
    echo "🔴 No Station" >"$RADIO_SONG_FILE" # Clear song file
  fi
fi
