# ADR 0002: Strict Cryptographic Digest Pinning for Images

**Status:** Accepted
**Date:** 2026-04

## Context
Using `:latest` or standard semantic versioning (SemVer) tags in `docker-compose.yaml` files introduces deployment mutability. Upstream maintainers can overwrite tags, which can unexpectedly break the homelab during a routine pull. Furthermore, if an upstream registry is compromised, malicious code could be pushed under an existing tag, completely bypassing standard security checks.

## Decision
All container images in this repository are strictly pinned to their exact SHA256 cryptographic digests (e.g., `image:name@sha256:12345...`). 

I implemented Renovate Bot to manage this lifecycle. Renovate scans the upstream registries and automatically generates Pull Requests in this repository when a new digest is available. 

## Consequences
* **Pros:** Absolute deployment immutability. The exact bits tested by the upstream maintainer are the exact bits running on the Raspberry Pi. Mitigates supply-chain attacks.
* **Cons:** Creates a high volume of automated PRs that must be reviewed and merged. 
