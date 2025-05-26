#!/bin/bash

MOUNTPOINT="/mnt/usb"

usage() {
  echo "Usage: $0 [mount|umount]"
  exit 1
}

if [[ $# -ne 1 ]]; then
  usage
fi

list_usb_partitions() {
  # List all USB partitions with size and model for user-friendly selection
  lsblk -dpno NAME,SIZE,MODEL,TRAN | grep usb | awk '{print $1, $2, $3}'
}

select_device() {
  echo "Available USB partitions:"

  # Find USB devices first
  usb_devs=($(lsblk -dpno NAME,TRAN | grep usb | awk '{print $1}'))
  if [ ${#usb_devs[@]} -eq 0 ]; then
    echo "No USB devices detected."
    exit 1
  fi

  # For each USB device, list its partitions
  parts=()
  for dev in "${usb_devs[@]}"; do
    mapfile -t dev_parts < <(lsblk -lnpo NAME,TYPE "$dev" | awk '$2=="part" {print $1}')
    parts+=("${dev_parts[@]}")
  done

  if [ ${#parts[@]} -eq 0 ]; then
    echo "No USB partitions found."
    exit 1
  fi

  PS3="Select the partition to $1: "
  select part in "${parts[@]}"; do
    if [[ -n "$part" ]]; then
      DEVICE="$part"
      echo "Selected: $DEVICE"
      break
    else
      echo "Invalid selection, try again."
    fi
  done
}

case "$1" in
mount)
  select_device mount
  if [[ -z "$DEVICE" ]]; then
    echo "No device selected, exiting."
    exit 1
  fi
  sudo mkdir -p "$MOUNTPOINT"
  sudo mount -t ntfs-3g "$DEVICE" "$MOUNTPOINT" && echo "✅ Mounted $DEVICE at $MOUNTPOINT"
  ;;
umount | unmount)
  sudo umount "$MOUNTPOINT" && echo "✅ Unmounted $MOUNTPOINT"
  ;;
*)
  usage
  ;;
esac
