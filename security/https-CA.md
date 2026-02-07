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





