#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="../../logs/restic.log"

echo -e "${CYAN}${BOLD}LESSON 2: Your First Backup${NC}"
echo "------------------------------------------------"
echo "Now that the repo is ready, let's backup our /data directory."
echo "Restic calls each backup a 'snapshot'."
echo ""
echo -e "${BOLD}COMMAND TO LEARN:${NC}"
echo -e "restic backup /path/to/data"
echo ""

echo -e "${BOLD}EXECUTING:${NC} Backing up /data..."
echo "$(date) [SCENARIO-02] restic backup /data" >> "$LOG_FILE"

docker exec restic-playground restic backup /data >> "$LOG_FILE" 2>&1

echo -e "${GREEN}SUCCESS: Backup completed!${NC}"
echo "Restic scanned /data and saved the files to the repo."
echo "Try running 'make status' to see the new snapshot."
echo ""
echo "Next: run 'make scenario-3' to explore your snapshots."
