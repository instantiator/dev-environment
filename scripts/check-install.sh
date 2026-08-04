#!/usr/bin/env bash
# Reports how a project's installed dev-environment files differ from this
# checkout — the drift that builds up after `git submodule update`.
#
# PASS = matches this checkout. FAIL = differs (upstream moved, or you
# customised it). SKIP = not installed, so nothing to compare.
#
# Usage: check-install.sh [--project <dir>]
# Exit code: 1 if anything differs, else 0.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

PROJECT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?--project needs a directory}"; shift ;;
    --help|-h) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done
# Default to the repo this checkout sits inside, matching install.sh
[ -n "$PROJECT" ] || PROJECT="$(cd "$REPO/.." && pwd)"

echo "check-install.sh — comparing $PROJECT against $REPO"

# Print the content between a pair of markers: block_between <file> <start> <end>
block_between() {
  awk -v s="$2" -v e="$3" '
    $0 == e { inside = 0 }
    inside { print }
    $0 == s { inside = 1 }
  ' "$1"
}

# 1. The AGENTS.md entry block, against whichever tier file it was taken from
AGENTS="$PROJECT/AGENTS.md"
if [ ! -f "$AGENTS" ]; then
  record_result "AGENTS.md" SKIP "not installed — run install.sh"
elif ! grep -q '<!-- dev-environment:start -->' "$AGENTS"; then
  record_result "AGENTS.md" SKIP "no dev-environment block — run install.sh"
else
  installed="$(block_between "$AGENTS" '<!-- dev-environment:start -->' '<!-- dev-environment:end -->')"
  matched=""
  for tier in local remote; do
    if [ "$installed" = "$(cat "$REPO/agents-files/$tier/AGENTS.md")" ]; then
      matched="$tier"
    fi
  done
  if [ -n "$matched" ]; then
    record_result "AGENTS.md" PASS
    echo "   tier: $matched"
  else
    record_result "AGENTS.md" FAIL "block differs from both tier files — diff against $REPO/agents-files/*/AGENTS.md, keep your edits, then re-run install.sh"
  fi
fi

# 2. The OpenCode skills routing block: every current skill must be listed
if [ -f "$AGENTS" ] && grep -q '<!-- dev-environment:skills:start -->' "$AGENTS"; then
  missing=""
  while read -r line; do
    name="${line#- [}"; name="${name%%]*}"
    grep -q "skills/$name/SKILL.md" "$AGENTS" || missing="$missing $name"
  done <<EOF
$(grep '^- \[' "$REPO/skills/index.md")
EOF
  if [ -z "$missing" ]; then
    record_result "AGENTS.md:skills" PASS
  else
    record_result "AGENTS.md:skills" FAIL "missing skills:$missing — re-run adapters/opencode/install.sh"
  fi
else
  record_result "AGENTS.md:skills" SKIP "no skills routing block (OpenCode adapter not installed)"
fi

# 3. CLAUDE.md — copied once by the adapter and never refreshed, so this is
#    where drift is most likely
if [ ! -d "$PROJECT/.claude" ]; then
  record_result "CLAUDE.md" SKIP "Claude Code adapter not installed"
elif [ ! -f "$PROJECT/CLAUDE.md" ]; then
  record_result "CLAUDE.md" FAIL "missing — copy $REPO/agents-files/remote/CLAUDE.md"
elif diff -q "$PROJECT/CLAUDE.md" "$REPO/agents-files/remote/CLAUDE.md" >/dev/null 2>&1; then
  record_result "CLAUDE.md" PASS
else
  record_result "CLAUDE.md" FAIL "differs — diff against $REPO/agents-files/remote/CLAUDE.md and merge what you want to keep"
fi

# 4. Skills. Symlinks into this checkout are always current; a real directory
#    or a broken link is a copy that has stopped tracking upstream.
SKILLS_DIR="$PROJECT/.claude/skills"
if [ ! -d "$SKILLS_DIR" ]; then
  record_result "skills" SKIP "Claude Code adapter not installed"
else
  stale=""; absent=""
  for skill in "$REPO"/skills/*/; do
    name="$(basename "$skill")"
    if [ ! -e "$SKILLS_DIR/$name" ] && [ ! -L "$SKILLS_DIR/$name" ]; then
      absent="$absent $name"
    elif [ ! -L "$SKILLS_DIR/$name" ] || [ ! -d "$SKILLS_DIR/$name" ]; then
      stale="$stale $name"
    fi
  done
  if [ -z "$stale" ] && [ -z "$absent" ]; then
    record_result "skills" PASS
  else
    record_result "skills" FAIL "re-run adapters/claude-code/install.sh —${absent:+ not installed:$absent}${stale:+ not a working symlink:$stale}"
  fi
fi

# 5. The Claude Code post-edit hook in settings.json
SETTINGS="$PROJECT/.claude/settings.json"
if [ ! -f "$SETTINGS" ]; then
  record_result "settings.json" SKIP "no .claude/settings.json (post-edit hook is optional)"
elif grep -q 'check.sh --fast' "$SETTINGS"; then
  record_result "settings.json" PASS
else
  record_result "settings.json" FAIL "post-edit hook absent — re-run adapters/claude-code/install.sh to add it"
fi

# 6. Git hooks. A core.hooksPath install reads this checkout directly and
#    cannot drift; copied hooks can.
if ! git -C "$PROJECT" rev-parse --git-dir >/dev/null 2>&1; then
  record_result "git-hooks" SKIP "$PROJECT is not a git repository"
else
  HOOKS_PATH="$(git -C "$PROJECT" config core.hooksPath || true)"
  if [ "$HOOKS_PATH" = "$REPO/scripts/hooks" ]; then
    record_result "git-hooks" PASS
    echo "   core.hooksPath -> this checkout, so hooks are always current"
  else
    GIT_HOOKS="$PROJECT/$(git -C "$PROJECT" rev-parse --git-path hooks)"
    differing=""
    for hook in "$REPO"/scripts/hooks/*; do
      name="$(basename "$hook")"
      if [ ! -f "$GIT_HOOKS/$name" ]; then
        differing="$differing $name(absent)"
      elif ! diff -q "$hook" "$GIT_HOOKS/$name" >/dev/null 2>&1; then
        differing="$differing $name"
      fi
    done
    if [ -z "$differing" ]; then
      record_result "git-hooks" PASS
    else
      record_result "git-hooks" FAIL "copied hooks differ:$differing — re-run setup-hooks.sh --copy, or diff them first if you edited them"
    fi
  fi
fi

echo ""
report_results
