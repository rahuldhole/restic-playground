#!/bin/sh

# Ensure directories exist
mkdir -p /sample-sample-data/app_sample-data/assets
mkdir -p /sample-sample-data/sample-database
mkdir -p /sample-sample-data/logs

echo "[Data Gen] Starting agnostic simulation..."

# Initial seed data
echo "Generic Application Index" > /sample-sample-data/app_sample-data/index.html
echo "PRE-SEED DATA" > /sample-sample-data/sample-database/backup.sql
echo "$(date) INFO System started" > /sample-sample-data/logs/server.log

while true; do
    # 1. Update logs
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO Event-ID: $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)" >> /sample-sample-data/logs/server.log
    
    # 2. Simulate new assets
    FILE_NAME="asset-$(date +%s).bin"
    echo "Random binary data content" > "/sample-sample-data/app_sample-data/assets/$FILE_NAME"
    
    # 3. Append to database backup
    echo "-- Update record at $(date +%s)" >> /sample-sample-data/sample-database/backup.sql
    
    # 4. Cleanup old assets
    COUNT=$(ls /sample-sample-data/app_sample-data/assets | wc -l)
    if [ "$COUNT" -gt 20 ]; then
        OLDEST=$(ls -t /sample-sample-data/app_sample-data/assets | tail -1)
        rm "/sample-sample-data/app_sample-data/assets/$OLDEST"
    fi

    sleep 5
done
