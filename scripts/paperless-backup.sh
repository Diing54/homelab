#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/home/astro/homelab/backups/paperless-ngx"
MEDIA_DIR="/home/astro/homelab/apps/paperless-ngx/media"
CONTAINER_NAME="paperless-db"
DB_USER="astro"
DB_NAME="paperless"
R2_DEST="r2-paperless:paperless/backups"

mkdir -p "$BACKUP_DIR"

docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_DIR/paperless_db_$TIMESTAMP.sql.gz"

# archive documents
tar -czf "$BACKUP_DIR/paperless_media_$TIMESTAMP.tar.gz" -C "$MEDIA_DIR" .

# Sync to r2
rclone sync "$BACKUP_DIR" "$R2_DEST" --s3-no-check-bucket -v

# Cleanup old local backups
find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "Paperless-ngx Backup & R2 Sync successful: $TIMESTAMP"
