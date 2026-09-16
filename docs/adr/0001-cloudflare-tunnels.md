## Context
Traditionally, exposing local homelab services to the public internet requires port forwading on the router, DNS configuration and manual certificate management. This exposes the home network to automated bot scanners and DDoS attacks.

## Decision
I implemented a Zero-Trust ingress architecture using **Cloudflare Tunnels**. A `cloudflared` container runs locally in my Raspberry Pi, establishing an outbound only, encrypted HTTP/2 connection to Cloudflare's servers. No local inbound ports are open.

For now, I have exposed two of my self-hosted applications using subdomains; `dash.cloudiing.com` and `bookmarks.cloudiing.com` for homepage and linkding respectively. Anyone attempting to access my linkding(bookmarks.cloudiing.com) will be greeted by a login page already configured in the application. However, Homepage(dash.cloudiing.com), by default, does not come shipped with any authentication mechanism. I have deployed **Cloudflare Access** infront of my homepage domain. Anyone attempting to access the page is greeted by an email-based OTP authentication.

## Consequences
* **Pros:** Cloudflare does the heavy lifting security configurations .e.g DDoS protection and free managed TLS. Internal applications are shielded from the public.
* **Cons:** Hard dependency on Cloudflare. If anything on Cloudflare infrastructure goes down, I will be affected heavily.
