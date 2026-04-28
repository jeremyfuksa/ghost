#!/usr/bin/env node
// Create a new Ghost post from a local markdown file.
// Usage: node dev/deploy-post.mjs --file ../ghost-drafts/slug.md --title "..." [--slug <slug>] [--tags tag1,tag2] [--excerpt "..."] [--status draft|published] [--push]
// Without --push, prints preview and exits (dry-run by default).
// Reads GHOST_API=<id>:<secret> from .env in the repo root.
// Strips a leading H1 "# Title" from the markdown so Ghost's post title isn't duplicated.
// Also strips the top SEO/Thumbnail/Alt-text deliverables block (if present) so it doesn't render as body prose.

import { createHmac } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { join, dirname, basename, extname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { marked } from 'marked';

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), '..');

function arg(name) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : null;
}

const file = arg('file');
const title = arg('title');
const slugArg = arg('slug');
const tagsArg = arg('tags');
const excerptArg = arg('excerpt');
const status = arg('status') || 'draft';
const push = process.argv.includes('--push');

if (!file || !title) {
  console.error('Usage: node dev/deploy-post.mjs --file <markdown.md> --title "..." [--slug <slug>] [--tags a,b] [--excerpt "..."] [--status draft|published] [--push]');
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

const raw = readFileSync(file.startsWith('/') ? file : join(repoRoot, file), 'utf8');

// Parse out the SEO/Thumbnail/Alt-text deliverables block at the top, if present.
// Format: three `**Field:** value` lines separated by blank lines, then `---`, then the body.
let bodyMd = raw;
let seoDescription = null;
const deliverablesMatch = raw.match(/^(?:\*\*SEO Description:\*\*\s*(.+?)\n\n)?(?:\*\*Thumbnail Description:\*\*\s*[\s\S]+?\n\n)?(?:\*\*Alt Text \/ Caption:\*\*\s*.+?\n\n)?---\n+/);
if (deliverablesMatch) {
  if (deliverablesMatch[1]) seoDescription = deliverablesMatch[1].trim();
  bodyMd = raw.slice(deliverablesMatch[0].length);
}

// Strip the top-level H1
bodyMd = bodyMd.replace(/^#\s+[^\n]+\n+/, '');

const html = marked(bodyMd);
const wordCount = bodyMd.split(/\s+/).filter(Boolean).length;

// Derive slug if not provided
const slug = slugArg || basename(file, extname(file)).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
const tags = tagsArg ? tagsArg.split(',').map(t => t.trim()).filter(Boolean) : [];
const excerpt = excerptArg || seoDescription;

console.log(`--- POST PREVIEW ---`);
console.log(`title:   ${title}`);
console.log(`slug:    ${slug}`);
console.log(`status:  ${status}`);
console.log(`tags:    ${tags.join(', ') || '(none)'}`);
console.log(`excerpt: ${excerpt ? excerpt.slice(0, 100) + (excerpt.length > 100 ? '…' : '') : '(none)'}`);
console.log(`body:    ${wordCount} words, ${html.length} chars HTML`);
console.log(`--- FIRST 400 CHARS OF HTML ---`);
console.log(html.slice(0, 400));

if (!push) {
  console.log('\n(dry-run — pass --push to create)');
  process.exit(0);
}

const postData = {
  title,
  slug,
  status,
  html,
  tags: tags.map(name => ({ name })),
};
if (excerpt) postData.custom_excerpt = excerpt;

const res = await fetch(`${SITE}/ghost/api/admin/posts/?source=html`, {
  method: 'POST',
  headers: {
    Authorization: `Ghost ${mintJwt()}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({ posts: [postData] }),
});
const result = await res.json();
console.log(`\nPOST ${res.status}`);
if (!res.ok) {
  console.log(JSON.stringify(result, null, 2));
  process.exit(1);
}
const post = result.posts[0];
console.log(`Created: ${post.id}`);
console.log(`URL: ${post.url}`);
console.log(`Status: ${post.status}`);
