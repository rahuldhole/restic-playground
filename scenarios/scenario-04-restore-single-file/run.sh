#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="../../logs/restic.log"

echo -e "${CYAN}${BOLD}LESSON 4: Restoring a Single File${NC}"
echo "------------------------------------------------"
echo "Oops! Someone deleted the database dump. Let's get it back."
echo ""

# 1. Simulate failure
echo -e "${RED}SIMULATING FAILURE:${NC} Deleting /data/database/backup.sql..."
rm -f ../../data/database/backup.sql

echo -e "${BOLD}COMMAND TO LEARN:${NC}"
echo -e "restic restore latest --target / --include /data/database/backup.sql"
echo ""

echo -e "${BOLD}EXECUTING RESTORE:${NC}"
echo "$(date) [SCENARIO-04] restic restore latest --include /data/database/backup.sql" >> "$LOG_FILE"

docker exec restic-playground restic restore latest --target / --include /data/database/backup.sql >> "$LOG_FILE" 2>&1

if [ -f "../../data/database/backup.sql" ]; then
    echo -e "${GREEN}SUCCESS: File restored!${NC}"
    ls -l ../../data/database/backup.sql
else
    echo -e "${RED}FAILURE: File not restored. Check logs/restic.log${NC}"
    exit 1
fi

echo ""
echo "Next: run 'task scenario-5' for a full system restore."
