#!/bin/bash

CONFIG_FILE="/boot/config.txt"

update_config() {
  local key="$1"
  local value="$2"
  if grep -q "^$key=" "$CONFIG_FILE"; then
    sudo sed -i "s|^$key=.*|$key=$value|" "$CONFIG_FILE"
  else
    echo "$key=$value" | sudo tee -a "$CONFIG_FILE" >/dev/null
  fi
}

enable_i2c() {
  update_config "dtparam=i2c_arm" "on"
  sudo modprobe i2c-dev
}

enable_spi() {
  update_config "dtparam=spi" "on"
  # On Raspberry Pi 5 with Manjaro SPI is built-in, so no modprobe
  echo "SPI enabled via config.txt; skipping modprobe (built into kernel)"
}

enable_uart() {
  update_config "enable_uart" "1"
  sudo sed -i '/^dtoverlay=disable-bt/s/^/#/' "$CONFIG_FILE"
  sudo modprobe serial_core
  sudo modprobe uart_pl011
}

CHOICES=$(whiptail --title "Raspberry Pi Interface Configurator" \
  --checklist "Select interfaces to enable:" 15 60 4 \
  "I2C" "Enable I2C interface" OFF \
  "SPI" "Enable SPI interface" OFF \
  "UART" "Enable UART (Serial) interface" OFF \
  3>&1 1>&2 2>&3)

for CHOICE in $CHOICES; do
  case $CHOICE in
  "\"I2C\"") enable_i2c ;;
  "\"SPI\"") enable_spi ;;
  "\"UART\"") enable_uart ;;
  esac
done

echo -e "\n🎉 Interfaces configured. Reboot to apply changes."
