## Infrastructure Integration

This launcher is designed to work with the dtrh.net homelab setup:

- **Cloudflare Tunnel** (`app-dtrh`, ID: `c7ec7205-d780-4715-bb05-a15149dcffd3`)
  - `app.dtrh.net/pentest/*` → `localhost:8081` (nginx path-strip) → `localhost:8080` (Pentest Harness)
  - `app.dtrh.net/searxng/*` → `localhost:8085` (nginx proxy) → `/run/searxng.sock` (SearXNG)
  - `app.dtrh.net` → `localhost:8083` (nginx redirect to Yunohost SSO)
  - `bunnybox.dtrh.net` → `localhost:8082` (nginx redirect to Cloudflare Access)

- **Cloudflare Access** bypass policies for:
  - `bunnybox.dtrh.net` (redirect)
  - `app.dtrh.net/pentest` (Pentest Harness)
  - `app.dtrh.net/searxng` (SearXNG)
  - `app.dtrh.net` (root)

- **Local DNS**: `bunnybox.local` via mDNS/Avahi