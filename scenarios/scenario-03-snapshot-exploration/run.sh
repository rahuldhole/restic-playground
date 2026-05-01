#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}LESSON 3: Snapshot Exploration${NC}"
echo "------------------------------------------------"
echo "Backup is done. But what's inside? How do we see changes?"
echo ""
echo -e "${BOLD}COMMANDS TO LEARN:${NC}"
echo -e "restic snapshots"
echo -e "restic ls <snapshot-id>"
echo -e "restic diff <id1> <id2>"
echo ""

echo -e "${BOLD}LISTING SNAPSHOTS:${NC}"
docker exec restic-playground restic snapshots

echo ""
echo -e "${BOLD}LATEST SNAPSHOT CONTENTS:${NC}"
LATEST_ID=$(docker exec restic-playground restic snapshots --json | grep -oE '"id":"[0-9a-f]+"' | head -1 | cut -d'"' -f4)
docker exec restic-playground restic ls "$LATEST_ID" | head -n 10
echo "... (showing first 10 files)"

echo ""
echo -e "${GREEN}SUCCESS: You've explored the repo!${NC}"
echo "Restic treats snapshots as immutable views of your data."
echo ""
echo "Next: run 'make scenario-4' to restore a single file."
