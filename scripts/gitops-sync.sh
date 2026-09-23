#!/bin/bash
set -e # Exit immediately if a command fails

# The container runs as root, but the mounted files are owned by your host user
git config --global --add safe.directory /homelab

cd /homelab

# Fetch the latest state from GitHub
git fetch origin main
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    # Identify which specific apps/ directories have modified docker-compose files
    CHANGED_APPS=$(git diff --name-only $LOCAL $REMOTE | grep '^apps/' | cut -d/ -f1,2 | sort -u)
    
    # Pull the new code to the host machine
    git pull origin main
    
    # Iterate and deploy ONLY the modified containers
    for APP in $CHANGED_APPS; do
        echo "Applying GitOps sync to $APP..."
        cd "/homelab/$APP"
        docker compose up -d --remove-orphans
    done
else
    echo "GitOps Sync: No changes detected."
fi
