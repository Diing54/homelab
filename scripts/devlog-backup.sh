#!/bin/bash

BACKUP_DIR="/home/astro/homelab/backups/devlog"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="devlog_db_$TIMESTAMP.sql.gz"
CONTAINER_NAME="devlog_postgres"
DB_USER="devlog"
DB_NAME="devlog_db"
R2_DEST="r2-devlog:devlog/backups" # This creates a new folder in your R2 bucket

mkdir -p "$BACKUP_DIR"

# run pg_dump without needing postgres installed on the Pi itself
docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_DIR/$FILENAME"

# Sync to Cloudflare R2 (Bypassing the bucket admin check)
rclone copy "$BACKUP_DIR/$FILENAME" "$R2_DEST" --s3-no-check-bucket

# Keep only the last 7 days of local backups to save Pi disk space
find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "DevLog backup completed: $FILENAME"
