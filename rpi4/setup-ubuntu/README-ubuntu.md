# Installing Ubuntu 22.04 LTS on Raspberry Pi 4B
*Last Update: 20240408*

## Initial Installation
Use [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to install Ubuntu. There are two distributions available: desktop or server

### 1 Credentials (Ubuntu Server)
If installing Ubuntu Server, the Raspberry Pi Imager can set:
 - Local DNS Name
 - SSH public key
 - Username and password
 - Wi-Fi network name + password

This saves a lot of time post-installation editing files.

### 2 [Firewall](https://help.ubuntu.com/community/UFW) (NOT enabled by default)
The firewall is by default off.
You can allow ports by `sudo ufw allow [port]` or `sudo ufw allow [port]/[tcp|udp]`.
You can also enable a service by name, such as for ssh `sudo ufw allow ssh`.

Check status and allowed/disallowed service by `sudo ufw status`.

To enable firewall, run `sudo ufw enable`. To disable, run `sudo ufw disable`

### (Optional) 3 Installing Ubuntu Desktop on Ubuntu Server Distribution
To install Ubuntu Desktop, use `sudo apt install ubuntu-desktop`. There might be other desktop versions such as vanilla GNOME available.

## Set up GPIO fan and LEDs
On the SD card, add content in [`ubuntu-boot-config.txt`](ubuntu-boot-config.txt) to the **existing `config.txt`** on SD card/boot drive, or `/boot/firmware/config.txt` on machine:
Connect the PWM pin of the fan to GPIO pin 14, if using official Raspberry Pi 4 fan.
> Note: The LED settings behavior is different for pre-bullseye builds and other systems, where `dtparam=act_led_trigger=none` is used instead of `dtparam=pwr_led_trigger=default-on`