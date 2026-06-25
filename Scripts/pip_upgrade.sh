#!/bin/bash

set -e

REQ_FILE="requirements.txt"
IN_FILE="requirements.in"

# 1. Ensure we have a requirements.txt to work with
if [ ! -f "$REQ_FILE" ] && [ ! -f "$IN_FILE" ]; then
  echo "🔍 Neither file found. Freezing current venv packages into $REQ_FILE..."
  uv pip freeze >"$REQ_FILE"
fi

# 2. Generate requirements.in using sed if it doesn't exist yet
if [ ! -f "$IN_FILE" ]; then
  echo "🔄 Generating $IN_FILE from $REQ_FILE..."
  sed -E 's/[<=>].*//' "$REQ_FILE" >"$IN_FILE"
  echo "✅ Created $IN_FILE safely."
else
  echo "📄 Found existing $IN_FILE. Using it as the source of truth."
fi

# 3. Compile the latest versions of everything listed in requirements.in
echo "📦 Compiling latest package versions with uv..."
uv pip compile "$IN_FILE" -o "$REQ_FILE" --upgrade

# 4. Sync the virtual environment
echo "⚡ Syncing virtual environment..."
uv pip sync "$REQ_FILE"

echo "🚀 Success! Your virtual environment and $REQ_FILE are fully updated."
