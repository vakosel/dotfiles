#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_FILE="$SCRIPT_DIR/radio-status"
pkill mpv
echo "🎙️ Off Air" >"$STATUS_FILE"
