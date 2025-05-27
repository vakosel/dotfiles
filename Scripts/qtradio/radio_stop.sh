#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_FILE="$SCRIPT_DIR/radio-status"
RADIO_SONG_FILE="$SCRIPT_DIR/radio-song.txt" # Define path for the song file
IPC_SOCKET="/tmp/mpv-radio-ipc"

# 1. Kill mpv instance
pkill -x mpv 2>/dev/null

# 2. Kill the metadata monitor script
# This is crucial to ensure it stops trying to read from a non-existent mpv process
pkill -f "radio_metadata_monitor.py" 2>/dev/null

# 3. Clean up the IPC socket file
# This prevents stale sockets if mpv crashes or isn't cleaned up properly
rm -f "$IPC_SOCKET" 2>/dev/null

# 4. Update status files to reflect that radio is off
echo "🎙️ Off Air" >"$STATUS_FILE"
echo "🎙️ Off Air" >"$RADIO_SONG_FILE" # Clear the song info file

exit 0
