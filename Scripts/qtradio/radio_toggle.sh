#!/bin/bash

STATUS_FILE="$HOME/Scripts/qtradio/radio-status"
IPC_SOCKET="/tmp/mpvsocket"

if pgrep -x mpv >/dev/null; then
  if [[ -S "$IPC_SOCKET" ]]; then
    echo '{ "command": ["cycle", "pause"] }' | socat - "$IPC_SOCKET"
  else
    echo "🎙️ Off Air" >"$STATUS_FILE"
    pkill mpv
  fi
else
  echo "🎙️ Off Air" >"$STATUS_FILE"
fi
