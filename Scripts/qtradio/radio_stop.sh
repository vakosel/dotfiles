#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_FILE="$SCRIPT_DIR/radio-status"
IPC_SOCKET="/tmp/mpv-radio-ipc" # <--- Added IPC socket path

pkill -x mpv 2>/dev/null        # Use -x for exact match, and redirect stderr to /dev/null for quietness
rm -f "$IPC_SOCKET" 2>/dev/null # <--- Added: Remove the IPC socket file

echo "🎙️ Off Air" >"$STATUS_FILE"
