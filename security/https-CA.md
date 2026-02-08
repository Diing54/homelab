# HTTPS
An internal DNS architecture and a reverse proxy have been set up in this homelab but all the traffic in our private network is still plain HTTP. This means data is readable over the network so there is a need for implementing HTTPS to secure this data.

I resorted to creating an Internal Certificate Authority (CA) that will issue certificates to verify the entities in this private network.

## HTTPS Design Decision 
- An internal Root CA
- Server Certificate issued for prod.homelab
- TLS termination at NGINX

## Setup process
I isolated the cryptographic material in the nginx configs directory;

```bash
sudo mkdir -p /etc/nginx/pki
cd /etc/nginx/pki
```

I then generated the Root CA's private key;

```bash
sudo openssl genrsa -out homelab-ca.key 4096
```

- This key is used to used to sign certificates and for real productions systems, it should never be exposed.

I then created the Root CA Certificate;

```bash
sudo openssl req -x509 -new -nodes \
  -key homelab-ca.key \
  -sha256 \
  -days 3650 \
  -out homelab-ca.crt
```
- This certificate exists so that other machines can say "I trust certificates signed by this CA".

After the above, a server certificate is issued for prod.homelab, NGINX will own and manage this certificate because this is one of its core functionalities, handling TLS handshakes. In this homelab, NGINX will decrypt the data coming from the outside but within our private network then this data will be transmitted to the rest of backend services in plain HTTP.

In the following directory;

```bash
cd /etc/nginx/pki
```

I created the server private key using the command;

```bash
sudo openssl genrsa -out prod.homelab.key 2048
```

Modern TLS require Subject Alternative Names, I created a config file for this;

```bash
sudo vim prod.homelab.cnf
```

```ini
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
CN = prod.homelab

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = prod.homelab
```
- Browsers ignore Certificate Names and they check for SANs 

I then generated the Certificate Signing Request using the following command;

```bash
sudo openssl req -new \
  -key prod.homelab.key \
  -out prod.homelab.csr \
  -config prod.homelab.cnf
```
After this, we proceed to sign the server certificate with the Certificate Authority (CA);

```bash
sudo openssl x509 -req \
  -in prod.homelab.csr \
  -CA homelab-ca.crt \
  -CAkey homelab-ca.key \
  -CAcreateserial \
  -out prod.homelab.crt \
  -days 825 \
  -sha256 \
  -extensions req_ext \
  -extfile prod.homelab.cnf
```

I then configured NGINX to redirect all HTTP traffic to HTTPS, decryption will happen at NGINX while communication to a simple backend service I created will remain plain HTTP;

```nginx
# Redirect all HTTP traffic to HTTPS
server {
    listen 80;
    server_name prod.homelab;
    return 301 https://$host$request_uri;
}

# HTTPS server
server {
    listen 443 ssl;
    server_name prod.homelab;

    ssl_certificate     /etc/nginx/pki/prod.homelab.crt;
    ssl_certificate_key /etc/nginx/pki/prod.homelab.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    root /var/www/prod;
    index index.html;

    access_log /var/log/nginx/prod.access.log;
    error_log  /var/log/nginx/prod.error.log;

    location / {
        try_files $uri $uri/ =404;
    }

    location /hello/ {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

After this, I needed to make sure the CA is trusted from both the two devices on my private network. The certificate of CA is then copied to both of the laptops using the command;

```bash
scp astro@prod.homelab:/etc/nginx/pki/homelab-ca.crt ~/
```
- The CA is then installed into both of the devices's trust store;

```bash
sudo cp homelab-ca.crt /etc/ca-certificates/trust-source/anchors/
```
Updating the trust store;

```bash
sudo trust extract-compat
```
With the above steps, I was happy HTTPS was fully implemented in my homelab !!

To read more about how HTTPS and CA's work, check it out below in my Kasten;

- https://diing54.github.io/devops/docs/httphttpsssltls-and-ca/

