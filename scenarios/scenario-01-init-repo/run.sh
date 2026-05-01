#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="logs/restic.log"

echo -e "${CYAN}${BOLD}LESSON 1: Initializing the Repository${NC}"
echo "------------------------------------------------"
echo "Before we can backup anything, we need a repository."
echo "Restic repositories are where your data is stored encrypted."
echo ""
echo -e "${BOLD}COMMAND TO LEARN:${NC}"
echo -e "restic init"
echo ""

# Check if repo is already initialized via restic itself
if docker exec restic-playground restic snapshots >/dev/null 2>&1; then
    echo "Looks like the S3 repository is already initialized."
    echo "If you want to re-run this lesson, use 'task wipe' first."
    exit 0
fi

echo -e "${BOLD}EXECUTING:${NC} Initializing repository on S3 (Minio)..."
# Log the command
echo "$(date) [SCENARIO-01] restic init" >> "$LOG_FILE"

# Execute
docker exec restic-playground restic init >> "$LOG_FILE" 2>&1

echo -e "${GREEN}SUCCESS: S3 Repository initialized!${NC}"
echo "Check logs/restic.log to see the output."
echo "Restic created the bucket structure in Minio."
echo ""
echo "Next: run 'task scenario-2' to take your first backup."
