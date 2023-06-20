# Auto Shutdown When No User is Active
Shutdown Raspberry Pi (or any unix-like machine) when no user is active. We can put this in as a cron job so it shuts down every day/week.
See [remotely shutting down a linux computer when no user is logged in](https://stackoverflow.com/questions/31558805/remotely-shutting-down-a-linux-computer-when-no-user-is-logged-in) on Stack Overflow.

We'll run the cron job as root, because only root is permitted to issue `shutdown` command on our system.
1. Put `shutdown.sh` in `/root`
2. `sudo chown root:root /root/shutdown.sh` and `sudo chmod 500 /root/shutdown.sh` to change the ownership and permissions.
3. Enter the crontab entry in root's crontab
- `export EDITOR=vim` (change `vim` to other editors you prefer, e.g. emanc)
- Edit root's crontab via `sudo crontab -e` 
  -  For example, `00 22 * * * /bin/bash /root/shutdown.sh`