#!/bin/bash

# Auto-create symlinks for Flatpak apps in ~/.local/share/applications/
for app in /var/lib/flatpak/exports/share/applications/*.desktop; do
  ln -sf $app ~/.local/share/applications/
done

# Update the desktop database
update-desktop-database ~/.local/share/applications
