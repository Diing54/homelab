# DNS Configuration for this homelab

I configured an internal DNS server using `dnsmasq` on the prod node which is the Raspberry PI The goal is to eliminate IP-based access between the devices and rely on stable human-readable hostnames within the private network.

The DNS server acts as a single point of name resolution across the entire homelab

## Reason for this

Before introducing DNS, all communication between the devices relied on IP addresses. This forced me to memorize the IP addresses of the devices or look them up in order to perform basic functions such as ssh and ping.

The DNS setup was designed to:

- Resolve internal hostnames such as `prod.homelab` and `client.homelab`
- Allow SSH access using hostnames instead of IPs
- Enable peer-to-peer communication between laptops via name resolution
- Establish a base for future components (reverse proxy, observability, certificates)

## DNS Architecture

The Raspberry Pi (`192.168.100.56`) runs `dnsmasq` and serves DNS requests for the `.homelab` zone.

All homelab devices are configured to use the Pi as their primary DNS server. When a client queries a hostname like `client.homelab`, the request flow is:

1. Client sends DNS query to `192.168.100.56`
2. `dnsmasq` matches the hostname against its static configuration
3. The corresponding private IP is returned
4. The client uses the resolved IP for communication (e.g. ICMP, SSH)

No external DNS resolution is involved for internal hostnames.

## dnsmasq Configuration

Static hostname-to-IP mappings are defined as shown below;

```dnsmasq
address=/prod.homelab/192.168.100.56
address=/client.homelab/192.168.100.21
address=/admin.homelab/192.168.100.22
```

After the dns configuration, I can successfully ssh into the devices using their hostnames instead of typing their IP addresses; 

- `ssh prod.homelab`
- `ssh admin.homelab`
- `ssh client.homelab`

