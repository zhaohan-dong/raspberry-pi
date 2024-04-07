# VNC to Raspberry Pi

In Ubuntu, we'll use tigervncserver to connect. I have tried other solutions, but it seems like tigervnc is the best with headless server mode.

To install ubuntu desktop on the server, run `sudo apt install ubuntu-desktop`
To install TigerVNC Server, run `sudo apt install tigervnc-standalone-server`

## First Time Login
Run `tigervncserver -localhost` to start the vnc server allowing only localhost. It should run on port 5901 by default.
On first login, it would prompt user to set a password. To change the password later, use `vncpasswd`

## Connecting
To connect, we'll use ssh to port forward local host's port to port 5901 on the raspberry pi.
`ssh -NTL [localhost port for vnc]:127.0.0.1:5901 [ssh-user]@[remote-host]`
Then connect to the localhost port for vnc via `vnc://127.0.0.1:[localhost port for vnc]` to start remote desktop.

## Stopping
Run `tigervncserver -kill :*` on raspberry pi to stop the vnc server.
