# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-10-17
### Added
- **Network:** Deployed Pi-hole as network-wide ad-blocker and DNS resolver.
- **Dashboard:** Added Pi-hole real-time metrics widget to Homepage.

### Changed
- **Network:** Reconfigured my router to broadcast the raspberry Pi as the primary DNS server.

## [1.1.0] - 2026-10-12
### Added
- **GitOps:** Implemented a custom, event-driven CI/CD pipeline using `adnanh/webhook` to automate Docker Compose deployments.
- **Observability:** Added real-time logging of the GitOps deployment to `gitops.log`.
- **Dashboard:** Added the webhook container to homepage
- **Documentation:** Authored ADR-0006 describing the webhook automation

### Changed
- **CI/CD:** Moved from manual SSH-based git pulls to automated zero-touch deployments.

## [1.0.0] - 2026-09-18
### Added
- **Security:** Implemented Gitleaks automated secret scanning via GitHub Actions CI/CD.
- **Documentation:** Restructured documentation into Architecture Decision Records (ADRs) to track historical engineering decisions.
- **Backups:** Automated nightly offsite disaster recovery pipeline to Cloudflare R2 utilizing `pg_dump`, `tar`, and `rclone`.

### Changed
- **Infrastructure:** Upgraded Raspberry Pi 5 production node storage from microSD to a 256GB Lexar PCIe NVMe SSD via Argon NEO 5 case.
- **Deployment:** Migrated all container deployments to strict SHA256 cryptographic digest pinning via Renovate Bot.

### Removed
- **Networking:** Deprecated legacy internal Nginx reverse proxy and dnsmasq configurations.
