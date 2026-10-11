#!/usr/bin/env bash
# One-shot install from GitHub into the current project.
# Usage (from target project root):
#   curl -fsSL https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.sh | bash
#   wget -qO- https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.sh | bash
#   curl -fsSL ... | bash -s -- --force
set -euo pipefail

FORCE_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE_ARGS+=(--force); shift ;;
    -u|--user) FORCE_ARGS+=(--user); shift ;;
    -n|--name) FORCE_ARGS+=(--name "$2"); shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null || true)"
# When piped from curl, BASH_SOURCE may be not a real checkout — fetch kit.conf defaults via env.
GITHUB_REPO="${GITHUB_REPO:-}"
GITHUB_BRANCH="${GITHUB_BRANCH:-main}"
KIT_NAME="${KIT_NAME:-}"

# If executed from a local clone, prefer its kit.conf
if [[ -n "${SCRIPT_DIR}" && -f "${SCRIPT_DIR}/kit.conf" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/kit.conf"
fi

GITHUB_REPO="${GITHUB_REPO:-andreev-sy/cursor-tools}"
GITHUB_BRANCH="${GITHUB_BRANCH:-main}"

if [[ -z "$GITHUB_REPO" ]]; then
  echo "GITHUB_REPO is empty." >&2
  exit 1
fi

REPO_BASENAME="$(basename "$GITHUB_REPO" .git)"
KIT_NAME="${KIT_NAME:-$REPO_BASENAME}"

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

ARCHIVE_URL="https://github.com/${GITHUB_REPO}/archive/refs/heads/${GITHUB_BRANCH}.tar.gz"
echo "Downloading ${ARCHIVE_URL}"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP"
elif command -v wget >/dev/null 2>&1; then
  wget -qO- "$ARCHIVE_URL" | tar -xz -C "$TMP"
else
  echo "Need curl or wget" >&2
  exit 1
fi

KIT_DIR="$(find "$TMP" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [[ ! -x "${KIT_DIR}/install.sh" ]]; then
  chmod +x "${KIT_DIR}/install.sh" || true
fi

echo "Running install into: $(pwd)"
KIT_NAME="$KIT_NAME" bash "${KIT_DIR}/install.sh" "${FORCE_ARGS[@]}" "$(pwd)"
