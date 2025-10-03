#!/bin/bash

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

# Install Shairport Sync (AirPlay)
echo "Updating system and installing Shairport Sync (AirPlay)..."
sudo apt update && sudo apt upgrade -y
sudo apt install shairport-sync -y

echo "Installing Bluetooth audio packages..."
sudo apt install bluealsa pulseaudio-module-bluetooth -y
sudo apt install bluetooth blueman -y
echo "Bluetooth audio packages installation complete."
