# My Network

## Active Interface
- The Interface currently in use on Laptop A (Admin) is `wlo1`. This connects the device wirelessly(WIFI) to the home network

## Subnet
- Network: 192.168.100.0/24
- Address range: 192.168.100.1 – 192.168.100.254

## Gateway
- Command ---> `ip route`
- Router IP: 192.168.100.1

## Laptop A (Admin)
- Hostname: legion
- IP address: 192.168.100.26 - dynamic

## Laptop B (Client)
- Hostname: diing
- IP address: 192.168.100.21 - dynamic

## Raspberry Pi (Production node)
- Hostname: prod
- IP address: 192.168.100.56 - static

## DNS Configuration (Current State)
- Command ---> `nmcli dev show | grep DNS`
- DNS is managed by NetworkManager
- IPv4 DNS server: 192.168.100.1 (router)


- DHCP provided by router - Currently, I have not explicitly set up static IP addresses and for some reason they are not changing even after I reboot the devices.

## Notes
- Some routers like mine do not usually assign new IP addresses everytime a device reboots, but they are also not static forever. However, a static IP has been assigned to the Raspberry PI (prod node) using the router reservation settings.
- Static IP on Laptop A (admin) is essential if I wish to restrict ssh access on the raspberry PI (prod) e.g only allowing ssh connections from a single IP address in the home network. But currently I'm relying on SSH key authentication to the prod.
- Client IP remains dynamic to mirror real world situations.


