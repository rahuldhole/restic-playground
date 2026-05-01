#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="logs/restic.log"

echo -e "${CYAN}${BOLD}LESSON 5: Full System Restore${NC}"
echo "------------------------------------------------"
echo "Total catastrophe! All data is gone. We need to restore everything."
echo ""

# 1. Simulate failure
echo -e "${RED}SIMULATING FAILURE:${NC} Wiping all data in /data..."
rm -rf data/*

echo -e "${BOLD}COMMAND TO LEARN:${NC}"
echo -e "restic restore latest --target /"
echo ""

echo -e "${BOLD}EXECUTING FULL RESTORE:${NC}"
echo "$(date) [SCENARIO-05] restic restore latest --target /" >> "$LOG_FILE"

docker exec restic-playground restic restore latest --target / >> "$LOG_FILE" 2>&1

echo -e "${GREEN}SUCCESS: All data restored!${NC}"
ls -R ../../data | head -n 15
echo "... (showing subset of restored data)"

echo ""
echo "Next: run 'task scenario-6' to learn about retention and pruning."
