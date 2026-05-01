#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="logs/restic.log"

echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}  LESSON 06: THE JANITOR - RETENTION & PRUNING      ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "Infinite backups = Infinite costs. You need a strategy to keep"
echo -e "only what you need. ${BOLD}Forget${NC} removes the reference to a snapshot,"
echo -e "and ${BOLD}Prune${NC} actually deletes the unreferenced data from S3."

echo -e "\n${BOLD}💻 THE COMMANDS${NC}"
echo -e "${GREEN}restic forget --keep-last 1 --prune${NC}"
echo -e "This tells Restic to only keep 1 snapshot and immediately clean"
echo -e "up the storage (prune) in one go."

echo -e "\n${BOLD}🚀 THE ACTION${NC}"
echo -e "Creating dummy snapshots to simulate history..."
docker exec restic-playground restic backup /data > /dev/null 2>&1
docker exec restic-playground restic backup /data > /dev/null 2>&1

echo -e "Executing retention policy..."
echo "$(date) [SCENARIO-06] restic forget --keep-last 1 --prune" >> "$LOG_FILE"
docker exec restic-playground restic forget --keep-last 1 --prune >> "$LOG_FILE" 2>&1
echo -e "${GREEN}✔ Repository optimized and cleaned!${NC}"

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
echo -e "1. Run ${BOLD}task status${NC}. You should only see 1 snapshot remaining."
echo -e "2. Notice the 'Data deleted' section in the logs."

echo -e "\n${CYAN}Next Level: run 'task scenario-7' for the final exam.${NC}"
