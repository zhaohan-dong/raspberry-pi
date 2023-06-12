# Installing k3s on Raspberry Pi 4B

It turns out that installing a single node Kubernetes with `kubeadm` might lead to many crashes. So [k3s](https://docs.k3s.io) is a more viable tool to installing a simple Kubernetes on Raspberry Pi.

## Preparation

### Edit root user PATH
k3s would require to have `/usr/local/bin` in root user's PATH. For rootless installations, edit the root path via `sudo visudo` and add `/usr/local/bin` to `Defaults    secure_path`.

### Set Computer Name
To expose the cluster to the Internet and use an URL, you must set the computer name to the URL's hostname. k3s will configure the certificate based on the hostname at the time of installation.

### Disable Swap
Comment out swap in `/etc/fstab` or `systemd.swap`
- Do not use `sudo swapoff -a` as the settings will not persist after reboot
- Check swap usage using `free -m`

### Cgroup Memory
Cgroup memory must be enabled. On a Raspberry Pi, edit `/boot/cmdline.txt` to include `cgroup_enable=cpuset cgroup_enable=memory`(`cgroup_memory=1` not necessary anymore).

### Ports and Firewalld
Open the ports required by Kubernetes in firewalld. See the ports required [here](https://docs.k3s.io/installation/requirements#networking).<br/>
At the time of the writing, the ports are:
|Protocol   |Port       |Source     |Destination|Description                                    |
|-----------|-----------|-----------|-----------|-----------------------------------------------|
|TCP        |2379-2380  |Servers    |Servers    |Required only for HA with embedded etcd        |
|TCP        |6443       |Agents     |Servers    |K3s supervisor and Kubernetes API Server       |
|UDP        |8472       |All nodes  |All nodes  |Required only for Flannel VXLAN                |
|TCP        |10250      |All nodes  |All nodes  |Kubelet metrics                                |
|UDP        |51820      |All nodes  |All nodes  |Required only for Flannel Wireguard with IPv4  |
|UDP        |51821      |All nodes  |All nodes  |Required only for Flannel Wireguard with IPv6  |
- Check ports opened by `sudo firewall-cmd --list-ports`
- Open ports using `sudo firewall-cmd --permanent --add-port=port-number/port-type`

## Installing k3s

### Server Node (Master)
On the server node, run:<br/>
`curl -sfL https://get.k3s.io | sh -`<br/>

The Kubernetes config file can be found at `/etc/rancher/k3s/k3s.yaml`. Copy the file to your local machine's `~/.kube/config` file to control the cluster from `kubectl`<br/>

**By default, the config file is not accessible to non-root users.** Use the following to make the kube config file accessible to non-root users:<br/>
`curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644`

The service can be started using:<br/>
```
sudo systemctl start k3s
sudo systemctl enable k3s
sudo systemctl status k3s
sudo systemctl stop k3s
```

### Agent Node (Slave)
The node token can be found in `/var/lib/rancher/k3s/server/node-token` at server node.<br/>
Run the following at agent nodes:<br/>
`curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP-ADDR>:6443 K3S_TOKEN=<TOKEN FROM MASTER NODE> sh -`

## Uninstalling k3s
Server Node: Run
`sudo /usr/local/bin/k3s-uninstall.sh`<br/>
Agent Node: Run
`sudo /usr/local/bin/k3s-agent-uninstall.sh`