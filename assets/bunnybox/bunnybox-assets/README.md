# BunnyBox Homelab Launcher — Assets Pack

Dark minimal theme (Pure Black + Cyan) for **bunnybox.dtrh.net**

## Contents

```
bunnybox-assets/
├── logo/
│   ├── bunnybox-logo.jpg          # Original high-res
│   ├── bunnybox-logo-512.png
│   ├── bunnybox-logo-192.png
│   ├── bunnybox-logo-64.png
│   └── bunnybox-logo-32.png       # Favicon ready
├── icons/                         # SVG icons (cyan #00F0FF)
│   ├── icon-pentest.svg
│   ├── icon-lab.svg
│   ├── icon-vault.svg
│   ├── icon-tunnel.svg
│   ├── icon-monitoring.svg
│   ├── icon-core.svg
│   ├── icon-rabbit.svg
│   └── icon-settings.svg
├── css/
│   └── bunnybox.css               # Full theme
├── demo/
│   └── index.html                 # Working starter dashboard
└── README.md
```

## Quick Start

1. Open `demo/index.html` in a browser to see the full dashboard.
2. Copy `css/bunnybox.css` into your project.
3. Use the logo files and SVG icons as needed.

## Color Tokens

| Token            | Value                  | Usage                  |
|------------------|------------------------|------------------------|
| `--bb-bg`        | `#050505`              | Page background        |
| `--bb-bg-card`   | `#0d0d0d`              | Card surface           |
| `--bb-cyan`      | `#00F0FF`              | Primary accent         |
| `--bb-white`     | `#ffffff`              | Headings               |
| `--bb-text`      | `#e0e0e0`              | Body text              |
| `--bb-text-muted`| `#888888`              | Secondary text         |

## CSS Classes

- `.bb-app` – root container
- `.bb-header` / `.bb-brand` / `.bb-logo`
- `.bb-access` – “Access Granted” banner
- `.bb-search` – search input
- `.bb-grid` – responsive card grid
- `.bb-card` – individual app tile (with hover lift + glow)
- `.bb-status` – live status indicator
- `.bb-footer` – system integrity + activity

## Notes

- All icons are pure SVG and can be recolored via `stroke` / `fill`.
- The logo has a single cyan eye — keep that accent when using on dark backgrounds.
- Hover transitions are already tuned (lift + cyan glow).

---

**BunnyBox** · down the rabbit hole · dtrh.net
