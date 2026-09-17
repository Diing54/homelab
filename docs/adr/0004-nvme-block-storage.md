# ADR 0004: Migration to PCIe NVMe Block Storage

**Status:** Accepted
**Date:** 2026-09

## Context
The production Raspberry Pi 5 node hosts several heavy I/O database workloads, including PostgreSQL (for DevLog) and Redis (for Paperless-ngx OCR tasks). Initially, the OS and containers ran on a standard microSD card. SD cards lack dedicated storage controllers and DRAM caches, leading to high wear-leveling failure rates, I/O bottlenecks, and silent data corruption (bit-rot) during heavy concurrent writes.

## Decision
I migrated the primary storage layer to a 256GB Lexar PCIe NVMe SSD (M.2 2280) mounted via an Argon NEO 5 expansion board. The existing operating system was live-cloned block-by-block using `dd` to perfectly preserve the Docker configurations and environment variables, and the root filesystem was subsequently expanded to claim the full disk capacity.

## Consequences
* **Pros:** This completely eliminates the storage bottleneck, providing the high-frequency write endurance necessary for a distributed Kubernetes (K3s) control plane and future continuous time-series database logging.
* **Cons:** Considering the current market state of the storage and memory chips, the NVME was pricey.
