#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="../../logs/restic.log"

echo -e "${CYAN}${BOLD}LESSON 7: Ultimate Disaster Recovery${NC}"
echo "------------------------------------------------"
echo "Your server exploded. You have a fresh machine and your repo backup."
echo "Let's simulate a 'cold' restore."
echo ""

# 1. Simulate failure
echo -e "${RED}SIMULATING DISASTER:${NC} Wiping all data..."
rm -rf ../../data/*

# 2. Simulate "new" restic container by ensuring we can still connect to repo
echo -e "Wait, the repo is still in ./repo. In a real disaster, you'd pull this from S3."
echo ""

echo -e "${BOLD}COMMAND TO LEARN:${NC}"
echo -e "restic restore latest --target /"
echo ""

echo -e "${BOLD}EXECUTING RECOVERY:${NC}"
echo "$(date) [SCENARIO-07] restic restore latest --target /" >> "$LOG_FILE"

docker exec restic-playground restic restore latest --target / >> "$LOG_FILE" 2>&1

echo -e "${GREEN}SUCCESS: Recovery complete!${NC}"
echo "Even with a totally empty data directory, Restic rebuilt your world."
echo ""
echo "Congratulations! You have completed the Restic Playground."
