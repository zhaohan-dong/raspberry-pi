# Install Rocky Linux, Kubernetes and Others on Raspbery Pi 4B

### Description of Rocky Linux
Rocky Linux is an open-source enterprise operating system designed to be 100% bug-for-bug compatible with Red Hat Enterprise Linux®. It is under intensive development by the community.

### Why Rocky Linux
Rocky Linux is a RHEL compatible OS, likely stabler than Raspberry Pi OS or Ubuntu, with support for RPM packages.<br/>
Note it is also possible to use [Oracle Linux](https://www.oracle.com/linux/downloads/linux-arm-downloads.html) natively on Raspberry Pi.<br/>

### Are Other Systems Availale?
Yes, if the Raspberry Pi has UEFI installed.
By installing [Raspberry Pi 4 UEFI Firmware](https://github.com/pftf/RPi4), it's technically possible to install other systems for AArch64. However, it was throwing Synchronous Exceptions during installation attempts of several other OSes.<br/>

## Download Latest Installer
Find the installer at [Rocky Linux Alternative Images Download Page](https://rockylinux.org/alternative-images)<br/>
or<br/>
directly from [Rocky Linux for Raspberry Pi Image](https://dl.rockylinux.org/pub/sig/9/altarch/aarch64/images/RockyLinuxRpi_9-latest.img.xz)<br/>

Load it onto an SD card or USB disk, using [Raspberry Pi Imager](https://www.raspberrypi.com/software/), [Balena Etcher](https://www.balena.io/etcher/), or run:<br/>
`dd if=DOWNLOADED_IMAGE of=DISK_NODE_IDENTIFIER bs=1M status=progress`<br/>

Substitute:
- `DOWNLOADED_IMAGE` with file path to the downloaded installer image
- `DISK_NODE_IDENTIFIER` with disk node identifier, for example `/dev/disk6`, find the identifier using `diskutil list` on Mac

## Boot Rocky Linux for the First Time
Plug the storage device into Raspberry Pi.<br/>

Default credentials:<br/>
```
username: rocky
password: rockylinux
```
Run `sudo rootfs-expand` to grow the partition and use all of your memory card or hard drive.<br/>

For official guidance, find readme file at [Rocky 9 Raspberry Pi Image](https://dl.rockylinux.org/pub/sig/9/altarch/aarch64/images/README.txt)<br/>

## Install Kubernetes
