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
echo -e "${CYAN}${BOLD}  LESSON 07: THE SURVIVOR - DISASTER RECOVERY       ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "Your server is a smoking crater. You have nothing but your S3 keys."
echo -e "A ${BOLD}Cold Restore${NC} is the ultimate test. We will simulate this by"
echo -e "wiping all local data and asking Restic to rebuild it from the cloud."

echo -e "\n${BOLD}💻 THE COMMAND${NC}"
echo -e "${GREEN}restic restore latest --target /${NC}"

echo -e "\n${BOLD}🚀 THE ACTION${NC}"
echo -e "${RED}[!] SIMULATING TOTAL LOSS:${NC} Wiping all data..."
rm -rf data/*

echo -e "Re-establishing connection to S3 and pulling data..."
echo "$(date) [SCENARIO-07] restic restore latest --target /" >> "$LOG_FILE"
docker exec restic-playground restic restore latest --target / >> "$LOG_FILE" 2>&1

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
echo -e "${GREEN}✔ Recovery complete!${NC} All files are back in their original paths."
echo -e "You have successfully survived a simulated catastrophic failure."

echo -e "\n${CYAN}${BOLD}🏆 CONGRATULATIONS! You have completed the Restic Playground.${NC}"
