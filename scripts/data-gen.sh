#!/bin/sh

# Ensure directories exist
mkdir -p /data/app_data/assets
mkdir -p /data/database
mkdir -p /data/logs

echo "[Data Gen] Starting agnostic simulation..."

# Initial seed data
echo "Generic Application Index" > /data/app_data/index.html
echo "PRE-SEED DATA" > /data/database/backup.sql
echo "$(date) INFO System started" > /data/logs/server.log

while true; do
    # 1. Update logs
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO Event-ID: $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)" >> /data/logs/server.log
    
    # 2. Simulate new assets
    FILE_NAME="asset-$(date +%s).bin"
    echo "Random binary data content" > "/data/app_data/assets/$FILE_NAME"
    
    # 3. Append to database backup
    echo "-- Update record at $(date +%s)" >> /data/database/backup.sql
    
    # 4. Cleanup old assets
    COUNT=$(ls /data/app_data/assets | wc -l)
    if [ "$COUNT" -gt 20 ]; then
        OLDEST=$(ls -t /data/app_data/assets | tail -1)
        rm "/data/app_data/assets/$OLDEST"
    fi

    sleep 5
done
