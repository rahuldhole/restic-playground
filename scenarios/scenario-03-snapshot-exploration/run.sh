#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}  LESSON 03: THE TIME MACHINE - EXPLORATION          ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "How do you know what changed? Restic allows you to ${BOLD}ls${NC} inside"
echo -e "a snapshot and ${BOLD}diff${NC} two snapshots to see exactly what"
echo -e "was added, changed, or deleted."

echo -e "\n${BOLD}💻 THE COMMANDS${NC}"
echo -e "${GREEN}restic ls <id>${NC}     : List files in snapshot"
echo -e "${GREEN}restic diff <a, b>${NC} : Show delta between two states"

echo -e "\n${BOLD}🚀 THE ACTION${NC}"
echo -e "Listing your snapshots..."
docker exec restic-playground restic snapshots

echo -e "\nInspecting the latest snapshot contents..."
LATEST_ID=$(docker exec restic-playground restic snapshots --json | grep -oE '"id":"[0-9a-f]+"' | head -1 | cut -d'"' -f4)
docker exec restic-playground restic ls "$LATEST_ID" | head -n 10
echo "... (truncated)"

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
echo -e "Notice how the paths are preserved exactly as they were in /sample-data."

echo -e "\n${CYAN}Next Level: run 'task scenario-4' for your first restoration.${NC}"
