#!/bin/bash

set -e

# Colors for UI
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="logs/restic.log"

echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}  LESSON 01: THE FOUNDATION - INITIALIZING THE REPO  ${NC}"
echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BOLD}📖 THE CONCEPT${NC}"
echo -e "Every Restic adventure begins with a ${BOLD}Repository${NC}. This is the encrypted"
echo -e "container (on S3, local, or SFTP) where your data chunks live."
echo -e "Restic uses a 'Content-Addressable' storage model, meaning everything"
echo -e "is deduplicated from the start."

echo -e "\n${BOLD}💻 THE COMMAND${NC}"
echo -e "${GREEN}restic init${NC}"
echo -e "This command creates the 'config' file and the directory structure"
echo -e "(data, index, snapshots, keys) needed to manage your backups."

echo -e "\n${BOLD}🚀 THE ACTION${NC}"

# Check if repo is already initialized via restic itself
if docker exec restic-playground restic snapshots >/dev/null 2>&1; then
    echo -e "${YELLOW}[!] Repository already exists on S3. Skipping initialization.${NC}"
    echo "    Use 'task wipe' if you want to start fresh."
else
    echo -e "Initializing repository in the S3 'playground' bucket..."
    echo "$(date) [SCENARIO-01] restic init" >> "$LOG_FILE"
    docker exec restic-playground restic init >> "$LOG_FILE" 2>&1
    echo -e "${GREEN}✔ Repository initialized successfully!${NC}"
fi

echo -e "\n${BOLD}🔍 VERIFICATION${NC}"
echo -e "1. Look at ${BOLD}logs/restic.log${NC} to see the encryption key generation."
echo -e "2. Restic has now created a 'config' object in your S3 bucket."

echo -e "\n${CYAN}Next Level: run 'task scenario-2' to capture your first data state.${NC}"
