#!/bin/bash

# Configuration variables (change these for each app)
APP_NAME="searxng"  # Name of the app (used for service, config files, etc.)
APP_URL="https://app.dtrh.net/searxng/"  # URL for the app (used in launcher.js)
APP_PORT=8085  # Port where the app is listening (nginx will proxy to this)
APP_SERVICE_NAME="searxng"  # systemd service name
APP_NGINX_CONF="/etc/nginx/conf.d/${APP_NAME}-strip.conf"  # Path to nginx config file
APP_TUNNEL_INGRESS="/searxng/*"  # Cloudflare tunnel ingress pattern
APP_ICON_PATH="/home/kali/homelab/launcher/icons/${APP_NAME}.svg"  # Path to icon in launcher.js
APP_README_SECTION="## ${APP_NAME^} Service"  # Section header in README

# Paths
LAUNCHER_JS="/home/kali/homelab/launcher/js/launcher.js"
README_FILE="/home/kali/homelab/launcher/README.md"
NGINX_CONF_DIR="/etc/nginx/conf.d"
CLOUDFLARED_CONFIG="/etc/cloudflared/config.yml"

# Functions
configure_nginx() {
  echo "Configuring nginx for ${APP_NAME}..."
  # Create nginx config if it doesn't exist
  if [ ! -f "${APP_NGINX_CONF}" ]; then
    cat > "${APP_NGINX_CONF}" <<EOF
server {
    listen 80;
    server_name ${APP_NAME}.dtrh.net;

    location / {
        proxy_pass http://localhost:${APP_PORT};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
    echo "Nginx config created at ${APP_NGINX_CONF}"
  else
    echo "Nginx config already exists at ${APP_NGINX_CONF}"
  fi
}

configure_cloudflare() {
  echo "Configuring Cloudflare tunnel for ${APP_NAME}..."
  # Update cloudflared config to add ingress rule
  # Check if the ingress rule already exists
  if ! grep -q "${APP_TUNNEL_INGRESS}" "${CLOUDFLARED_CONFIG}"; then
    # Add ingress rule
    # This is a simplified example; actual implementation may need to be more robust
    # We assume the config has a 'ingress' section
    # For simplicity, we'll append the rule to the config file
    echo "  - path: ${APP_TUNNEL_INGRESS}" >> "${CLOUDFLARED_CONFIG}"
    echo "    service: http_status:404" >> "${CLOUDFLARED_CONFIG}"
    echo "    originRequest: localhost:${APP_PORT}" >> "${CLOUDFLARED_CONFIG}"
    echo "Cloudflare config updated."
  else
    echo "Cloudflare ingress rule already exists for ${APP_NAME}."
  fi
}

update_launcher() {
  echo "Updating launcher.js for ${APP_NAME}..."
  # Use a more robust method to update the JSON file
  # We'll use jq if available, or a simple sed approach if not
  # Check if jq is installed
  if command -v jq >/dev/null 2>&1; then
    # Use jq to update the JSON
    # This is a simplified example; actual implementation may need to be more robust
    # We assume the APPS array is in the JSON file
    # Extract the current APPS array, modify it, and write back
    # This is a placeholder; actual implementation may need to be more robust
    # For simplicity, we'll append a new entry if it doesn't exist
    if ! grep -q "\"${APP_NAME}\"" "${LAUNCHER_JS}"; then
      # Append new entry
      echo "  - name: ${APP_NAME}" >> "${LAUNCHER_JS}"
      echo "  - url: ${APP_URL}" >> "${LAUNCHER_JS}"
      echo "  - icon: ${APP_ICON_PATH}" >> "${LAUNCHER_JS}"
      echo "  - status: monitoring" >> "${LAUNCHER_JS}"
      echo "Launcher.js updated."
    else
      echo "Launcher entry for ${APP_NAME} already exists."
    fi
  else
    # Simple sed approach (may break JSON structure)
    # Remove existing entry
    sed -i "/${APP_NAME}/d" "${LAUNCHER_JS}"
    # Append new entry
    echo "  - name: ${APP_NAME}" >> "${LAUNCHER_JS}"
    echo "  - url: ${APP_URL}" >> "${LAUNCHER_JS}"
    echo "  - icon: ${APP_ICON_PATH}" >> "${LAUNCHER_JS}"
    echo "  - status: monitoring" >> "${LAUNCHER_JS}"
    echo "Launcher.js updated."
  fi
}

update_readme() {
  echo "Updating README.md for ${APP_NAME}..."
  # Check if the section already exists
  if ! grep -q "${APP_README_SECTION}" "${README_FILE}"; then
    # Append new section
    echo -e "\n${APP_README_SECTION}" >> "${README_FILE}"
    echo "  - Service: ${APP_SERVICE_NAME}" >> "${README_FILE}"
    echo "  - URL: ${APP_URL}" >> "${README_FILE}"
    echo "  - Status: Running" >> "${README_FILE}"
    echo "README.md updated."
  else
    echo "README section for ${APP_NAME} already exists."
  fi
}

enable_service() {
  echo "Enabling systemd service ${APP_SERVICE_NAME}..."
  # Create systemd service file if it doesn't exist
  if [ ! -f "/etc/systemd/system/${APP_SERVICE_NAME}.service" ]; then
    cat > "/etc/systemd/system/${APP_SERVICE_NAME}.service" <<EOF
[Unit]
Description=${APP_NAME^} Service
After=network.target

[Service]
ExecStart=/usr/bin/${APP_NAME} --config /etc/${APP_NAME}.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable ${APP_SERVICE_NAME}
    systemctl start ${APP_SERVICE_NAME}
    echo "Systemd service enabled and started."
  else
    echo "Systemd service file already exists for ${APP_SERVICE_NAME}."
  fi
}

main() {
  configure_nginx
  configure_cloudflare
  update_launcher
  update_readme
  enable_service
  echo "Setup for ${APP_NAME} is complete."
}

# Run main
main "$@"