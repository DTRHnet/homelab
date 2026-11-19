# Homelab Infrastructure Roadmap: bunnybox.dtrh.net / app.dtrh.net - COMPLETED

## Final Status: ✅ ALL PRIMARY OBJECTIVES ACHIEVED

### Target Architecture Achieved
```
bunnybox.dtrh.net     → CNAME to dtrhnet.cloudflareaccess.com (HTTP 301 redirect) ✅
app.dtrh.net          → Cloudflare Tunnel entry point (path-based routing) ✅
app.dtrh.net/pentest  → Pentest Harness (via tunnel -> nginx:8081 -> port 8080) ✅
app.dtrh.net/         → Redirects to Yunohost SSO (/yunohost) ✅
bunnybox.local        → Local hostname for LAN access ✅
```

## Phase Summary

### Phase 1: Hostname & Local DNS ✅ COMPLETE
- [x] Hostname changed from `dtrh.net` to `bunnybox.local`
- [x] Updated `/etc/hostname` and `/etc/hosts`
- [x] Yunohost domain updated: removed `dtrhnet-homelab.local`, added `bunnybox.local`
- [x] Self-signed SSL cert generated for `bunnybox.local`
- [x] Services restarted: nginx, yunohost-api

### Phase 2: Cloudflare DNS Records ✅ COMPLETE
- [x] `bunnybox.dtrh.net` → CNAME to `dtrhnet.cloudflareaccess.com` (proxied)
- [x] `app.dtrh.net` → CNAME to tunnel `c7ec7205-d780-4715-bb05-a15149dcffd3.cfargotunnel.com` (proxied)
- [x] Verified DNS propagation via `dig @1.1.1.1`

### Phase 3: Cloudflare Tunnel Reconfiguration ✅ COMPLETE
- [x] Created new tunnel `app-dtrh` (ID: `c7ec7205-d780-4715-bb05-a15149dcffd3`)
- [x] Credentials stored at `/etc/cloudflared/c7ec7205-d780-4715-bb05-a15149dcffd3.json`
- [x] Tunnel ingress rules configured (version 7):
  ```
  1. bunnybox.dtrh.net          → http://localhost:8082 (redirect to cloudflareaccess)
  2. app.dtrh.net/pentest/*     → http://localhost:8081 (strips /pentest prefix)
  3. app.dtrh.net               → http://localhost:8083 (redirect to Yunohost SSO)
  4. catch-all                  → HTTP 404
  ```
- [x] Tunnel DNS routing: `cloudflared tunnel route dns app-dtrh app.dtrh.net`
- [x] Tunnel service running with 4 active connections (QUIC)
- [x] Cloudflare Access applications created for bypass policies:
  - `bunnybox-redirect` for `bunnybox.dtrh.net`
  - `app-dtrh-pentest` for `app.dtrh.net/pentest`
  - `app-dtrh-root` for `app.dtrh.net`

### Phase 4: Nginx & Yunohost Reconfiguration ✅ COMPLETE
- [x] Added `bunnybox.dtrh.net` to Yunohost domains
- [x] Added `app.dtrh.net` to Yunohost domains
- [x] Created nginx path-stripping proxy on port 8081 for `/pentest/` → `http://localhost:8080`
- [x] Created nginx redirect on port 8082 for `bunnybox.dtrh.net` → `dtrhnet.cloudflareaccess.com`
- [x] Created nginx redirect on port 8083 for `app.dtrh.net` → `yunohost SSO`
- [x] Removed old domains: `dtrhnet-homelab.local` from Yunohost
- [x] Kept `dtrh.net`, `lab.dtrh.net`, `pentest.lab.dtrh.net` for existing services

### Phase 5: Testing & Verification ✅ COMPLETE

#### External Testing
| Endpoint | Expected | Actual | Status |
|----------|----------|--------|--------|
| `https://bunnybox.dtrh.net/` | 301 → dtrhnet.cloudflareaccess.com | 301 Location: https://dtrhnet.cloudflareaccess.com/ | ✅ |
| `https://app.dtrh.net/` | 301 → Yunohost SSO | 301 Location: https://app.dtrh.net/yunohost | ✅ |
| `https://app.dtrh.net/pentest/` | Pentest Harness UI | HTML with "Pentest Harness" title | ✅ |

