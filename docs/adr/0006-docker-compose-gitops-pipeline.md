## ADR 0006: Event-Driven Pipeline for Docker Compose

**Status:** Accepted
**Data:** 2026-10

## Context
The homelab infra relies on Docker Compose. Historically, deploying new container images like devlog required me to SSH into the raspberry Pi, then manually restarting the containers.

I needed an automation for this repetitive task. I thought of GitOps controllers like ArgoCD and Flux but these tools require a Kubernetes cluster.

## Decision
I engineered a custom webhook that securely routes GitHub push payloads through a CLoudflare Tunnel without exposing inbound ports. Upon verifying the HMAC signature, this webhook triggers a deployment script that restarts the affected application's container via the hosts's docker socket.

## Consequences
**Pros:** Merging a PR instantly and silently updates the production environment(Zero-Touch Deployment).
**Cons:** The risk of mounting /var/run/docker.sock, which grants the webhook container root access to the host.
