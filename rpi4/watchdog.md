# Watchdog for Raspberry Pi 4B
*Last Update: 20240408*

Watchdog is useful to reboot Raspberry Pi when it locks up.

## Enable Watchdog in Kernel
To add watchdog to kernel:
 - Natively for Raspberry Pi, in `config.txt` on boot SD card/drive, add `dtparam=watchdog=on`
 - Or, to load manually, `sudo modprobe bcm2835_wdt`, or add to `/etc/modules` with `bcm2835_wdt` to automatically launch.

## Install Watchdog Daemon
```bash
sudo apt-get install watchdog
```
Edit watchdog config
```bash
sudo vim /etc/watchdog.conf
```
Uncomment `watchdog-device = /dev/watchdog`
Set `watchdog-timeout = 15`. Looks like Raspberry Pi may support max of 15.
Set system load to reboot: `max-load-1 = 24`. 24 RPi are needed to complete task in 1 minute

## Start Watchdog Service

```bash
sudo systemctl enable watchdog
sudo systemctl start watchdog
```