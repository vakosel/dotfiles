#!/bin/bash

# Path to the wpg.rasi file
WPG_RASI="$HOME/.config/rofi/colors/wpg.rasi"
TEMP_FILE="$HOME/.config/rofi/colors/wpg.temp.rasi"

# 1. Remove * {} block before running wpg
echo "Removing * {} block from wpg.rasi..."
if [[ -f "$WPG_RASI" ]]; then
  # Remove everything between * { and } (including the stars, brackets, and contents)
  sed '/^\* {/ , /^\}/d' "$WPG_RASI" >"$TEMP_FILE" && mv "$TEMP_FILE" "$WPG_RASI"
  echo "✔ Removed * {} block from wpg.rasi"
else
  echo "Warning: $WPG_RASI not found, skipping removal"
fi

# 2. Run wpg to regenerate the theme
echo "Running wpg to regenerate theme..."
wpg

# 3. Re-add * {} block after running wpg
echo "Re-adding * {} block to wpg.rasi..."
if [[ -f "$WPG_RASI" ]]; then
  {
    echo "* {"
    sed 's/^/    /' "$WPG_RASI"
    echo "}"
  } >"$TEMP_FILE" && mv "$TEMP_FILE" "$WPG_RASI"
  echo "✔ Re-added * {} block to wpg.rasi"
else
  echo "Error: wpg.rasi not found after running wpg!"
  exit 1
fi
~/Scripts/generate-theme.sh
~/Scripts/qtconkypywalcolors.sh
killall -s SIGUSR1 qtile

echo "✔ Script complete!"
