#!/bin/bash
# Enable Bluetooth audio via PulseAudio (run as regular user, not root)

echo "Starting PulseAudio..."
pulseaudio --start

echo "Loading PulseAudio Bluetooth module..."
pactl load-module module-bluetooth-discover

echo "Bluetooth audio via PulseAudio is now enabled."
