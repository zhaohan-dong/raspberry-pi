# Remote Desktop to Raspberry Pi
*Last Update: 20240409*

## xrdp
xrdp is an open-source rdp server. Good tutorial on it [here](https://phoenixnap.com/kb/xrdp-ubuntu).
Run:
```bash
sudo apt install xrdp
```

Modify `/etc/xrdp/xrdp.ini` for settings.

Check state at:
```bash
sudo systemctl status xrdp
```
Now you're ready to go. Login using GUI username and password. The default port is 3389

To use ssh port forward:
```bash
ssh -NTL <localhost port for rdp>:127.0.0.1:3389 <ssh-user>@<remote-host>
```

To start/stop the service on boot:
```bash
# To start
sudo systemctl enable xrdp xrdp-sesman

# To stop
sudo systemctl disable xrdp xrdp-sesman
```

## TigerVNC
TigerVNC seems to be the best supported VNC server.

To install ubuntu desktop on the server, run `sudo apt install ubuntu-desktop`
To install TigerVNC Server, run `sudo apt install tigervnc-standalone-server`

### Start VNC Server
Run `tigervncserver -localhost` to start the vnc server allowing only localhost. It should run on port 5901 by default.
On first login, it would prompt user to set a password. To change the password later, use `vncpasswd`

### Connecting
To connect, we'll use ssh to port forward local host's port to port 5901 on the raspberry pi.
```bash
ssh -NTL <localhost port for vnc>:127.0.0.1:5901 <ssh-user>@<remote-host>
```
Then connect to the localhost port for vnc via `vnc://127.0.0.1:<localhost port for vnc>` to start remote desktop.

### Stopping
Run `tigervncserver -kill :*` on raspberry pi to stop the vnc server.
