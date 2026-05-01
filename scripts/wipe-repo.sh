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
    echo "Wiping ./minio_data..."
    # Using docker to wipe to avoid permission issues with minio-created files
    docker run --rm -v $(pwd)/minio_data:/data alpine sh -c "rm -rf /data/* /data/.* 2>/dev/null || true"
    echo "S3 Repository wiped."
else
    echo "Aborted."
fi
