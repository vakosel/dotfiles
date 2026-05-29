#!/usr/bin/env bash

### AUTOSTART PROGRAMS ###

# Clean helper function that safely forces background execution
run() {
	if ! pgrep -x "$1" >/dev/null; then
		"$@" &
	fi
}

# 1. Core Window Manager Requirements (Fire these first)
run picom -b
run sxhkd &
run dunst &

# 2. Appearance and Themes
run wal -R
run conky -c "$HOME"/.config/conky/pywal_conky/qtconkyrc &

# 3. System Tray Applets & Authentication Agent
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run blueman-applet &
run nm-applet &

# vim: tabstop=4 shiftwidth=4 noexpandtab

### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
#xargs xwallpaper --stretch <~/.cache/wall &
# 2. Uncomment to set a random wallpaper on login
# find /usr/share/backgrounds/dtos-backgrounds/ -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
#cc nitrogen --restore &

# Some process you may want to start with Qtile

# run xfce4-power-manager 			# Power management
# run light-locker					# Screen locker
# run xfce4-clipman					# Clipboard management
# run mpd --no-daemon					# Music player daemon

# vim: tabstop=4 shiftwidth=4 noexpandtab
