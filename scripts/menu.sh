#!/bin/bash

# Colors
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

show_menu() {
    clear
    echo -e "${CYAN}${BOLD}=== Restic Playground: Learning Menu ===${NC}"
    echo "1) Scenario 1: Initialize Repository"
    echo "2) Scenario 2: First Backup"
    echo "3) Scenario 3: Snapshot Exploration"
    echo "4) Scenario 4: Restore Single File"
    echo "5) Scenario 5: Full System Restore"
    echo "6) Scenario 6: Retention & Pruning"
    echo "7) Scenario 7: Disaster Recovery"
    echo "----------------------------------------"
    echo "s) Show Status"
    echo "r) Reset Data"
    echo "w) Wipe Repository (DANGER)"
    echo "q) Quit"
    echo ""
    echo -n "Choose an option: "
}

while true; do
    show_menu
    read -r opt
    case $opt in
        1) task scenario-1 ; read -p "Press enter to continue..." ;;
        2) task scenario-2 ; read -p "Press enter to continue..." ;;
        3) task scenario-3 ; read -p "Press enter to continue..." ;;
        4) task scenario-4 ; read -p "Press enter to continue..." ;;
        5) task scenario-5 ; read -p "Press enter to continue..." ;;
        6) task scenario-6 ; read -p "Press enter to continue..." ;;
        7) task scenario-7 ; read -p "Press enter to continue..." ;;
        s) task status ; read -p "Press enter to continue..." ;;
        r) task reset ; read -p "Press enter to continue..." ;;
        w) task wipe ; read -p "Press enter to continue..." ;;
        q) exit 0 ;;
        *) echo "Invalid option" ; sleep 1 ;;
    esac
done
