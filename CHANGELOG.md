# Infrastructure Changelog

All notable changes to the dtrh.net homelab infrastructure.

---

## [2026-11-19] - Major Restructure & BunnyBox Launcher

### Added
- **BunnyBox Launcher** (`launcher/`) — Dark minimal dashboard for all services
  - Pure Black (#050505) + Cyan (#00F0FF) theme
  - 8 service cards with live UTC clock, search, activity feed
  - PWA manifest, keyboard shortcuts, responsive grid
  - GitHub Pages / Netlify / Vercel deployable
- **Complete config backup** (`configs/`) — nginx, cloudflared, yunohost, DNS
- **Documentation** — README.md, ROADMAP.md, CHANGELOG.md
- **Asset organization** — launcher assets, original bunnybox pack

### Infrastructure (Parallel Work)
- Hostname: `dtrh.net` → `bunnybox.local`
- Cloudflare Tunnel `app-dtrh` created (4 QUIC connections)
- DNS: `bunnybox.dtrh.net` → 301 cloudflareaccess, `app.dtrh.net` → tunnel
- Nginx path-strip proxy (:8081) for `/pentest/` → Pentest Harness (:8080)
- Nginx redirects: bunnybox→cloudflareaccess, app→/yunohost
- Cloudflare Access bypass policies (3 apps)

---

## [2026-11-18] - Initial Tunnel Setup

### Added
- Cloudflare Tunnel `lab` (ID: `600e2eba-fcc1-4541-b485-3c7c553e2d50`)
- DNS: `lab.dtrh.net` → tunnel CNAME
- Cloudflare Access app for `lab.dtrh.net` with email domain policy
- Cloudflare Access bypass for `lab.dtrh.net/pentest`
- Pentest Harness installed on :8080

---

## [2026-03-06] - Yunohost Base Install

### Added
- Yunohost on Raspberry Pi 5B (Debian 12)
- Domain: `dtrh.net` (main), `dtrhnet-homelab.local`
- Self-signed certificates for all domains
- Chitchatter app installed on `dtrh.net/`
- Basic nginx + SSOwat configuration

---

## Version History Convention

| Version | Meaning |
|---------|---------|
| YYYY-MM-DD | Infrastructure milestone |
| launcher/vX.Y.Z | Launcher semantic version |

---

## Upcoming

### Infrastructure
- [ ] Let's Encrypt certs for `bunnybox.dtrh.net`, `app.dtrh.net` (requires DNS challenge or proxy pause)
- [ ] Remove deprecated domains: `lab.dtrh.net`, `pentest.lab.dtrh.net`, `dtrhnet-homelab.local`
- [ ] Add monitoring stack (Prometheus/Grafana) via new tunnel ingress
- [ ] Add Vault service on `app.dtrh.net/vault`

### Launcher v1.1.0
- [ ] Real-time service health checks via API
- [ ] WebSocket live status updates

### Launcher v1.2.0
- [ ] User preferences (localStorage)
- [ ] Drag-to-reorder cards
- [ ] Custom bookmarks section

### Launcher v2.0.0
- [ ] Cloudflare Access authentication
- [ ] Role-based card visibility
- [ ] Per-user layouts