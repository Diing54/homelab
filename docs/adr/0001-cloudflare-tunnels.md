# ADR 0001: Cloudflare Tunnels

**Status:** Accepted
**Date:** 2026-02

## Context
Traditionally, exposing local homelab services to the public internet requires port forwarding on the router, dynamic DNS configuration, and manual certificate management. This exposes the home network to automated bot scanners and DDoS attacks. 

## Decision
I implemented a Zero-Trust ingress architecture using Cloudflare Tunnels. A `cloudflared` container runs locally on my Raspberry Pi, establishing an outbound-only, encrypted HTTP/2 connection to Cloudflare's edge servers. No local inbound ports are open on the router.

Two self-hosted applications are currently exposed via subdomains:
* `bookmarks.cloudiing.com` (Linkding): Protected by the application's native authentication.
* `dash.cloudiing.com` (Homepage): Homepage does not ship with native authentication. I deployed Cloudflare Access in front of this subdomain to enforce email-based OTP authentication before the routing reaches the local network.

## Consequences
* **Pros:** Cloudflare handles DDoS protection and free managed TLS. Internal applications and the host IP are completely shielded from the public internet.
* **Cons:** Hard dependency on Cloudflare's infrastructure. If their routing or Access layer goes down, external access to the homelab is severed.
