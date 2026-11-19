#!/bin/bash
# Verify all homelab endpoints

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check() {
    local name=$1
    local url=$2
    local expected=$3

    code=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 10 2>/dev/null || echo "000")

    if [[ "$code" == "$expected" ]]; then
        echo -e "${GREEN}✓${NC} $name: $code"
    else
        echo -e "${RED}✗${NC} $name: got $code, expected $expected"
    fi
}

echo "=== Homelab Endpoint Verification ==="
echo ""

check "bunnybox.dtrh.net redirect" "https://bunnybox.dtrh.net/" "301"
check "app.dtrh.net redirect" "https://app.dtrh.net/" "301"
check "app.dtrh.net/pentest" "https://app.dtrh.net/pentest/" "200"
check "Cloudflare Access" "https://dtrhnet.cloudflareaccess.com/" "200"

echo ""
echo "=== DNS Verification ==="
dig +short bunnybox.dtrh.net @1.1.1.1 | head -1
dig +short app.dtrh.net @1.1.1.1 | head -1