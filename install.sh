#!/usr/bin/env bash
# Install ADP kit into a project under .cursor/kits/<KIT_NAME>/ + namespaced skills.
set -euo pipefail

FORCE=0
USER_INSTALL=0
TARGET=""
KIT_NAME="${KIT_NAME:-}"
KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "${KIT_ROOT}/kit.conf" ]]; then
  # shellcheck disable=SC1091
  source "${KIT_ROOT}/kit.conf"
fi
KIT_NAME="${KIT_NAME:-cursor-tools}"

usage() {
  cat <<EOF
Usage: install.sh [options] [target]

  target              Project root (default: current directory)
  -u, --user          Install into ~/.cursor/kits and ~/.cursor/skills
  -f, --force         Overwrite this kit's files
  -n, --name NAME     Kit namespace (default: ${KIT_NAME})
  -h, --help          Show help

Layout in project:
  .cursor/kits/${KIT_NAME}/          methodology, examples, templates, skill sources
  .cursor/skills/${KIT_NAME}-*/      Cursor-discovered skills (namespaced)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE=1; shift ;;
    -u|--user) USER_INSTALL=1; shift ;;
    -n|--name) KIT_NAME="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

# sanitize kit name: lowercase-ish safe folder
KIT_NAME="$(echo "$KIT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]/-/g')"

SKILLS_SOURCE="${KIT_ROOT}/skills"
if [[ ! -d "$SKILLS_SOURCE" ]]; then
  echo "Skills source not found: $SKILLS_SOURCE" >&2
  exit 1
fi

if [[ "$USER_INSTALL" -eq 1 ]]; then
  CURSOR_ROOT="${HOME}/.cursor"
  PROJECT_ROOT=""
else
  TARGET="${TARGET:-$(pwd)}"
  mkdir -p "$TARGET"
  TARGET="$(cd "$TARGET" && pwd)"
  PROJECT_ROOT="$TARGET"
  CURSOR_ROOT="${TARGET}/.cursor"
fi

KIT_DEST="${CURSOR_ROOT}/kits/${KIT_NAME}"
SKILLS_DEST="${CURSOR_ROOT}/skills"
mkdir -p "$KIT_DEST" "$SKILLS_DEST"

echo "Installing kit '${KIT_NAME}' -> ${KIT_DEST}"

# Payload into namespaced kit dir (not project root)
for item in ADP.md README.md kit.conf examples templates; do
  src="${KIT_ROOT}/${item}"
  [[ -e "$src" ]] || continue
  dest="${KIT_DEST}/${item}"
  if [[ -e "$dest" && "$FORCE" -eq 0 ]]; then
    echo "Skip (exists): kits/${KIT_NAME}/${item}"
    continue
  fi
  if [[ -d "$src" ]]; then
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -R "${src}/." "$dest/"
  else
    cp -f "$src" "$dest"
  fi
  echo "Installed: .cursor/kits/${KIT_NAME}/${item}"
done

if [[ "$FORCE" -eq 1 || ! -d "${KIT_DEST}/skills" ]]; then
  rm -rf "${KIT_DEST}/skills"
  mkdir -p "${KIT_DEST}/skills"
  cp -R "${SKILLS_SOURCE}/." "${KIT_DEST}/skills/"
  echo "Installed: .cursor/kits/${KIT_NAME}/skills"
fi

echo "${KIT_NAME}" > "${KIT_DEST}/.kit-id"

installed=()
skipped=()

for src in "${KIT_DEST}/skills"/*/; do
  [[ -d "$src" ]] || continue
  base="$(basename "$src")"
  skill_id="${KIT_NAME}-${base}"
  dest="${SKILLS_DEST}/${skill_id}"
  if [[ -e "$dest" && "$FORCE" -eq 0 ]]; then
    skipped+=("$skill_id")
    echo "Skip (exists): skills/${skill_id}"
    continue
  fi
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -R "${src}/." "$dest/"
  # Ensure frontmatter name matches folder (slash command)
  if [[ -f "${dest}/SKILL.md" ]] && grep -q '^name:' "${dest}/SKILL.md"; then
    sed -i.bak "s/^name: .*/name: ${skill_id}/" "${dest}/SKILL.md" && rm -f "${dest}/SKILL.md.bak"
  fi
  installed+=("$skill_id")
  echo "Installed: .cursor/skills/${skill_id}"
done

# Cleanup legacy root ADP.md from older kit versions (only if marker/content matches kit)
if [[ -n "$PROJECT_ROOT" && -f "${PROJECT_ROOT}/ADP.md" ]]; then
  if grep -q 'Anchor' "${PROJECT_ROOT}/ADP.md" 2>/dev/null && grep -q 'Delta' "${PROJECT_ROOT}/ADP.md" && grep -q 'Prove' "${PROJECT_ROOT}/ADP.md"; then
    rm -f "${PROJECT_ROOT}/ADP.md"
    echo "Removed legacy: ./ADP.md (moved under .cursor/kits/${KIT_NAME}/)"
  fi
fi

# Cleanup legacy unprefixed skills from older kit versions
for legacy in adp project-bootstrap brief; do
  if [[ -d "${SKILLS_DEST}/${legacy}" ]]; then
    if [[ -f "${SKILLS_DEST}/${legacy}/SKILL.md" ]] && grep -qE 'ADP|project-bootstrap|Brief' "${SKILLS_DEST}/${legacy}/SKILL.md" 2>/dev/null; then
      rm -rf "${SKILLS_DEST}/${legacy}"
      echo "Removed legacy skill: ${legacy}"
    fi
  fi
done

echo ""
echo "Done."
echo "  Kit files:  ${KIT_DEST}"
echo "  Skills:     ${SKILLS_DEST}/${KIT_NAME}-*"
if [[ ${#installed[@]} -gt 0 ]]; then
  echo "  Installed:  ${installed[*]}"
fi
if [[ ${#skipped[@]} -gt 0 ]]; then
  echo "  Skipped:    ${skipped[*]}"
fi
echo ""
echo "Commands: /${KIT_NAME}-project-bootstrap   then   /${KIT_NAME}-adp"
echo "Docs:     ${KIT_DEST}/ADP.md"
