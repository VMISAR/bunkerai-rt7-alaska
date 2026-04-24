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
find . -type f \
  -not -path "./.git/*" \
  -not -path "./scripts/audit_public_repo.sh" \
  -not -name "files.zip" \
  -not -name ".gitignore" \
  -not -name "PUBLIC_REDACTION_CHECKLIST.md" \
  -not -name "KNOWN_LIMITATIONS.md" \
  -not -name "CONTENT_MANIFEST.md" \
  -not -name "QUICK_START.md" \
  -not -name "CHANGELOG.md" \
  -not -name "README.md" \
  -print0 | xargs -0 grep -InE "RT7TITAN[A-Z0-9]+|SN:|S/N|IMEI|MEID|/Users/|apikey|api_key|password|credential|cookie|session" || true
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