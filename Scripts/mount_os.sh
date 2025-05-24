#!/bin/bash

read -p "Enter the IP address of your remote system: " ip

MOUNTPOINT="$HOME/mnt/raspi"

mkdir -p "$MOUNTPOINT"

echo "Mounting /home/vakosel from $ip to $MOUNTPOINT ..."

sshfs vakosel@"$ip":/home/vakosel "$MOUNTPOINT"

if [ $? -eq 0 ]; then
  echo "Mounted successfully! You can open $MOUNTPOINT with your file manager."
else
  echo "Failed to mount. Check the IP address and your SSH setup."
fi
