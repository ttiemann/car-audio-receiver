# Car Audio Receiver Raspberry Pi Setup

## Installation Script

This repository includes an installation script for setting up Wi-Fi, AirPlay (Shairport Sync), Bluetooth audio, and HiFiBerry DAC+ Zero on Raspberry Pi OS Lite.

### Features
- Automatically enables Wi-Fi on first boot
- Uses hardcoded SSID and password in the installation script for transparency:
  - **SSID:** CarPiAudio
  - **Password:** carpi1234
  - **Country code:** DE (Germany)
- Installs Shairport Sync (AirPlay audio receiver) with custom service name "CarPiAudio"
- Installs Bluetooth audio packages (BlueALSA, PulseAudio Bluetooth module, Bluetooth utilities, Blueman)
- Configures Bluetooth auto-pairing with device name "CarPiAudio" for easy identification
- Enables automatic startup of Bluetooth, BlueALSA, and Shairport Sync services
- Enables HiFiBerry DAC+ Zero for high-quality audio output
- Configures ALSA to route all audio through HiFiBerry DAC+ Zero
- Automatically reboots after installation to apply configuration changes

### Usage
1. Flash Raspberry Pi OS Lite to your SD card.
2. Mount the SD card's boot partition on your computer.
3. Copy `scripts/install.sh` to the boot partition of the SD card.
4. Insert the SD card into your Raspberry Pi and boot.
5. Log in to your Raspberry Pi (using keyboard and monitor, or SSH if enabled).
6. If you copied the script from a Windows PC, set executable permissions (because Windows filesystems do not preserve Linux file permissions):
   ```bash
   chmod +x install.sh
   ```
7. Run the script as root:
   ```bash
   sudo ./install.sh
   ```
8. The script will create a `wpa_supplicant.conf` file in the SD card's boot partition, which configures the Raspberry Pi to automatically connect to the specified Wi-Fi network on first boot, install Shairport Sync (AirPlay) and Bluetooth audio packages, configure Bluetooth auto-pairing with the device name "CarPiAudio", enable automatic service startup for Bluetooth, BlueALSA, and Shairport Sync, enable HiFiBerry DAC+ Zero with proper ALSA audio routing, and automatically reboot to apply all changes.
9. After the automatic reboot, your Raspberry Pi will be ready to receive AirPlay and Bluetooth audio.
10. The device will appear as "CarPiAudio" for both AirPlay and Bluetooth connections from your phone or other devices.
11. Default SSH credentials for Raspberry Pi OS Lite:
    - **Username:** pi
    - **Password:** raspberry

### Notes
- SSH is not enabled by this script. To enable SSH, use the Raspberry Pi Imager tool and enable SSH in the advanced settings before writing the image to the SD card.
- For more information, see the official Raspberry Pi documentation:
  https://www.raspberrypi.com/documentation/computers/remote-access.html#enabling-ssh
- You can modify the script to use different Wi-Fi credentials or country code if needed. Edit the SSID, password, or country in `scripts/install.sh` as required.

---

For more details, see the script in `scripts/install.sh`.
