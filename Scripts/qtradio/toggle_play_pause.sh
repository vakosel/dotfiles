#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IPC_SOCKET="/tmp/mpv-radio-ipc"
STATUS_FILE="$SCRIPT_DIR/radio-status"
LAST_STATION_FILE="$SCRIPT_DIR/radio_stations.tmp"

if pgrep -x mpv >/dev/null && [ -S "$IPC_SOCKET" ]; then
  echo '{ "command": ["cycle", "pause"] }' | socat - "$IPC_SOCKET"

  current_status=$(cat "$STATUS_FILE" 2>/dev/null)
  if [[ "$current_status" == *"🎧"* ]]; then
    sed -i 's/🎧 /⏸️ /g' "$STATUS_FILE"
  elif [[ "$current_status" == *"⏸️"* ]]; then
    sed -i 's/⏸️ /🎧 /g' "$STATUS_FILE"
  else
    echo "⏸️ Radio (Paused)" >"$STATUS_FILE"
  fi
else
  if [ -f "$LAST_STATION_FILE" ]; then
    last_station_line=$(cat "$LAST_STATION_FILE" 2>/dev/null)
    station_name="${last_station_line%=*}"
    station_url="${last_station_line#*=}"

    if [[ -n "$station_url" ]]; then
      rm -f "$IPC_SOCKET" 2>/dev/null
      mpv --no-video --quiet --force-window=no \
        --input-ipc-server="$IPC_SOCKET" \
        --idle=no \
        "$station_url" &
      echo "🎧 $station_name" >"$STATUS_FILE"
    else
      echo "🔴 No Station" >"$STATUS_FILE"
    fi
  else
    echo "🔴 No Station" >"$STATUS_FILE"
  fi
fi
