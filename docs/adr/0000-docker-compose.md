# ADR 0000: Docker Compose Orchestration

**Status:** Accepted
**Date:** 2025-11

## Context
As I started to run apps with multi-service architecture (databases, caching layers, and web applications), managing containers via imperative `docker run` commands became brittle and unscalable. The infrastructure lacked a single source of truth, making it difficult to track configurations, reproduce environments, or version-control the infrastructure.

## Decision
I standardized on **Docker Compose** as the primary orchestration tool for the homelab. Every application stack (e.g., Paperless-ngx, DevLog) is defined declaratively in its own `docker-compose.yaml` file. 

These YAML manifests are version-controlled in Git, and deployments are executed by pulling the repository to the production node and running `docker compose up -d`.

## Consequences
* **Pros:** 
  * **Declarative GitOps:** Infrastructure is defined as code (IaC), allowing for strict version control and easy recovery.
  * **Network Isolation:** Compose natively handles the creation of isolated bridge networks (e.g., `devlog_internal`), keeping backend databases entirely hidden from other services.
  * **Simplicity:** Very low overhead on the Raspberry Pi host compared to a full Kubernetes control plane.
* **Cons:** 
  * **Single-Node Constraint:** Docker Compose cannot natively orchestrate containers across multiple physical machines. If the primary Raspberry Pi node fails, there is no automated failover. 
  * **No Self-Healing:** If the Docker daemon itself crashes, it takes down all the containers.
