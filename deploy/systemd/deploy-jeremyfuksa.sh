#!/bin/bash
# Install as /home/admin/deploy-jeremyfuksa.sh (admin:admin mode 0755).
#
# Invoked by GitHub Actions over SSH via a restricted authorized_keys entry.
# Reads a tar.gz of dist/ on stdin, validates it, and atomically swaps the
# new build into place without touching the bind-mount inode that the
# astro-web container holds.
#
# The CI-side that calls this:
#   ssh -i $DEPLOY_KEY admin@161.35.226.162 < dist.tar.gz
# The authorized_keys entry pins this script as the forced command, so the
# key cannot do anything else.

set -euo pipefail

REPO="/home/admin/jeremyfuksa.com"
INCOMING="$REPO/dist-incoming"
LIVE="$REPO/dist"
LOG="/home/admin/.rebuild-trigger/deploy.log"
LOCK="/home/admin/.rebuild-trigger/deploy.lock"

ts() { date -u +%Y-%m-%dT%H:%M:%SZ; }

# Single deploy at a time. A second deploy mid-flight gets the lock and
# waits — preferable to two deploys interleaving rsync into the live tree.
exec 9>"$LOCK"
flock 9

echo "[$(ts)] Deploy starting (pid $$)" >> "$LOG"

# Reset the staging dir. Old contents may exist if a previous deploy died
# between extract and swap.
rm -rf "$INCOMING"
mkdir -p "$INCOMING"

# Extract the tarball coming in on stdin.
if ! tar -xzf - -C "$INCOMING" 2>>"$LOG"; then
  echo "[$(ts)] FAIL: tar extract failed" >> "$LOG"
  rm -rf "$INCOMING"
  exit 1
fi

# Sanity-check the artifact looks like a real build.
if [[ ! -f "$INCOMING/client/index.html" ]] || [[ ! -f "$INCOMING/server/entry.mjs" ]]; then
  echo "[$(ts)] FAIL: artifact missing client/index.html or server/entry.mjs" >> "$LOG"
  rm -rf "$INCOMING"
  exit 1
fi

# Swap into place. rsync --delete mirrors content; nginx keeps serving
# from the same dist/ inode throughout. Each file is replaced atomically
# by rsync's temp-then-rename behavior.
if ! rsync -a --delete "$INCOMING/" "$LIVE/" 2>>"$LOG"; then
  echo "[$(ts)] FAIL: rsync to live failed" >> "$LOG"
  exit 1
fi

rm -rf "$INCOMING"

# Restart the SSR — same sudoers rule the rebuild script uses.
if ! sudo -n systemctl restart jeremyfuksa-ssr 2>>"$LOG"; then
  echo "[$(ts)] FAIL: systemctl restart jeremyfuksa-ssr failed" >> "$LOG"
  exit 1
fi

echo "[$(ts)] Deploy complete" >> "$LOG"
