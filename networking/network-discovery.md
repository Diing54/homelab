# My Network

## Active Interface
- Interface: wlo1 (Wi-Fi)

## Subnet
- Network: 192.168.100.0/24
- Address range: 192.168.100.1 – 192.168.100.254

## Gateway
- Command ---> `ip route`
- Router IP: 192.168.100.1

## Admin Laptop
- Hostname: legion
- IP address: 192.168.100.26

## Planned Static IPs
- Raspberry Pi (production): 192.168.100.50

## DNS Configuration (Current State)
- Command ---> `nmcli dev show | grep DNS`
- DNS is managed by NetworkManager
- IPv4 DNS server: 192.168.100.1 (router)

## Notes
- DHCP provided by router


