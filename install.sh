#!/usr/bin/env bash
# Interactive installer: wires dev-environment guidance, skills, and hooks
# into a target project. Re-runnable; merges rather than clobbers.
#
# Usage: install.sh [--project <dir>] [--tier local|remote] [--platforms <list>] [--hooks yes|no] [--yes]
#   --project <dir>    target repo (default: parent of this dev-environment checkout)
#   --tier             agent tier for AGENTS.md: local (small-context) or remote
#   --platforms        comma-separated: claude,opencode or none
#   --hooks yes|no     install git hooks
#   --yes              accept defaults for anything not given (non-interactive)
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"

PROJECT=""; TIER=""; PLATFORMS=""; HOOKS=""; ASSUME_YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?}"; shift ;;
    --tier) TIER="${2:?}"; shift ;;
    --platforms) PLATFORMS="${2:?}"; shift ;;
    --hooks) HOOKS="${2:?}"; shift ;;
    --yes) ASSUME_YES=1 ;;
    --help|-h) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

# Ask a question unless the answer was provided or --yes chose the default:
# ask <current-value> <prompt> <default> -> echoes the answer
ask() {
  local current="$1" prompt="$2" default="$3" answer
  if [ -n "$current" ]; then echo "$current"; return; fi
  if [ "$ASSUME_YES" = 1 ]; then echo "$default"; return; fi
  read -r -p "$prompt [$default]: " answer </dev/tty
  echo "${answer:-$default}"
}

# 1. Target project (default: the repo this checkout sits inside)
DEFAULT_PROJECT="$(cd "$REPO/.." && pwd)"
PROJECT="$(ask "$PROJECT" "Install into which project directory?" "$DEFAULT_PROJECT")"
if ! git -C "$PROJECT" rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Warning: $PROJECT is not a git repository — hooks cannot be installed." >&2
fi
echo "Target: $PROJECT"

# 2. Tier for the AGENTS.md entry file
TIER="$(ask "$TIER" "Agent tier for AGENTS.md — local (small-context) or remote?" "local")"
case "$TIER" in local|remote) ;; *) echo "Tier must be 'local' or 'remote'" >&2; exit 2 ;; esac

# 3. Platforms
PLATFORMS="$(ask "$PLATFORMS" "Agent platforms to wire up (claude,opencode or none)?" "claude,opencode")"

# 4. Merge the entry file into the project's AGENTS.md between markers,
#    replacing a previous dev-environment block if present (re-runnable).
merge_block() {
  local target="$1" source="$2" tmp
  tmp="$(mktemp)"
  if [ -f "$target" ] && grep -q '<!-- dev-environment:start -->' "$target"; then
    awk '/<!-- dev-environment:start -->/{skip=1} !skip{print} /<!-- dev-environment:end -->/{skip=0}' \
      "$target" >"$tmp"
  elif [ -f "$target" ]; then
    cp "$target" "$tmp"
    printf '\n' >>"$tmp"
    echo "NOTE: $target existed — the dev-environment block was appended. Review the merge."
  fi
  {
    echo '<!-- dev-environment:start -->'
    cat "$source"
    echo '<!-- dev-environment:end -->'
  } >>"$tmp"
  mv "$tmp" "$target"
  echo "Merged $(basename "$source") ($TIER tier) into $target"
}

merge_block "$PROJECT/AGENTS.md" "$REPO/agents-files/$TIER/AGENTS.md"

# 5. Platform adapters
CLAUDE_ARGS=(--project "$PROJECT")
[ "$ASSUME_YES" = 1 ] && CLAUDE_ARGS[${#CLAUDE_ARGS[@]}]="--yes"
case ",$PLATFORMS," in *,claude,*) bash "$REPO/adapters/claude-code/install.sh" "${CLAUDE_ARGS[@]}" ;; esac
case ",$PLATFORMS," in *,opencode,*) bash "$REPO/adapters/opencode/install.sh" --project "$PROJECT" ;; esac

# 6. Git hooks
HOOKS="$(ask "$HOOKS" "Install git hooks (pre-commit/pre-push quality gate)?" "yes")"
if [ "$HOOKS" = "yes" ]; then
  bash "$REPO/scripts/setup-hooks.sh" --project "$PROJECT"
fi

# 7. Report
echo ""
echo "== Installed =="
echo "- AGENTS.md ($TIER tier) merged into $PROJECT"
echo "- Platforms: $PLATFORMS"
echo "- Git hooks: $HOOKS"
echo ""
echo "Next steps:"
echo "  1. Review $PROJECT/AGENTS.md (and CLAUDE.md if created)"
echo "  2. Run: $REPO/scripts/check-prereqs.sh --project $PROJECT   (add --install to fetch what's missing)"
echo "  3. Run: $REPO/scripts/check.sh --project $PROJECT"
echo ""
echo "Later, after updating the submodule:"
echo "  $REPO/scripts/check-install.sh --project $PROJECT   (reports what has drifted)"
