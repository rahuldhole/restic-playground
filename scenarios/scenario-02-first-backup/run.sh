#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="logs/restic.log"

echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}  LESSON 02: THE SNAPSHOT - YOUR FIRST BACKUP        ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "A ${BOLD}Snapshot${NC} is a frozen view of your data at a point in time."
echo -e "Unlike old-school backups, Restic only stores the *difference*."
echo -e "If you backup 1GB, then change 1KB, the next snapshot only adds 1KB."

echo -e "\n${BOLD}💻 THE COMMAND${NC}"
echo -e "${GREEN}restic backup /data${NC}"
echo -e "This scans the source directory, chunks the data, hashes it,"
echo -e "and sends only new chunks to the S3 bucket."

echo -e "\n${BOLD}🚀 THE ACTION${NC}"
echo -e "Backing up /data to the cloud..."
echo "$(date) [SCENARIO-02] restic backup /data" >> "$LOG_FILE"
docker exec restic-playground restic backup /data >> "$LOG_FILE" 2>&1
echo -e "${GREEN}✔ Snapshot created successfully!${NC}"

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
echo -e "1. Run ${BOLD}task status${NC} to see the new snapshot ID."
echo -e "2. Notice the 'Files Added' and 'Data Blobs' in the output."

echo -e "\n${CYAN}Next Level: run 'task scenario-3' to explore what's inside.${NC}"
