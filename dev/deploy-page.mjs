#!/usr/bin/env node
// Update an existing Ghost page's HTML body from a local markdown file.
// Usage: node dev/deploy-page.mjs --slug <page-slug> --file <path/to/markdown.md> [--push]
// Without --push, prints an HTML preview and exits (dry-run by default).
// Reads GHOST_API=<id>:<secret> from .env in the repo root.
// Strips a single top-level "# Title" from the markdown so Ghost's page title isn't duplicated.

import { createHmac } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { marked } from 'marked';

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), '..');

function arg(name) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : null;
}

const slug = arg('slug');
const file = arg('file');
const push = process.argv.includes('--push');

if (!slug || !file) {
  console.error('Usage: node dev/deploy-page.mjs --slug <page-slug> --file <path/to/markdown.md> [--push]');
  process.exit(1);
}

const env = readFileSync(join(repoRoot, '.env'), 'utf8');
const m = env.match(/^GHOST_API=([^:\s]+):([a-f0-9]+)\s*$/m);
if (!m) {
  console.error('Could not parse GHOST_API=<id>:<secret> from .env');
  process.exit(1);
}
const [, keyId, secretHex] = m;
const SITE = 'https://jeremyfuksa.com';

function b64url(buf) {
  return Buffer.from(buf).toString('base64').replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}
function mintJwt() {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'HS256', kid: keyId, typ: 'JWT' };
  const payload = { iat: now, exp: now + 300, aud: '/admin/' };
  const signingInput = `${b64url(JSON.stringify(header))}.${b64url(JSON.stringify(payload))}`;
  const sig = createHmac('sha256', Buffer.from(secretHex, 'hex')).update(signingInput).digest();
  return `${signingInput}.${b64url(sig)}`;
}

const md = readFileSync(file.startsWith('/') ? file : join(repoRoot, file), 'utf8');
const bodyMd = md.replace(/^#\s+[^\n]+\n+/, '');
const html = marked(bodyMd);

console.log(`--- ${slug}: HTML preview (first 400 chars) ---`);
console.log(html.slice(0, 400));
console.log(`--- ${html.length} chars, ${bodyMd.split(/\s+/).filter(Boolean).length} words ---`);

if (!push) {
  console.log('(dry-run — pass --push to deploy)');
  process.exit(0);
}

const lookupRes = await fetch(`${SITE}/ghost/api/admin/pages/?filter=slug:${slug}&fields=id,updated_at`, {
  headers: { Authorization: `Ghost ${mintJwt()}` },
});
const lookup = await lookupRes.json();
if (!lookup.pages?.[0]) {
  console.error(`Page with slug "${slug}" not found.`);
  process.exit(1);
}
const { id, updated_at } = lookup.pages[0];

const putRes = await fetch(`${SITE}/ghost/api/admin/pages/${id}/?source=html`, {
  method: 'PUT',
  headers: {
    Authorization: `Ghost ${mintJwt()}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({ pages: [{ html, updated_at }] }),
});
const result = await putRes.json();
console.log(`PUT ${putRes.status}`);
if (!putRes.ok) {
  console.log(JSON.stringify(result, null, 2));
  process.exit(1);
}
console.log(`Page updated. New updated_at: ${result.pages[0].updated_at}`);
