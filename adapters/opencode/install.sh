#!/usr/bin/env bash
# OpenCode (and other AGENTS.md-reading agents) adapter: injects a skills
# routing block into the project's AGENTS.md between markers. Re-runnable.
#
# Usage: install.sh --project <dir>
set -euo pipefail

ADAPTER_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$ADAPTER_DIR/../.." && pwd)"

PROJECT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?}"; shift ;;
    --help|-h) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done
[ -n "$PROJECT" ] || { echo "--project is required" >&2; exit 2; }

TARGET="$PROJECT/AGENTS.md"
TMP="$(mktemp)"

# Remove a previous skills block, keeping everything else
if [ -f "$TARGET" ]; then
  awk '/<!-- dev-environment:skills:start -->/{skip=1} !skip{print} /<!-- dev-environment:skills:end -->/{skip=0}' \
    "$TARGET" >"$TMP"
else
  : >"$TMP"
fi

# Append the current skills routing block, generated from skills/index.md
{
  echo '<!-- dev-environment:skills:start -->'
  echo ''
  echo '## Skills (multi-step task playbooks)'
  echo ''
  echo 'Match the task against a trigger below, then follow that SKILL.md literally.'
  echo ''
  # Reuse the index entries; point them at the dev-environment path
  grep '^- \[' "$REPO/skills/index.md" | sed 's|(\(.*\))|(dev-environment/skills/\1)|'
  echo '<!-- dev-environment:skills:end -->'
} >>"$TMP"

mv "$TMP" "$TARGET"
echo "Injected skills routing block into $TARGET"
