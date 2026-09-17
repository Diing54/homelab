# ADR 0003: Automated CI/CD Secret Scanning

**Status:** Accepted

## Context
This homelab repository is public to serve as an engineering portfolio. Because the architecture relies heavily on `.env` files for database credentials and API tokens (Cloudflare, GHCR), there is a severe risk of accidentally committing a secret to the public Git history, compromising the infrastructure.

## Decision
I implemented Gitleaks as a mandatory Static Application Security Testing (SAST) pipeline via GitHub Actions. The workflow is configured with `fetch-depth: 0` to scan the entire commit history on every `push` and `pull_request`. 

## Consequences
* **Pros:** Provides an immutable, server-side guarantee that no high-entropy strings or known API key formats are merged into the `main` branch. 
* **Cons:** I think there is a better way for secret management rather than depending on hardcoded passwords on .env files.
