#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (e.g., using sudo)."
  exit 1
fi

# Always enable Wi-Fi with fixed credentials
BOOT_MOUNT="/boot"

if [ ! -d "$BOOT_MOUNT" ]; then
	echo "Boot partition not found at $BOOT_MOUNT. Please check your mount point."
	exit 1
fi

WPA_CONF="$BOOT_MOUNT/wpa_supplicant.conf"
cat <<EOF > "$WPA_CONF"
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
network={
	ssid=\"CarPiAudio\"
	psk=\"carpi1234\"
	key_mgmt=WPA-PSK
}
EOF
echo "Wi-Fi configuration written to $WPA_CONF with SSID 'CarPiAudio'."

# Install Shairport Sync (AirPlay) and Bluetooth audio packages
echo "Updating system and installing audio packages..."
apt update && apt upgrade -y
apt install -y bluealsa bluetooth blueman pulseaudio-module-bluetooth shairport-sync

echo "Audio packages installation complete."
