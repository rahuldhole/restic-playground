#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="../../logs/restic.log"

echo -e "${CYAN}${BOLD}LESSON 6: Retention and Pruning${NC}"
echo "------------------------------------------------"
echo "If we keep every snapshot forever, we run out of space."
echo "We need to 'forget' old snapshots and 'prune' the data."
echo ""

# Ensure we have a few snapshots
echo "Creating extra snapshots for demonstration..."
docker exec restic-playground restic backup /data > /dev/null 2>&1
docker exec restic-playground restic backup /data > /dev/null 2>&1

echo -e "${BOLD}COMMANDS TO LEARN:${NC}"
echo -e "restic forget --keep-last 1"
echo -e "restic prune"
echo ""

echo -e "${BOLD}EXECUTING FORGET:${NC} Keeping only the latest snapshot..."
echo "$(date) [SCENARIO-06] restic forget --keep-last 1 --prune" >> "$LOG_FILE"

docker exec restic-playground restic forget --keep-last 1 --prune >> "$LOG_FILE" 2>&1

echo -e "${GREEN}SUCCESS: Repository cleaned up!${NC}"
echo "Restic removed references to old snapshots and deleted unneeded data blobs."
echo "Check 'make status' to see the result."

echo ""
echo "Next: run 'make scenario-7' for the ultimate Disaster Recovery test."
