#!/usr/bin/env bash
set -euo pipefail

echo "=== BunkerAI-RT7 Public Repo Audit ==="
echo

echo "1. Git status"
git status --short
echo

echo "2. macOS metadata check"
find . -name ".DS_Store" -o -name "._*" | sed 's#^\./##' || true
echo

echo "3. Sensitive string scan"
grep -RInE "Serial|SN:|S/N|IMEI|MEID|/Users/|apikey|api_key|password|secret|credential|cookie|session|RT7TITAN[A-Z0-9]+" . \
  --exclude-dir=.git \
  --exclude=files.zip \
  --exclude=scripts/audit_public_repo.sh \
  --exclude=PUBLIC_REDACTION_CHECKLIST.md \
  --exclude=KNOWN_LIMITATIONS.md \
  --exclude=CONTENT_MANIFEST.md \
  --exclude=QUICK_START.md \
  --exclude=CHANGELOG.md \
  --exclude=README.md || true
echo

echo "4. Large tracked/untracked files over 25MB"
find . -type f -size +25M \
  -not -path "./.git/*" \
  -print | sed 's#^\./##' || true
echo

echo "5. Staged changes summary"
git diff --cached --stat || true
echo

echo "=== Audit complete ==="