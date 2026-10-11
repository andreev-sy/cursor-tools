#!/usr/bin/env bash
# Copy kit into the target project. Always overwrites this kit's files.
set -euo pipefail

# Full GitHub path: owner/repo
KIT_PATH="andreev-sy/cursor-tools"
SKILL_PREFIX="andreev-sy-cursor-tools"

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$(cd "${1:-.}" && pwd)"

KIT_DEST="${TARGET}/.cursor/kits/${KIT_PATH}"
SKILLS_DEST="${TARGET}/.cursor/skills"

rm -rf "$KIT_DEST"
mkdir -p "$KIT_DEST" "$SKILLS_DEST"

for item in ADP.md README.md examples templates skills; do
  src="${KIT_ROOT}/${item}"
  [[ -e "$src" ]] || continue
  if [[ -d "$src" ]]; then
    cp -R "$src" "$KIT_DEST/"
  else
    cp -f "$src" "$KIT_DEST/"
  fi
done

for src in "${KIT_ROOT}/skills"/*/; do
  [[ -d "$src" ]] || continue
  name="$(basename "$src")"
  dest="${SKILLS_DEST}/${name}"
  rm -rf "$dest"
  cp -R "$src" "$dest"
done

# Drop short-name skills from older installs
for legacy in cursor-tools-adp cursor-tools-project-bootstrap; do
  rm -rf "${SKILLS_DEST}/${legacy}"
done
rm -rf "${TARGET}/.cursor/kits/cursor-tools"

echo "Installed into ${TARGET}"
echo "  ${KIT_DEST}"
echo "  ${SKILLS_DEST}/${SKILL_PREFIX}-*"
echo "Commands: /${SKILL_PREFIX}-project-bootstrap  then  /${SKILL_PREFIX}-adp"
