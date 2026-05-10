#!/bin/bash
set -e 

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/home/astro/homelab/backups/vaultwarden"
DATA_DIR="/home/astro/homelab/apps/vaultwarden/data"
TEMP_DB="/tmp/vault_snapshot.sqlite3"

mkdir -p $BACKUP_DIR

echo "--- Starting SQLite Snapshot ---"
sqlite3 "$DATA_DIR/db.sqlite3" ".backup '$TEMP_DB'"

echo "--- Archiving Assets ---"
cd "$DATA_DIR"
# We only grab the .pem key and any other files if they exist
tar -czf "$BACKUP_DIR/vault_assets_$TIMESTAMP.tar.gz" rsa_key.pem --ignore-failed-read 2>/dev/null || true

echo "--- Moving Database ---"
mv "$TEMP_DB" "$BACKUP_DIR/db_$TIMESTAMP.sqlite3"

echo "--- Syncing to R2 ---"
# Note: Using 'vaultwarden' as the bucket name here
rclone sync "$BACKUP_DIR" r2:vaultwarden/backups -v

echo "--- Cleaning up old local backups ---"
find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "Vaultwarden Backup & R2 Sync successful: $TIMESTAMP"
