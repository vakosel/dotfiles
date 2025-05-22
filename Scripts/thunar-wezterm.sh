#!/bin/bash
TARGET="$1"
[ -f "$TARGET" ] && TARGET="$(dirname "$TARGET")"
wezterm start --cwd="$TARGET"