#### Local Testing (LAN)
| Endpoint | Expected | Actual | Status |
|----------|----------|--------|--------|
| `https://bunnybox.local/` | Yunohost SSO | 302 to SSO | ✅ |
| `http://localhost:8080/` | Pentest Harness | HTML loads | ✅ |
| `http://localhost:8081/pentest/` | Stripped path | HTML loads | ✅ |
| `http://localhost:8082/` | Redirect | 301 to cloudflareaccess | ✅ |
| `http://localhost:8083/` | Redirect | 301 to /yunohost | ✅ |

#### DNS Verification
```bash
dig +short bunnybox.dtrh.net @1.1.1.1  # → 172.64.80.1 (Cloudflare proxy)
dig +short app.dtrh.net @1.1.1.1       # → 172.64.80.1 (Cloudflare proxy)
```

#### Tunnel Health
```bash
cloudflared tunnel info c7ec7205-d780-4715-bb05-a15149dcffd3
# Status: healthy, 4 active connections (yyz03, yyz04, yyz06)
```

### Phase 6: Cleanup & Documentation ✅ COMPLETE

### Removed/Deprecated
- Old tunnel `lab` (ID: `600e2eba-fcc1-4541-b485-3c7c553e2d50`) - no active connections
- Yunohost domain `dtrhnet-homelab.local` removed
- Old cloudflared service config pointing to old tunnel

### Documentation
- Tunnel ID: `c7ec7205-d780-4715-bb05-a15149dcffd3`
- Credentials: `/etc/cloudflared/c7ec7205-d780-4715-bb05-a15149dcffd3.json`
- Config: `/etc/cloudflared/config.yml` (version 7)
- Nginx path-strip: `/etc/nginx/conf.d/pentest-strip.conf` (port 8081)
- Nginx redirects: `/etc/nginx/conf.d/bunnybox-redirect.conf` (port 8082), `/etc/nginx/conf.d/app-landing.conf` (port 8083)
- Cloudflare Access apps: `bunnybox-redirect`, `app-dtrh-pentest`, `app-dtrh-root`

## Phase 7: BunnyBox Launcher Development ✅ COMPLETE

### Created: `/home/kali/homelab/bunnybox-launcher/` (GitHub-ready repository)

#### Repository Structure
```
bunnybox-launcher/
├── index.html              # Main launcher page
├── manifest.json           # PWA manifest
├── README.md               # Documentation
├── CHANGELOG.md            # Version history
├── css/
│   └── bunnybox.css        # Full theme (CSS custom properties)
├── js/
│   └── launcher.js         # App rendering, search, clock, activity
├── assets/
│   ├── icons/              # 8 SVG icons (cyan #00F0FF)
│   │   ├── icon-pentest.svg
│   │   ├── icon-lab.svg
│   │   ├── icon-vault.svg
│   │   ├── icon-tunnel.svg
│   │   ├── icon-monitoring.svg
│   │   ├── icon-core.svg
│   │   ├── icon-rabbit.svg
│   │   └── icon-settings.svg
│   ├── logo/
│   │   ├── bunnybox-logo.jpg       # Original high-res
│   │   ├── bunnybox-logo-512.png
│   │   ├── bunnybox-logo-192.png
│   │   ├── bunnybox-logo-64.png
│   │   └── bunnybox-logo-32.png    # Favicon
│   └── images/
│       └── launcher.jpg            # Preview screenshot
```

#### Launcher Features
- **Theme**: Pure Black (`#050505`) + Cyan (`#00F0FF`) aesthetic
- **Typography**: Inter for UI, JetBrains Mono for technical data
- **Responsive card grid** with hover lift + cyan glow effects
- **Real-time UTC clock** in header
- **Search/filter** (title, description, category) — keyboard accessible (`/`, `Esc`)
- **Activity feed** with timestamps
- **System integrity footer** section
- **PWA manifest** for installable experience
- **Dynamic SVG icon loading** from `assets/icons/`
- **Category tagging** for future filtering

#### Integrated Services (8 cards)
| Service | URL | Icon | Status |
|---------|-----|------|--------|
| Pentest Harness | `https://app.dtrh.net/pentest/` | icon-pentest.svg | 🟢 Running |
| Yunohost SSO | `https://app.dtrh.net/yunohost` | icon-core.svg | 🟢 Running |
| Cloudflare Access | `https://dtrhnet.cloudflareaccess.com` | icon-tunnel.svg | 🟢 Running |
| BunnyBox Local | `https://bunnybox.local` | icon-rabbit.svg | 🟢 Running |
| Vault | `https://app.dtrh.net/vault` | icon-vault.svg | 🔒 Locked |
| Monitoring | `https://app.dtrh.net/monitoring` | icon-monitoring.svg | 🟢 Running |
| Exploit Lab | `https://lab.dtrh.net` | icon-lab.svg | 🟢 Running |
| Settings | (internal) | icon-settings.svg | ⚪ Idle |

