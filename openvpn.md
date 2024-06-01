# Setting up OpenVPN
*Last Update: 20240409*

We'll follow approximately of the [guide](https://ubuntu.com/server/docs/service-openvpn) from Ubuntu. At the time of writing, there are some discrepancies noted between the guide and actual setup.

## 1 Install `openvpn` and `easy-rsa`
```bash
sudo apt install openvpn easy-rsa
```

## 2 Read this: Key Files for OpenVPN
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

## 3 Server-Side: Set up Certificate Authority (CA) using `easy-rsa`
The CA is used to sign the certificate signing requests by clients.

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
This creates a CA. The certificate is at `pki/ca.crt`, and the private key is at `pki/private/ca.key`

## 4 Server-Side: Generate Server Keys and Certificates

### 4.1 Generate certificate signing request and key pair
```bash
./easyrsa gen-req <your server name> nopass
```
`nopass` tells easyrsa to not add passphrase to the key.
The private key would be placed at `pki/private/<yourservername>.key`

### 4.2 Generate Diffie Hellman parameters
```bash
./easyrsa gen-dh
```
The file would be placed in `pki/dh.pem`

### 4.3 Generate Signed Certificate
```bash
./easyrsa sign-req server <your server name>
```
The signed certificate is at `pki/issued/<your server name>.crt`

### 4.4 Copy Server-Side files to `/etc/openvpn`
To recap, the `/etc/openvpn/easy-rsa` folder should have:
```
/etc/openvpn/easy-rsa
├── easyrsa -> /usr/share/easy-rsa/easyrsa
├── openssl-easyrsa.cnf
├── pki
│   ├── ca.crt                       <--- Root CA Certificate (public on server + all clients)
│   ├── certs_by_serial
│   │   ├── <hash-serial1>.pem
│   │   └── <hash-serial2>.pem
│   ├── dh.pem                       <--- Diffie Hellman parameters (public on server)
│   ├── ...
│   ├── issued
│   │   └── <your server name>.crt   <--- Server Certificate (public on server)
│   ├── openssl-easyrsa.cnf
│   ├── private
│   │   ├── ca.key                   <--- Root CA Key (private on key signing machine)
│   │   └── <your server name>.key   <--- Server Key (private on server)
│   ├── renewed
│   │   ├── certs_by_serial
│   │   ├── private_by_serial
│   │   └── reqs_by_serial
│   ├── reqs
│   │   └── <...>.req                <--- Generated certificate signing requests
│   ├── revoked
│   │   ├── certs_by_serial
│   │   ├── private_by_serial
│   │   └── reqs_by_serial
│   └── ...
├── vars
└── x509-types -> /usr/share/easy-rsa/x509-types
```
Copy the files:
```bash
cp pki/dh.pem pki/ca.crt pki/issued/<your server name>.crt pki/private/<your server name>.key /etc/openvpn/
```

## 5 Generate tls-crypt-2 key
For information on why to use `tls-crypt`, visit https://openvpn.net/vpn-server-resources/tls-control-channel-security-in-openvpn-access-server/.

For more background info on `tls-crypt-2`, see this [document](https://github.com/OpenVPN/openvpn/blob/master/doc/tls-crypt-v2.txt) on GitHub.

In any folder:
```bash
# Generate server tls-crypt-v2 key
sudo openvpn --genkey tls-crypt-v2-server <server-tls>.key
```

```bash
# Generate client tls-crypt-v2 key
sudo openvpn --tls-crypt-v2 <server-tls>.key --genkey tls-crypt-v2-client <client-tls>.key
```

Copy `<server-tls>.key` to `/etc/openvpn`.
Copy `<client-tls>.key` to client via a secure way.

## 6 Sign Client Certificates

Import Signing Request:
 - **(NOT PREFERRED) (Inherent Risk Leaving Client Private Key on Server)** Create certificate signing request on server for client:
    ```bash
    # Generate signing request
    ./easyrsa gen-req <client name> nopass
    ```

 -   **(PREFERRED)** If a certificate signing request is made by client, with a request file:
    
    ```bash
    ./easyrsa import-req /<dir to request>/<client name>.req <client name>
    ```

Sign the request:
```bash
./easyrsa sign-req client <client name>
```

## 7 Send Certificates to Client

Copy the following to the client:
```
pki/ca.crt
pki/issued/<client name>.crt
```

Copy client configuration file to client from
`/usr/share/doc/openvpn/examples/sample-config-files/client.conf`.

The client should have the following files:
```
ca.crt                       <--- Root CA certificate
client1.crt                  <--- Client public certificate
client1.key                  <--- Client private key
client-tls.key               <--- TLS Crypt V2 client private key
```

To import into OpenVPN client, you may need to convert it to `.opvn` file.
Change the file extension, then edit `ca`, `cert`, `key` and `tls-auth` entries to have the keys enclosed in
`<ca></ca>`, `<cert></cert>`, `<key></key>`, `<tls-crypt-v2></tls-crypt-v2>`.

If you decide to use the `.conf` on Linux, just ensure those entries mentioned point to the correct files.


## 8 Setup port forwarding on server and route all traffic
Edit `/etc/sysctl.conf` and uncomment
```
#net.ipv4.ip_forward=1
```
Reload configuration
```bash
sudo sysctl -p /etc/sysctl.conf
```

Setup iptable NAT rules:
```bash
sudo iptables -t nat -A POSTROUTING -s <subnet of client> -o <network interface> -j MASQUERADE
sudo iptables -A FORWARD -j ACCEPT
```
Subnets can be like `192.168.0.0/24` and network interface would be `eth0`, `wlan0` or something else

Check the rules with:
```bash
sudo iptables -t nat -L -v --line-numbers
sudo iptables -L FORWARD -v -n --line-numbers
```

Then persist across reboot with:
```bash
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
sudo enable netfilter-persistent
```

Edit `/etc/openvpn/server.conf`:
```
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
```



## 9 Edit configuration and start server

Copy sample server configuration:
```bash
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/server.conf
```
Edit the `server.conf` file to point to the right files
```
ca ca.crt                            <--- Root CA certificate
cert <your server name>.crt          <--- Server certificate
key <your server name>.key           <--- Server private key
dh dh2048.pem                        <--- DH parameters
tls-crypt-v2 <server-tls>.key        <--- Server tls-crypt-v2 key
```

Start server (server-name is the `.conf`'s file name, e.g. `server` for our case)
```bash
sudo systemctl start openvpn@<server-name>
```

Check error messages
```bash
sudo journalctl -u openvpn@myserver -xe
```
