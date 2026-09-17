# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
