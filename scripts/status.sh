#!/bin/bash

# Colors for UI
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# status.sh
echo -e "${GREEN}=== Restic Playground Status ===${NC}"

# Check if container is running
if ! docker ps | grep -q restic-playground; then
    echo "Container restic-playground is not running. Run 'task up' first."
    exit 1
fi

echo "--- Snapshots ---"
docker exec restic-playground restic snapshots 2>/dev/null || echo "No snapshots yet (or repo not initialized)"

echo ""
echo "--- Repository Stats ---"
docker exec restic-playground restic stats 2>/dev/null || echo "No stats available"

echo ""
echo "--- Last 5 Log Entries ---"
tail -n 5 logs/restic.log 2>/dev/null || echo "Log file is empty"
