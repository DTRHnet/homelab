/**
 * BunnyBox Launcher — Homelab Dashboard
 * Pure Black + Cyan aesthetic
 */

// ============================================================
// App Configuration — Edit this array to add/remove services
// ============================================================
const APPS = [
  {
    id: 'pentest-harness',
    title: 'Pentest Harness',
    desc: 'Autonomous offensive-security agent harness',
    url: 'https://app.dtrh.net/pentest/',
    icon: 'icon-pentest.svg',
    status: 'running',
    uptime: 'Live',
    category: 'offensive'
  },
  {
    id: 'yunohost-sso',
    title: 'Yunohost SSO',
    desc: 'Single sign-on and app portal',
    url: 'https://app.dtrh.net/yunohost',
    icon: 'icon-core.svg',
    status: 'running',
    uptime: 'Local',
    category: 'core'
  },
  {
    id: 'cloudflare-access',
    title: 'Cloudflare Access',
    desc: 'Zero Trust secure access dashboard',
    url: 'https://dtrhnet.cloudflareaccess.com',
    icon: 'icon-tunnel.svg',
    status: 'running',
    uptime: 'Cloud',
    category: 'network'
  },
  {
    id: 'bunnybox-local',
    title: 'BunnyBox Local',
    desc: 'LAN-only management interface',
    url: 'https://bunnybox.local',
    icon: 'icon-rabbit.svg',
    status: 'running',
    uptime: 'LAN',
    category: 'core'
  },
  {
    id: 'vault',
    title: 'Vault',
    desc: 'Credential and secret management',
    url: 'https://app.dtrh.net/vault',
    icon: 'icon-vault.svg',
    status: 'locked',
    uptime: '—',
    category: 'security'
  },
  {
    id: 'monitoring',
    title: 'Monitoring',
    desc: 'Metrics, logs and telemetry',
    url: 'https://app.dtrh.net/monitoring',
    icon: 'icon-monitoring.svg',
    status: 'running',
    uptime: 'Live',
    category: 'observability'
  },
  {
    id: 'exploit-lab',
    title: 'Exploit Lab',
    desc: 'Exploit development and testing environment',
    url: 'https://lab.dtrh.net',
    icon: 'icon-lab.svg',
    status: 'running',
    uptime: 'Live',
    category: 'offensive'
  },
  {
    id: 'settings',
    title: 'Settings',
    desc: 'Launcher configuration and preferences',
    url: '#settings',
    icon: 'icon-settings.svg',
    status: 'idle',
    uptime: '—',
    category: 'core'
  }
];

// ============================================================
// State
// ============================================================
let filteredApps = [...APPS];
const grid = document.getElementById('bb-grid');
const searchInput = document.getElementById('bb-search');
const clockEl = document.getElementById('bb-clock');
const lastCheckEl = document.getElementById('bb-last-check');
const activityList = document.getElementById('bb-activity');

// ============================================================
// Icon Loader — fetches SVG from assets/icons/
// ============================================================
async function loadIcon(name) {
  try {
    const res = await fetch(`assets/icons/${name}`);
    if (!res.ok) throw new Error('Icon not found');
    const text = await res.text();
    return text;
  } catch (e) {
    console.warn(`Failed to load icon ${name}:`, e);
    // Fallback inline icon
    return `<svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#00F0FF" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/></svg>`;
  }
}

// ============================================================
// Render
// ============================================================
async function renderApps() {
  grid.innerHTML = '';

  for (const app of filteredApps) {
    const iconSvg = await loadIcon(app.icon);

    const card = document.createElement('article');
    card.className = 'bb-card';
    card.dataset.id = app.id;
    card.dataset.category = app.category;
    card.innerHTML = `
      <div class="bb-card-icon">${iconSvg}</div>
      <h3 class="bb-card-title">${escapeHtml(app.title)}</h3>
      <p class="bb-card-desc">${escapeHtml(app.desc)}</p>
      <div class="bb-card-meta">
        <span class="bb-status" data-status="${app.status}">${app.status.toUpperCase()}</span>
        <span class="bb-uptime">${escapeHtml(app.uptime)}</span>
      </div>
    `;

    // Click handler
    card.addEventListener('click', () => {
      if (app.url.startsWith('#')) {
        handleInternalAction(app.url.slice(1));
      } else {
        window.open(app.url, '_blank', 'noopener,noreferrer');
      }
    });

    // Keyboard accessible
    card.setAttribute('tabindex', '0');
    card.setAttribute('role', 'button');
    card.setAttribute('aria-label', `Open ${app.title}`);
    card.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        card.click();
      }
    });

    grid.appendChild(card);
  }
}

function escapeHtml(str) {
  return str
    .replace(/&/g, '&')
    .replace(/</g, '<')
    .replace(/>/g, '>')
    .replace(/"/g, '"')
    .replace(/'/g, '&#039;');
}

// ============================================================
// Search / Filter
// ============================================================
searchInput.addEventListener('input', (e) => {
  const query = e.target.value.toLowerCase().trim();
  if (!query) {
    filteredApps = [...APPS];
  } else {
    filteredApps = APPS.filter(app =>
      app.title.toLowerCase().includes(query) ||
      app.desc.toLowerCase().includes(query) ||
      app.category.toLowerCase().includes(query)
    );
  }
  renderApps();
});

// ============================================================
// Clock
// ============================================================
function updateClock() {
  const now = new Date();
  const utc = now.toISOString().slice(11, 19);
  clockEl.textContent = utc + ' UTC';
}
updateClock();
setInterval(updateClock, 1000);

// ============================================================
// Activity Feed (simulated — replace with real API)
// ============================================================
const ACTIVITY_ENTRIES = [
  { time: '10:51:03', msg: 'Pentest Harness tunnel verified' },
  { time: '10:50:45', msg: 'Cloudflare Access policy updated' },
  { time: '10:50:12', msg: 'bunnybox.dtrh.net redirect active' },
  { time: '10:49:33', msg: 'app.dtrh.net root routing configured' },
  { time: '10:48:55', msg: 'Nginx path-strip proxy online' },
  { time: '10:47:21', msg: 'Tunnel connections established (×4)' },
  { time: '10:45:44', msg: 'Hostname changed to bunnybox.local' }
];

function renderActivity() {
  activityList.innerHTML = ACTIVITY_ENTRIES.map(a =>
    `<li><span class="time">${a.time}</span> <span class="dot">•</span> ${escapeHtml(a.msg)}</li>`
  ).join('');
  lastCheckEl.textContent = ACTIVITY_ENTRIES[0].time;
}
renderActivity();

// ============================================================
// Internal Actions
// ============================================================
function handleInternalAction(action) {
  switch (action) {
    case 'settings':
      alert('Settings panel — coming soon');
      break;
    default:
      console.log('Unknown action:', action);
  }
}

// ============================================================
// Keyboard Shortcuts
// ============================================================
document.addEventListener('keydown', (e) => {
  // Focus search with /
  if (e.key === '/' && document.activeElement !== searchInput) {
    e.preventDefault();
    searchInput.focus();
  }
  // Escape clears search
  if (e.key === 'Escape' && document.activeElement === searchInput) {
    searchInput.value = '';
    searchInput.dispatchEvent(new Event('input'));
    searchInput.blur();
  }
});

// ============================================================
// Init
// ============================================================
renderApps();
console.log('BunnyBox Launcher initialized — down the rabbit hole 🐰');