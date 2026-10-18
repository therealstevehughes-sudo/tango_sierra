#!/bin/bash
# Off-site backups (2026-10-18): after the nightly local database backup,
# copy everything needed to rebuild VenuRite to Backblaze B2, encrypted
# on this server before upload (rclone "crypt" remote b2crypt: — the
# passphrase is in /root/backups/.offsite_secret AND held by the founder
# offline; without it the backups cannot be read).
# Bucket venurite-backups: each file locked for 30 days (compliance mode,
# nobody can delete it), removed automatically after that.
# Installed as /root/backups/backup_offsite.sh, run from backup_db.sh.
set -euo pipefail
DOCKER_DIR=/root/tango-sierra/supabase/docker
BACKUP_DIR=/root/backups
STAMP=$(date +%Y%m%d_%H%M%S)
LATEST=$(ls -1t "$BACKUP_DIR"/supabase_backup_*.sql.gz | head -1)

# 1. Database (all of it: every customer's records).
rclone copy "$LATEST" b2crypt:db/ --no-traverse

# 2. Uploaded files (check photos, clock-in photos, documents).
rclone sync "$DOCKER_DIR/volumes/storage" b2crypt:storage/

# 3. Server settings and Edge Function code (secrets included, encrypted).
TMP=$(mktemp -d)
tar -czf "$TMP/config_$STAMP.tar.gz" -C "$DOCKER_DIR" .env docker-compose.yml volumes/functions \
  -C /root backups/backup_db.sh backups/backup_offsite.sh
rclone copy "$TMP/config_$STAMP.tar.gz" b2crypt:config/ --no-traverse
rm -rf "$TMP"

echo "$(date): off-site copy complete ($(basename "$LATEST"), storage synced, config_$STAMP)"
