#!/bin/bash
# Push Cloudflare Tunnel config via API
# Requires: CF_TOKEN env var or .cf_token file

set -e

TUNNEL_ID="c7ec7205-d780-4715-bb05-a15149dcffd3"
ACCOUNT_ID="371658f856fd542ba7225013ff396687"
CONFIG_FILE="${1:-/home/kali/homelab/configs/cloudflared/config.yml}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

# Get token
if [[ -n "$CF_TOKEN" ]]; then
    TOKEN="$CF_TOKEN"
elif [[ -f "$HOME/.cf_token" ]]; then
    TOKEN=$(cat "$HOME/.cf_token")
else
    echo "Set CF_TOKEN env var or create ~/.cf_token"
    exit 1
fi

# Parse YAML to JSON (requires yq)
if ! command -v yq &> /dev/null; then
    echo "yq required: https://github.com/mikefarah/yq"
    exit 1
fi

CONFIG_JSON=$(yq -o=json "$CONFIG_FILE" | jq '{config: .}')

echo "Pushing tunnel config..."
curl -s -X PUT \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$CONFIG_JSON" \
    "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/cfd_tunnel/$TUNNEL_ID/configurations" | jq .

echo "Done. Restart cloudflared on RPi: systemctl restart cloudflared"