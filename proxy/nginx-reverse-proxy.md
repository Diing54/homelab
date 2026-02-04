# NGINX Reverse Proxy

NGINX is introduced to this homelab and I'm using it as an entry point for a simple internal service using its reverse proxying capabilities.

At this stage, the goal is to understand the request flows and the role of reverse proxy in this simple homelab architecture.

## Motivation

After configuring the internal DNS server, I thought of introducing a **single, controlled ingress point** for services instead of accessing applications directly by IP addresses and ports.

NGINX is chosen because;
1. It's widely used 
2. Can act as a reverse proxy
3. It can handle https, access control and routing


NGINX is installed on the rapsberry PI which I have nicknamed it as the prod node.

```bash
astro@prod:~$ curl http://127.0.0.1
<!DOCTYPE html>
<html>
<head>
  <title>prod.homelab</title>
</head>
<body>
  <h1>prod.homelab</h1>
  <p>Nginx name-based routing is working.</p>
</body>
</html>

astro@prod:~$ 
```

The above is confirming NGINX is up and running

But since NGINX is listening on port 80 for requests, I need to configure the firewall rules from ufw installed to allow traffic on port 80 by running the command `sudo ufw allow 80/tcp`. This enables devices on the LAN to hit the NGINX server.

## Name-based Virtual Hosting

A custom server block is created at the NGINX config file; 

The configuration file;

`/etc/nginx/sites-available/prod.homelab`

```nginx
server {
    listen 80;
    server_name prod.homelab;

    root /var/www/prod;
    index index.html;

    access_log /var/log/nginx/prod.access.log;
    error_log  /var/log/nginx/prod.error.log;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

From the above,
- Requests are matched by the host header which is `prod.homelab`.
- NGINX selects the correct server block
- The correct content is served based on hostname from the HTTP request (http://prod.homelab)

A symbolic link was created in sites-enabled directory.

## Introducing a Simple Backend Service





