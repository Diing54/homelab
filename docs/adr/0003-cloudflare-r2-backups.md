# ADR 0005: Automated Offsite Backups to Cloudflare R2

**Status:** Accepted
**Date:** 2026-07

## Context
Stateful applications like Vaultwarden (password management), Paperless-ngx (critical documents), and DevLog began accumulating irreplaceable personal data. Relying solely on local storage leaves the infrastructure vulnerable to physical hardware failure, file system corruption, and catastrophic data loss. A true 3-2-1 backup strategy was required.

## Decision
I implemented an automated, offsite disaster recovery pipeline utilizing bash scripts, cron jobs, and Cloudflare R2 object storage. 

Dedicated scripts (`scripts/*-backup.sh`) are executed nightly via a cron job on the production node. The pipeline performs the following sequence:
1. Executes native database dumps (e.g., `pg_dump` for PostgreSQL, `.backup` for SQLite).
2. Compresses the database dumps and application media directories into `.tar.gz` and `.sql.gz` archives.
3. Enforces a strict 7-day local retention policy, automatically purging older snapshots to conserve disk space.
4. Utilizes `rclone` to securely sync the local backups to an offsite Cloudflare R2 bucket.

## Consequences
* **Pros:** Achieves true offsite disaster recovery. Cloudflare R2 charges zero egress fees, making it highly cost-effective for backup retrieval. The process is completely automated and decoupled from the container orchestration layer.
* **Cons:** Introduces additional credential management complexity (R2 API keys, `rclone` configuration) that must be secured outside of the repository. 
