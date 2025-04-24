#!/usr/bin/env bash

from colors import COLORSCHEME

### AUTOSTART PROGRAMS ###

# If the process doesn't exists, start one in background
run() {
  if ! pgrep $1; then
    $@ &
  fi
}

# Just as the above, but if the process exists, restart it
run-or-restart() {
  if ! pgrep $1; then
    $@ &
  else
    process-restart $@
  fi
}

run picom -b

### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
#xargs xwallpaper --stretch <~/.cache/wall &
# 2. Uncomment to set a random wallpaper on login
# find /usr/share/backgrounds/dtos-backgrounds/ -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
#cc nitrogen --restore &
run wal -R

run conky -c "$HOME"/.config/conky/pywal_conky/qtconkyrc

# Graphical authentication agent
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# run xset b off # Disable beep

run sxhkd # Simple X HKey daemon
# run tmux new-session -d -s common # Tmux server
run dunst # Notification daemon

#  bluetooth
blueman-applet &

# run volumeicon # Volume icon
run nm-applet # NetworkManager icon
# Load notification service
systemctl stop --user xfce4-notifyd

# Some process you may want to start with Qtile

# run urxvtd -q -o					# URxvt daemon
# run cbatticon						# Battery icon and command
# run xfce4-power-manager 			# Power management
# run light-locker					# Screen locker
# run xfce4-clipman					# Clipboard management
# run mpd --no-daemon					# Music player daemon

# vim: tabstop=4 shiftwidth=4 noexpandtab
