# Homelab
This repository contains the configuration and documentation for my personal homelab, built on Cloud Native and DevOps principles. 

## Architecture & Hardware

The infrastructure is divided into two environments:

*   **Development:** Lenovo IdeaPad 3 running Arch Linux. Used for writing code, building container images, and managing configurations.
*   **Production:** Raspberry Pi 5 (8GB, Debian 13). Operates headlessly as the production node hosting all services.

## CI/CD Workflow

Deployments follow a GitOps-based pipeline using Renovate Bot:

1.  Custom applications are developed on the Arch Linux machine, containerized, and pushed to a remote registry.
2.  Renovate Bot monitors the registry and automatically creates a Pull Request in this repository when a new image tag is detected.
3.  Once the PR is merged, changes are pulled to the Raspberry Pi via SSH, and services are updated using Docker Compose.

## Services Stack

All services are containerized and orchestrated via Docker Compose:

*   **Homepage:** Dashboard providing an overview of infrastructure and container metrics.
*   **Paperless-ngx:** Document management system with an OCR pipeline.
*   **Vaultwarden:** Self-hosted password and secrets manager.
*   **Linkding:** Bookmark manager.
*   **DevLog & DevOps Notes:** Custom applications and knowledge bases for tracking activity and documentation.
*   **Blog:** Personal weblog served via Hugo.

## Networking & Security

All self-hosted applications are accessible externally without exposing local ports to the internet.

*   **Ingress:** Cloudflare Tunnels route traffic securely to the Raspberry Pi.
*   **Local Security:** The production node is hardened with UFW and strict SSH configurations.
*   **Data Integrity:** Automated bash scripts handle snapshotting, compressing, and storing database backups locally.
