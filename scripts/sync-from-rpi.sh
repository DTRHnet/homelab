#!/bin/bash
# Sync configs from RPi to local repository

set -e

RPI_HOST="root@192.168.86.28"
REPO_ROOT="/home/kali/homelab"

echo "=== Syncing configs from RPi ==="

# Nginx configs
echo "Syncing nginx..."
rsync -avz --delete \
    -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    "$RPI_HOST:/etc/nginx/conf.d/" "$REPO_ROOT/configs/nginx/" \
    --exclude='*.d/*.conf' 2>/dev/null || true

# Also get .d directories
rsync -avz \
    -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    "$RPI_HOST:/etc/nginx/conf.d/*.d/" "$REPO_ROOT/configs/nginx/conf.d/" 2>/dev/null || true

# Cloudflared configs
echo "Syncing cloudflared..."
rsync -avz \
    -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    "$RPI_HOST:/etc/cloudflared/" "$REPO_ROOT/configs/cloudflared/"

# Yunohost configs (excluding certs/keys for security)
echo "Syncing yunohost (configs only)..."
rsync -avz \
    -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    --exclude='certs/**/*.pem' \
    --exclude='*.pem' \
    --exclude='*.key' \
    --exclude='.ssowat_cookie_secret' \
    --exclude='.admin_cookie_secret' \
    "$RPI_HOST:/etc/yunohost/" "$REPO_ROOT/configs/yunohost/"

echo "=== Sync complete ==="
echo "Review changes: git diff"