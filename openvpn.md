# Setting up OpenVPN
*Last Update: 20240409*

We'll follow approximately of the [guide](https://ubuntu.com/server/docs/service-openvpn) from Ubuntu. At the time of writing, there are some discrepancies noted between the guide and actual setup.

## Install `openvpn` and `easy-rsa`
```bash
sudo apt install openvpn easy-rsa
```

## Read this: Key Files for OpenVPN
OpenVPN provides a [table](https://openvpn.net/community-resources/how-to/#key-files) on different files needed on server/client. Save this as reference to check along the tutorial.
<table>
<tbody>
<tr>
<td><strong>Filename</strong></td>
<td><strong>Needed By</strong></td>
<td><strong>Purpose</strong></td>
<td><strong>Secret</strong></td>
</tr>
<tr>
<td>ca.crt</td>
<td>server + all clients</td>
<td>Root CA certificate</td>
<td>NO</td>
</tr>
<tr>
<td>ca.key</td>
<td>key signing machine only</td>
<td>Root CA key</td>
<td>YES</td>
</tr>
<tr>
<td>dh{n}.pem</td>
<td>server only</td>
<td>Diffie Hellman parameters</td>
<td>NO</td>
</tr>
<tr>
<td>server.crt</td>
<td>server only</td>
<td>Server Certificate</td>
<td>NO</td>
</tr>
<tr>
<td>server.key</td>
<td>server only</td>
<td>Server Key</td>
<td>YES</td>
</tr>
<tr>
<td>client1.crt</td>
<td>client1 only</td>
<td>Client1 Certificate</td>
<td>NO</td>
</tr>
<tr>
<td>client1.key</td>
<td>client1 only</td>
<td>Client1 Key</td>
<td>YES</td>
</tr>
<tr>
<td>client2.crt</td>
<td>client2 only</td>
<td>Client2 Certificate</td>
<td>NO</td>
</tr>
<tr>
<td>client2.key</td>
<td>client2 only</td>
<td>Client2 Key</td>
<td>YES</td>
</tr>
<tr>
<td>client3.crt</td>
<td>client3 only</td>
<td>Client3 Certificate</td>
<td>NO</td>
</tr>
<tr>
<td>client3.key</td>
<td>client3 only</td>
<td>Client3 Key</td>
<td>YES</td>
</tr>
</tbody>
</table>

## Set up Certificate Authority (CA) using `easy-rsa`
The CA is used to sign

Create directory for `easy-rsa`:
```bash
sudo make-cadir /etc/openvpn/easy-rsa
```
Go into the directory created as `root`:
```bash
sudo -s
cd /etc/openvpn/easy-rsa
./easyrsa init-pki
./easyrsa build-ca
```
This creates a CA.

## Generate Server Keys and Certificates
```bash
./easyrsa gen-req <your server name> nopass
```
`nopass` tells easyrsa to not add passphrase to the key.

