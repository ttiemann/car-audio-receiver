#!/bin/bash

# Car Audio Receiver Setup Script

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
echo "=== Updating system and installing audio packages ==="
if ! apt update && apt upgrade -y; then
  echo "System update/upgrade failed. Please check your network connection and package sources."
  exit 1
fi

apt install -y bluealsa bluetooth blueman pulseaudio-module-bluetooth shairport-sync

echo "Audio packages installation complete."

# Configure Shairport Sync (AirPlay service name)
echo "Configuring Shairport Sync..."
cat <<EOF > /etc/shairport-sync.conf
general = {
    name = "CarPiAudio";
    output_backend = "alsa";
};

alsa = {
    output_device = "hw:0";
};
EOF
echo "Shairport Sync configured with service name 'CarPiAudio'."

# Configure Bluetooth for auto-pairing
echo "=== Configuring Bluetooth for auto-pairing ==="
systemctl enable bluetooth
systemctl start bluetooth
systemctl enable bluealsa
systemctl start bluealsa

# Make the device discoverable and pairable
bluetoothctl << EOF
power on
system-alias CarPiAudio
discoverable on
pairable on
agent on
default-agent
EOF

echo "Bluetooth configured for auto-pairing. Device name set to 'CarPiAudio' and is now discoverable."
echo "To pair your phone, go to Bluetooth settings and look for 'CarPiAudio'."

# Enable HiFiBerry DAC+ Zero
echo "=== Enabling HiFiBerry DAC+ Zero ==="
CONFIG_TXT="$BOOT_MOUNT/config.txt"
if ! grep -q '^dtoverlay=hifiberry-dac' "$CONFIG_TXT"; then
    echo 'dtoverlay=hifiberry-dac' >> "$CONFIG_TXT"
    echo "HiFiBerry DAC+ Zero overlay added to config.txt."
else
    echo "HiFiBerry DAC+ Zero overlay already present in config.txt."
fi

# Configure ALSA to use HiFiBerry DAC+ Zero as default
echo "=== Configuring ALSA for HiFiBerry DAC+ Zero ==="
cat <<EOF > /etc/asound.conf
pcm.!default {
    type hw
    card 0
}
ctl.!default {
    type hw
    card 0
}
EOF
echo "ALSA configuration created at /etc/asound.conf."
echo "HiFiBerry DAC+ Zero enabled."

echo "=== Setup complete ==="
echo "Installation complete! Rebooting in 5 seconds..."
echo "After reboot, connect via Bluetooth or AirPlay to 'CarPiAudio'."
sleep 5
reboot