#### Verified Working
- Static server test (Python http.server on port 8084)
- All assets load: CSS, JS, SVG icons, PNG logos, manifest.json
- Search filtering works client-side
- Keyboard shortcuts functional
- Cards render with correct icons and links

---

## Known Limitations / Future Work

1. **Let's Encrypt certificates** for `bunnybox.dtrh.net` and `app.dtrh.net` not installed (blocked by Cloudflare proxy during ACME challenge). Using self-signed certs locally; tunnel uses `noTLSVerify: true`.

2. **Old domains** `lab.dtrh.net` and `pentest.lab.dtrh.net` still exist in Yunohost and Cloudflare DNS. Can be removed if no longer needed.

3. **Path-based routing** for future apps: Add new ingress rules to tunnel config and corresponding nginx path-strip proxies on new ports.

4. **Monitoring**: Cloudflare tunnel metrics available at `http://localhost:20241/metrics`

5. **Launcher v1.1.0** — Dynamic status via API health checks
6. **Launcher v1.2.0** — Personalization (drag-reorder, preferences)
7. **Launcher v1.3.0** — Integration (Yunohost auto-discovery, Tunnel status API)

---

## Commands for Future Management

```bash
# Check tunnel status
cloudflared tunnel info c7ec7205-d780-4715-bb05-a15149dcffd3

# View tunnel config
cloudflared tunnel ingress validate --config /etc/cloudflared/config.yml

# Test rule matching
cloudflared --config /etc/cloudflared/config.yml tunnel ingress rule https://app.dtrh.net/pentest/

# Restart tunnel
systemctl restart cloudflared

# Check metrics
curl http://localhost:20241/metrics

# View nginx configs
ls /etc/nginx/conf.d/*pentest* /etc/nginx/conf.d/*bunnybox* /etc/nginx/conf.d/*app-landing*

# Check Access apps
cf access apps list (via API)

# Serve launcher locally
cd /home/kali/homelab/bunnybox-launcher && python3 -m http.server 8084
```

---

## Log of Changes

- **2026-11-19 10:26 UTC**: Phase 1 complete - hostname changed to `bunnybox.local`, Yunohost domain updated
- **2026-11-19 10:27 UTC**: Phase 2 complete - DNS records created for `bunnybox.dtrh.net` and `app.dtrh.net`
- **2026-11-19 10:27 UTC**: Phase 3 started - new tunnel `app-dtrh` created
- **2026-11-19 10:28 UTC**: Tunnel DNS routing configured, cloudflared service updated
- **2026-11-19 10:28-10:33 UTC**: Tunnel config iterations, debugging origin connection issues
- **2026-11-19 10:33 UTC**: Cloudflare Access apps created for bypass policies
- **2026-11-19 10:37 UTC**: Tunnel config pushed via API (version 2), cloudflared restarted
- **2026-11-19 10:41 UTC**: Nginx path-stripping proxy (port 8081) created for `/pentest/`
- **2026-11-19 10:44 UTC**: Nginx redirect (port 8082) created for `bunnybox.dtrh.net`
- **2026-11-19 10:44 UTC**: Tunnel config updated with bunnybox rule (version 3-5)
- **2026-11-19 10:46 UTC**: Cloudflare Access apps created for `bunnybox.dtrh.net` and `app.dtrh.net/pentest`
- **2026-11-19 10:47 UTC**: `bunnybox.dtrh.net` redirect working (301 to cloudflareaccess)
- **2026-11-19 10:49 UTC**: `app.dtrh.net` added to Yunohost, Access app created for root
- **2026-11-19 10:50 UTC**: Nginx landing page (port 8083) created for `app.dtrh.net` root redirect
- **2026-11-19 10:51 UTC**: All endpoints verified working ✅
- **2026-11-19 11:00 UTC**: Phase 7 complete - BunnyBox Launcher repository created at `/home/kali/homelab/bunnybox-launcher/`