#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="logs/restic.log"

echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}  LESSON 04: THE SURGERY - SELECTIVE RESTORE        ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "Total recovery is great, but often you just need *one* file back."
echo -e "Restic's ${BOLD}--include${NC} flag lets you perform 'surgery' on your snapshots"
echo -e "to extract exactly what you need without waiting for a full restore."

echo -e "\n${BOLD}💻 THE COMMAND${NC}"
echo -e "${GREEN}restic restore latest --target / --include /path/to/file${NC}"

echo -e "\n${BOLD}🚀 THE ACTION${NC}"
echo -e "${RED}[!] SIMULATING ACCIDENT:${NC} Deleting database/backup.sql..."
docker exec restic-data-gen rm -f /sample-data/database/backup.sql

echo -e "Recovering the file from S3..."
echo "$(date) [SCENARIO-04] restic restore latest --include /sample-data/database/backup.sql" >> "$LOG_FILE"
docker exec restic-playground restic restore latest --target / --include /sample-data/database/backup.sql >> "$LOG_FILE" 2>&1

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
if [ -f "sample-data/database/backup.sql" ]; then
    echo -e "${GREEN}✔ Success! File restored.${NC}"
    ls -l sample-data/database/backup.sql
else
    echo -e "${RED}✘ Failure! File missing. Check logs.${NC}"
fi

echo -e "\n${CYAN}Next Level: run 'task scenario-5' for a full disaster drill.${NC}"
