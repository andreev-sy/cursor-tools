#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/andreev-sy/cursor-tools/master/install-remote.sh | bash
set -euo pipefail

REPO="andreev-sy/cursor-tools"
BRANCH="master"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" | tar -xz -C "$TMP"
elif command -v wget >/dev/null 2>&1; then
  wget -qO- "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" | tar -xz -C "$TMP"
else
  echo "Need curl or wget" >&2
  exit 1
fi

KIT_DIR="$(find "$TMP" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
chmod +x "${KIT_DIR}/install.sh" 2>/dev/null || true
bash "${KIT_DIR}/install.sh" "$(pwd)"
