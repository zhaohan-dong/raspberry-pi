# Installing Kubernetes on Raspberry Pi 4B

Why use `minikube` when you can configure a remote Kubernetes? In this guide, we will create a Kubernetes cluster with `kubeadm` on Raspberry Pi.<br/>
You can also follow [Official Kubernetes Guide](https://kubernetes.io/docs/setup/production-environment/), but **be sure to check out System Specific Configuration**<br/>

## System Requirements
- A compatible Linux host;
- 2 GB or more RAM per machine;
- 2 CPUs or more;
- Full network connectivity between all machines in the cluster (public or private network is fine);
- Unique hostname, MAC address, and product_uuid for every node;
- Certain ports are open on your machines. See [Ports and Protocols](https://kubernetes.io/docs/reference/networking/ports-and-protocols/), and;
	- Control plane: Inbound TCP 6443, 2379-2380, 10250, 10259, 10257
	- Worker node(s): Inbound TCP 10250, 30000-32767
- Swap disabled.
	- Comment out swap in `/etc/fstab` or `systemd.swap`
	- Do not use `sudo swapoff -a` as the settings will not persist after reboot
	- Check swap usage using `free -m`

## System Specific Configuration
- Cgroup memory must be enabled. On a Raspberry Pi, edit `/boot/cmdline.txt` to include `cgroup_enable=cpuset cgroup_enable=memory`(`cgroup_memory=1` not necessary anymore).
- Disable swap by commenting out corresponding entry in `/etc/fstab`.
- Open the ports required by Kubernetes in firewalld. See [Ports and Protocols](https://kubernetes.io/docs/reference/networking/ports-and-protocols/).
	- Check ports opened by `sudo firewall-cmd --list-ports`
	- Open ports using `sudo firewall-cmd --permanent --add-port=port-number/port-type`

## Install Container Runtimes
Follow the official guide [here](https://kubernetes.io/docs/setup/production-environment/container-runtimes/).<br/>
Note Rocky Linux uses `systemd` as the init system, and `kubeadm` v1.22 and later defaults `cgroupDriver` field under `KubeletConfiguration` to `systemd` (see [here](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver).<br/>
If installing containerd from package, remove `cri` from `disabled_plugins` list within `/etc/containerd/config.toml`, then restart containerd `sudo systemctl restart containerd`

## Initialize Kubernetes Cluster
Run `sudo kubeadm init`<br/>
Make a record of the `kubeadm` command that `kubeadm init` outputs. This command will be used to join other nodes to the cluster.

## Add a Network and Network Policy
A lot of people suggest [Calico](https://www.tigera.io/project-calico/).<br/>
Non-exhaustive list suggested by Kubernetes [here](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy).

## Reset Kubernetes Cluster
Run `sudo kubeadm reset`