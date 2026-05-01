#!/bin/bash

# Colors for UI
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}"
echo -e "${RED}!!! WARNING: WIPE RESTIC REPOSITORY    !!!${NC}"
echo -e "${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${NC}"
echo "This will COMPLETELY DELETE your Restic repository and all backups."
echo "Use this ONLY if you want to start from scratch or simulate a total repo loss."
echo ""
echo -n "Type 'DELETE' to confirm: "
read -r answer

if [ "$answer" = "DELETE" ]; then
    echo "Wiping ./repo..."
    rm -rf ./repo/*
    rm -rf ./repo/.??* # Catch hidden files
    echo "Repository wiped."
else
    echo "Aborted."
fi
