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
echo -e "${CYAN}${BOLD}  LESSON 05: THE PHOENIX - FULL SYSTEM RESTORE      ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "Your data partition is gone. Formatting happened. Fire in the server room."
echo -e "This is where Restic proves its worth. We will rebuild the entire"
echo -e "directory structure exactly as it was, with all metadata intact."

echo -e "\n${BOLD}💻 THE COMMAND${NC}"
echo -e "${GREEN}restic restore latest --target /${NC}"

echo -e "\n${BOLD}🚀 THE ACTION${NC}"
echo -e "${RED}[!] SIMULATING DISASTER:${NC} Wiping EVERYTHING in sample-data/..."
docker exec restic-data-gen sh -c "rm -rf /sample-sample-data/*"

echo -e "Performing full system restore from S3..."
echo "$(date) [SCENARIO-05] restic restore latest --target /" >> "$LOG_FILE"
docker exec restic-playground restic restore latest --target / >> "$LOG_FILE" 2>&1

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
echo -e "Inspecting the phoenix rising from the ashes..."
ls -R data | head -n 15
echo "... (truncated)"

echo -e "\n${CYAN}Next Level: run 'task scenario-6' to manage your growing repo.${NC}"
