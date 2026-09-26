#!/bin/bash
set -e

HOMELAB_DIR="/home/astro/homelab"
git config --global --add safe.directory $HOMELAB_DIR
cd $HOMELAB_DIR

echo "Starting GitOps Sync..."

if [ -n "$(git status --porcelain)" ]; then
    echo "Local uncommitted changes detected. Safely stashing them..."
    git stash push -m "Auto-stash before GitOps webhook sync"
    LOCAL_WORK_STASHED=true
else
    LOCAL_WORK_STASHED=false
fi

git fetch origin main
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    CHANGED_APPS=$(git diff --name-only $LOCAL $REMOTE | grep '^apps/' | cut -d/ -f1,2 | sort -u || true)
    git reset --hard origin/main
    
    for APP in $CHANGED_APPS; do
        if [ -d "$HOMELAB_DIR/$APP" ]; then
            echo "Applying GitOps sync to $APP..."
            cd "$HOMELAB_DIR/$APP"
            
            echo "Pulling new images..."
            n=0
            until [ "$n" -ge 3 ]
            do
               # Temporarily disable 'set -e' just for the pull command so a timeout doesn't kill the script
               set +e
               docker compose pull -q
               PULL_STATUS=$?
               set -e
               
               if [ $PULL_STATUS -eq 0 ]; then
                   break
               fi
               
               n=$((n+1))
               echo "Pull failed (likely network timeout). Retrying $n of 3 in 10 seconds..."
               sleep 10
            done
            
            if [ $PULL_STATUS -ne 0 ]; then
                echo "CRITICAL ERROR: Failed to pull images after 3 attempts. Aborting sync for $APP."
                continue
            fi
            
            echo "Images pulled successfully. Recreating modified containers..."
            docker compose up -d --remove-orphans --quiet-pull
        fi
    done
else
    echo "GitOps Sync: No remote changes detected."
fi

if [ "$LOCAL_WORK_STASHED" = true ]; then
    echo "Restoring your local uncommitted changes..."
    git stash pop || echo "WARNING: Merge conflict while restoring local work. Your changes are safely stored in 'git stash list'."
fi

echo "GitOps Sync completed successfully."
