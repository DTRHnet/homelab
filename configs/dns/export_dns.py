#!/usr/bin/env python3
import json
import subprocess
import sys
import tempfile
import os

with open('/root/.config/cloudflare/config/default.json') as f:
    config = json.load(f)
token = config['oauth_token']

account_id = '371658f856fd542ba7225013ff396687'
zone_id = 'a7ce1a8286eb42f6025137c451becb14'

# Get all DNS records
result = subprocess.run([
    'curl', '-s', '-H', f'Authorization: Bearer {token}',
    f'https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records?per_page=500'
], capture_output=True, text=True)

data = json.loads(result.stdout)
if not data.get('success'):
    print("Error:", data.get('errors'))
    sys.exit(1)

# Save full records
with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as f:
    json.dump(data, f, indent=2)
    records_file = f.name

print(f"Total records: {data['result_info']['count']}")

# Print summary
for r in data['result']:
    print(f"  {r['type']:6} {r['name']:30} -> {r['content']:50} proxied={r['proxied']}")

os.unlink(records_file)