# Changelog

All notable changes to the BunnyBox Launcher project.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Initial launcher page with dark minimal theme (Pure Black + Cyan)
- Responsive app grid with hover lift + cyan glow effects
- Real-time UTC clock in header
- Search/filter functionality (title, description, category)
- Keyboard shortcuts (`/` to search, `Esc` to clear)
- Activity feed with timestamps
- System integrity footer section
- PWA manifest for installable experience
- SVG icon system loaded dynamically from assets
- Category tagging for future filtering

### Infrastructure
- Configured for Cloudflare Tunnel `app-dtrh` integration
- Path-based routing for `app.dtrh.net/*` services
- BunnyBox local hostname (`bunnybox.local`) support
- Cloudflare Access bypass policies documented

---

## [1.0.0] - 2026-11-19

### Added
- **Core Theme**: Pure black (`#050505`) background with cyan (`#00F0FF`) accent
- **Typography**: Inter for UI, JetBrains Mono for technical data
- **Components**:
  - Header with brand, status dot, live clock
  - "Access Granted" banner with glow effect
  - Search input with inline SVG magnifying glass
  - Responsive card grid (auto-fill, minmax 220px)
  - App cards: icon, title, description, status badge, uptime
  - Footer: system integrity + recent activity log
- **Assets**:
  - 8 SVG icons (pentest, lab, vault, tunnel, monitoring, core, rabbit, settings)
  - Logo suite (32, 64, 192, 512px + original JPG)
  - Preview screenshot (`launcher.jpg`)
- **CSS Architecture**:
  - CSS custom properties for all colors/spacing/timing
  - Fluid responsive breakpoints (700px mobile)
  - Backdrop-filter header blur
  - Smooth transitions (180ms cubic-bezier)
  - Hover states: lift (-3px), border glow, gradient overlay

### Infrastructure (Parallel Work)
- Hostname changed: `dtrh.net` → `bunnybox.local`
- Cloudflare Tunnel `app-dtrh` created (4 healthy connections)
- DNS records:
  - `bunnybox.dtrh.net` → 301 to `dtrhnet.cloudflareaccess.com`
  - `app.dtrh.net` → tunnel ingress with path-based routing
- Nginx proxies:
  - Port 8081: `/pentest/` path strip → Pentest Harness (8080)
  - Port 8082: `bunnybox.dtrh.net` redirect
  - Port 8083: `app.dtrh.net` root → Yunohost SSO
- Cloudflare Access apps with bypass policies

---

## Version History Convention

| Version | Meaning |
|---------|---------|
| MAJOR   | Breaking changes (API, structure, config format) |
| MINOR   | New features, new services, UI additions |
| PATCH   | Bug fixes, typo corrections, minor tweaks |

---

## Upcoming (Roadmap)

### v1.1.0 — Dynamic Status
- [ ] Real-time service health checks via API
- [ ] WebSocket live status updates
- [ ] Uptime counters from actual service metrics

### v1.2.0 — Personalization
- [ ] User preferences (localStorage): theme density, compact mode
- [ ] Drag-to-reorder cards
- [ ] Custom bookmarks/quick links section

### v1.3.0 — Integration
- [ ] Yunohost app auto-discovery
- [ ] Cloudflare Tunnel status API integration
- [ ] Pentest Harness session linking

### v2.0.0 — Multi-user
- [ ] Authentication via Cloudflare Access
- [ ] Role-based card visibility
- [ ] Per-user layouts