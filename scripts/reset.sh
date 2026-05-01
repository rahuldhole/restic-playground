#!/bin/bash

# Colors for UI
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}!!! SAFETY LAYER: RESET DATA !!!${NC}"
echo "This will wipe all data in the ./data directory."
echo "The Restic repository on S3 storage will remain intact."
echo -n "Are you sure? (y/n) "
read -r answer

if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "Wiping ./data..."
    rm -rf ./data/*
    echo -e "${YELLOW}Data wiped. Data generator will recreate base files in a few seconds.${NC}"
else
    echo "Aborted."
fi
