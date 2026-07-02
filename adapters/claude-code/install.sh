#!/usr/bin/env bash
# Claude Code adapter: symlinks skills into .claude/skills/, offers the
# post-edit check hook, and creates CLAUDE.md if the project has none.
#
# Usage: install.sh --project <dir> [--yes]
set -euo pipefail

ADAPTER_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$ADAPTER_DIR/../.." && pwd)"

PROJECT=""; ASSUME_YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?}"; shift ;;
    --yes) ASSUME_YES=1 ;;
    --help|-h) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done
[ -n "$PROJECT" ] || { echo "--project is required" >&2; exit 2; }

# Symlink each skill directory into .claude/skills/
mkdir -p "$PROJECT/.claude/skills"
COUNT=0
for skill in "$REPO"/skills/*/; do
  name="$(basename "$skill")"
  ln -sfn "$skill" "$PROJECT/.claude/skills/$name"
  COUNT=$((COUNT + 1))
done
echo "Linked $COUNT skills into $PROJECT/.claude/skills/"

# CLAUDE.md: create from the template only if the project has none
if [ ! -f "$PROJECT/CLAUDE.md" ]; then
  cp "$REPO/agents-files/remote/CLAUDE.md" "$PROJECT/CLAUDE.md"
  echo "Created $PROJECT/CLAUDE.md"
else
  echo "CLAUDE.md exists — left untouched. Consider merging $REPO/agents-files/remote/CLAUDE.md yourself."
fi

# Post-edit hook: merge hooks.json into .claude/settings.json (needs node for JSON)
SETTINGS="$PROJECT/.claude/settings.json"
if [ "$ASSUME_YES" = 1 ]; then
  REPLY="y"
else
  read -r -p "Add the Claude Code post-edit check hook to .claude/settings.json? [y/N]: " REPLY </dev/tty
fi
if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
  if [ ! -f "$SETTINGS" ]; then
    cp "$ADAPTER_DIR/hooks.json" "$SETTINGS"
    echo "Created $SETTINGS with the post-edit check hook."
  elif command -v node >/dev/null 2>&1; then
    node -e '
      const fs = require("fs");
      const [settingsPath, hooksPath] = process.argv.slice(1);
      const settings = JSON.parse(fs.readFileSync(settingsPath, "utf8"));
      const add = JSON.parse(fs.readFileSync(hooksPath, "utf8"));
      settings.hooks = settings.hooks || {};
      const existing = settings.hooks.PostToolUse || [];
      const wanted = add.hooks.PostToolUse[0];
      const already = existing.some(h => JSON.stringify(h) === JSON.stringify(wanted));
      if (!already) settings.hooks.PostToolUse = existing.concat([wanted]);
      fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + "\n");
      console.log(already ? "Hook already present." : "Merged post-edit hook into " + settingsPath);
    ' "$SETTINGS" "$ADAPTER_DIR/hooks.json"
  else
    echo "node not found — merge $ADAPTER_DIR/hooks.json into $SETTINGS manually."
  fi
fi
