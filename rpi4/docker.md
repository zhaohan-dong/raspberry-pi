# Setup docker
*Last Update: 20240408*

In ubuntu, docker can be installed
```bash
sudo apt-get install docker.io
```
There might be issue with `permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock`

Run:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

To install docker compose:
```bash
sudo apt-get install docker-compose
```