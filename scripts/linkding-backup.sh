#!/bin/bash
set -e 

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/home/astro/homelab/backups/linkding"
DATA_DIR="/home/astro/homelab/apps/linkding/data"
TEMP_DB="/tmp/linkding_snapshot.sqlite3"
R2_DEST="r2-linkding:linkding/backups" 

mkdir -p "$BACKUP_DIR"

# Start sqlite snapshot
sqlite3 "$DATA_DIR/db.sqlite3" ".backup '$TEMP_DB'"

# Move Database
mv "$TEMP_DB" "$BACKUP_DIR/linkding_db_$TIMESTAMP.sqlite3"

# Sync to R2
rclone sync "$BACKUP_DIR" "$R2_DEST" --s3-no-check-bucket -v

# Clean up old local backup
find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "Linkding Backup & R2 Sync successful: $TIMESTAMP"
