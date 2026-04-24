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
grep -RInE "Serial|serial|SN:|S/N|IMEI|MEID|/Users/|token|apikey|api_key|password|secret|credential|cookie|session" . \
  --exclude-dir=.git \
  --exclude=files.zip \
  --exclude=scripts/audit_public_repo.sh || true
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