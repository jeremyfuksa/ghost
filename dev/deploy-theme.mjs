#!/usr/bin/env node
// Upload and activate the-cocktail-napkin.zip on jeremyfuksa.com via Ghost Admin API.
// Reads GHOST_API=<id>:<secret> from .env in the repo root.

import { createHmac } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), '..');
const envFile = readFileSync(join(repoRoot, '.env'), 'utf8');
const match = envFile.match(/^GHOST_API=([^:\s]+):([a-f0-9]+)\s*$/m);
if (!match) {
  console.error('Could not parse GHOST_API=<id>:<secret> from .env');
  process.exit(1);
}
const [, keyId, secretHex] = match;

const SITE = 'https://jeremyfuksa.com';
const THEME_NAME = 'the-cocktail-napkin';
const ZIP_PATH = join(repoRoot, `${THEME_NAME}.zip`);

function b64url(buf) {
  return Buffer.from(buf).toString('base64').replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

function mintJwt() {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'HS256', kid: keyId, typ: 'JWT' };
  const payload = { iat: now, exp: now + 5 * 60, aud: '/admin/' };
  const signingInput = `${b64url(JSON.stringify(header))}.${b64url(JSON.stringify(payload))}`;
  const sig = createHmac('sha256', Buffer.from(secretHex, 'hex')).update(signingInput).digest();
  return `${signingInput}.${b64url(sig)}`;
}

async function upload() {
  const jwt = mintJwt();
  const zipBytes = readFileSync(ZIP_PATH);
  const form = new FormData();
  form.append('file', new Blob([zipBytes], { type: 'application/zip' }), `${THEME_NAME}.zip`);

  const res = await fetch(`${SITE}/ghost/api/admin/themes/upload/`, {
    method: 'POST',
    headers: { Authorization: `Ghost ${jwt}` },
    body: form,
  });
  const text = await res.text();
  console.log(`UPLOAD ${res.status}`);
  console.log(text);
  if (!res.ok) process.exit(1);
  return JSON.parse(text);
}

async function activate() {
  const jwt = mintJwt();
  const res = await fetch(`${SITE}/ghost/api/admin/themes/${THEME_NAME}/activate/`, {
    method: 'PUT',
    headers: { Authorization: `Ghost ${jwt}` },
  });
  const text = await res.text();
  console.log(`ACTIVATE ${res.status}`);
  console.log(text);
  if (!res.ok) process.exit(1);
}

await upload();
await activate();
console.log('Done.');
