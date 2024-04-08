# Install Rocky Linux on Raspberry Pi 4B
*Last Update: 20240408*

### Description of Rocky Linux
Rocky Linux is an open-source enterprise operating system designed to be 100% bug-for-bug compatible with Red Hat Enterprise Linux®. It is under intensive development by the community.

Rocky Linux is a RHEL compatible OS, likely stabler than Raspberry Pi OS or Ubuntu, with support for RPM packages.<br/>
Note it is also possible to use [Oracle Linux](https://www.oracle.com/linux/downloads/linux-arm-downloads.html) natively on Raspberry Pi.<br/>

### Are Other Systems Available?
Yes, if the Raspberry Pi has UEFI installed.
By installing [Raspberry Pi 4 UEFI Firmware](https://github.com/pftf/RPi4), it's technically possible to install other systems for AArch64. However, it was throwing Synchronous Exceptions during installation attempts of several other OSes.<br/>

## 1 Download Latest Installer
As of writing, Raspberry Pi Imager doesn't support downloading the installer within it directly. We have to download the image ourselves.

Find the installer at [Rocky Linux Alternative Images Download Page](https://rockylinux.org/alternative-images)<br/>
or<br/>
directly from [Rocky Linux for Raspberry Pi Image](https://dl.rockylinux.org/pub/sig/9/altarch/aarch64/images/RockyLinuxRpi_9-latest.img.xz)<br/>

Load it onto an SD card or USB disk, using [Raspberry Pi Imager](https://www.raspberrypi.com/software/), [Balena Etcher](https://www.balena.io/etcher/), or run on a Unix-like system:<br/>
`dd if=DOWNLOADED_IMAGE of=DISK_NODE_IDENTIFIER bs=1M status=progress`<br/>

Substitute:
- `DOWNLOADED_IMAGE` with file path to the downloaded installer image
- `DISK_NODE_IDENTIFIER` with disk node identifier, for example `/dev/disk6`, find the identifier using `diskutil list` on Mac

## 2 Boot Rocky Linux for the First Time
Plug the storage device into Raspberry Pi.<br/>

Default credentials:<br/>
```
username: rocky
password: rockylinux
```
Run `sudo rootfs-expand` to grow the partition and use all of your memory card or hard drive.<br/>

For official guidance, find readme file at [Rocky 9 Raspberry Pi Image](https://dl.rockylinux.org/pub/sig/9/altarch/aarch64/images/README.txt)<br/>

### 2.1 Change Host Name and Host File
`hostnamectl set-hostname DESIRED_HOST_NAME`
also change the entry in `/etc/hosts`

### 2.2 Firewall
It's a bit tricky to set up firewall. Check out the [tutorial](https://docs.rockylinux.org/guides/security/firewalld-beginners/) or [firewalld documentation](https://firewalld.org/documentation/).

### (Optional) 2.2 Set LED lights
Add [`rocky-boot-config.txt`](rocky-boot-config.txt) content to `config.txt` on boot SD card/drive, or on Rocky Linux `/boot/config.txt`.
> Might be able to set fan on/off as in ubuntu, haven't tested

## 3 Misc
### Cron & Anacron
Rocky Linux supports both `anacron` and `cron`. Check logs at `/var/log/cron`

### Disable Ping (ICMP Requests)
#### Recommended Method
Drop ICMP requests without notifying the client.
```bash
sudo firewall-cmd --set-target=DROP --permanent
sudo firewall-cmd --reload
```
#### Another Method
Run as root<br/>
IPV4: `echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all`
IPV6: `echo "1" > /prc/sys/net/ipv6/icmp/echo_ignore_all`
See [IP Sysctl - The Linux Kernel](https://docs.kernel.org/networking/ip-sysctl.html) for more details.

To make it persistent, instead of the above, in `/etc/sysctl.conf` set:<br/>
`net.ipv4.icmp_echo_ignore_all = 1`
`net.ipv6.icmp.echo_ignore_all = 1`
