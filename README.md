# homelab

> **dtrh.net Homelab Infrastructure Repository**  
> Raspberry Pi 5B • Debian 12 • Yunohost • Cloudflare Tunnel • BunnyBox Launcher

```
homelab/
├── README.md                    # This file
├── ROADMAP.md                   # Complete implementation roadmap & log
├── CHANGELOG.md                 # Infrastructure changelog
├── launcher/                    # BunnyBox Launcher (GitHub Pages ready)
│   ├── index.html
│   ├── manifest.json
│   ├── README.md
│   ├── CHANGELOG.md
│   ├── css/bunnybox.css
│   ├── js/launcher.js
│   └── assets/
│       ├── icons/               # 8 SVG icons (cyan #00F0FF)
│       ├── logo/                # Logo suite (32-512px + JPG)
│       └── images/              # Preview screenshot
├── configs/                     # All service configurations
│   ├── nginx/                   # Nginx site configs & path-strip proxies
│   │   ├── *.conf               # Domain configs (bunnybox, app, lab, etc.)
│   │   ├── pentest-strip.conf   # /pentest/ path stripping → 8080
│   │   ├── bunnybox-redirect.conf
│   │   ├── app-landing.conf
│   │   └── conf.d/              # Yunohost-generated includes
│   ├── cloudflared/             # Cloudflare Tunnel configs
│   │   ├── config.yml           # Ingress rules (v7)
│   │   ├── config.yml.bak       # Previous config
│   │   ├── token                # Tunnel token
│   │   └── c7ec7205-d780-4715-bb05-a15149dcffd3.json  # Credentials
│   ├── yunohost/                # Yunohost configs & certs
│   │   ├── settings.yml
│   │   ├── domains/
│   │   ├── certs/               # Self-signed & LE certs per domain
│   │   └── apps/                # App manifests
│   └── dns/                     # Cloudflare DNS records
│       ├── records.json         # Full zone export
│       └── export_dns.py        # Export script
├── assets/                      # Static assets
│   └── bunnybox/                # Original asset pack
│       ├── launcher.jpg
│       └── bunnybox-assets/     # CSS, icons, logos, demo
└── scripts/                     # Utility scripts
    └── (to be added)
```

---

## Infrastructure Summary

| Component | Status | Details |
|-----------|--------|---------|
| **Hostname** | ✅ | `bunnybox.local` |
| **bunnybox.dtrh.net** | ✅ | 301 → `dtrhnet.cloudflareaccess.com` |
| **app.dtrh.net** | ✅ | Tunnel entry point (path routing) |
| **app.dtrh.net/pentest** | ✅ | Pentest Harness (nginx :8081 → :8080) |
| **app.dtrh.net/** | ✅ | 301 → Yunohost SSO |
| **Cloudflare Tunnel** | ✅ | `app-dtrh` (4 healthy QUIC connections) |
| **Cloudflare Access** | ✅ | Bypass policies for 3 entry points |
| **BunnyBox Launcher** | ✅ | GitHub-ready at `launcher/` |

---

## Quick Start

### Deploy Launcher
```bash
cd launcher
python3 -m http.server 8080
# Open http://localhost:8080
# Deploy to GitHub Pages / Netlify / Vercel
# Configure custom domain: bunnybox.dtrh.net or launcher.dtrh.net
```

### Verify Infrastructure
```bash
# External endpoints
curl -I https://bunnybox.dtrh.net/      # → 301 to cloudflareaccess
curl -I https://app.dtrh.net/           # → 301 to /yunohost
curl -s https://app.dtrh.net/pentest/   # → Pentest Harness HTML

# Tunnel status
cloudflared tunnel info c7ec7205-d780-4715-bb05-a15149dcffd3
```

---

## Architecture

```
Internet
    │
    ├─→ bunnybox.dtrh.net (proxied CNAME)
    │       └─→ Cloudflare Tunnel (app-dtrh)
    │               └─→ nginx :8082 → 301 → dtrhnet.cloudflareaccess.com
    │
    ├─→ app.dtrh.net (proxied CNAME)
    │       └─→ Cloudflare Tunnel (app-dtrh)
    │               ├─→ /pentest/* → nginx :8081 (strips /pentest) → :8080 Pentest Harness
    │               └─→ /* → nginx :8083 → 301 → /yunohost
    │
    └─→ *.dtrh.net (other services, Vercel, etc.)
```

### Cloudflare Tunnel Ingress (v7)
```yaml
ingress:
  - hostname: bunnybox.dtrh.net
    service: http://localhost:8082
  - hostname: app.dtrh.net
    path: /pentest/*
    service: http://localhost:8081
  - hostname: app.dtrh.net
    service: http://localhost:8083
  - service: http_status:404
```

### Nginx Proxies
| Port | Purpose | Config |
|------|---------|--------|
| 8080 | Pentest Harness (node) | — |
| 8081 | Path strip `/pentest/` → 8080 | `pentest-strip.conf` |
| 8082 | Redirect bunnybox → cloudflareaccess | `bunnybox-redirect.conf` |
| 8083 | Redirect app.dtrh.net/ → /yunohost | `app-landing.conf` |

---

## Cloudflare Access Bypass Policies

| App | Domain | Policy |
|-----|--------|--------|
| bunnybox-redirect | bunnybox.dtrh.net | Bypass (everyone) |
| app-dtrh-pentest | app.dtrh.net/pentest | Bypass (everyone) |
| app-dtrh-root | app.dtrh.net | Bypass (everyone) |

---

## Repository Management

```bash
# Add new service to launcher
# Edit launcher/js/launcher.js → APPS array

# Update nginx path-strip for new app
# 1. Create new proxy on new port (e.g., 8084)
# 2. Add ingress rule to cloudflared/config.yml
# 3. Push config: cloudflared tunnel ingress validate && push via API
# 4. Restart cloudflared

# Add Cloudflare Access bypass
# Use export_dns.py pattern or Cloudflare dashboard
```

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `configs/cloudflared/config.yml` | Tunnel ingress rules |
| `configs/cloudflared/c7ec7205-*.json` | Tunnel credentials (keep secret!) |
| `configs/nginx/pentest-strip.conf` | Path stripping proxy |
| `configs/nginx/bunnybox-redirect.conf` | bunnybox.dtrh.net redirect |
| `configs/nginx/app-landing.conf` | app.dtrh.net root redirect |
| `launcher/js/launcher.js` | Launcher app definitions |
| `configs/dns/records.json` | DNS records backup |
| `launcher/assets/icons/*.svg` | Service icons |

---

## Credits

- **BunnyBox Launcher**: Custom dark theme (Pure Black #050505 + Cyan #00F0FF)
- **Icons**: Custom SVG set (pentest, lab, vault, tunnel, monitoring, core, rabbit, settings)
- **Infrastructure**: Yunohost + Cloudflare Tunnel + Nginx on Raspberry Pi 5B
- **Pentest Harness**: Autonomous offensive-security agent harness