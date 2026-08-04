#!/usr/bin/env bash
# Shared helpers for dev-environment scripts: project-type detection,
# tool checks, and PASS/FAIL/SKIP result reporting.
# Source this file; do not execute it directly.

# Colour codes (disabled when not a terminal)
if [ -t 1 ]; then
  C_GREEN=$'\033[32m'; C_RED=$'\033[31m'; C_YELLOW=$'\033[33m'; C_RESET=$'\033[0m'
else
  C_GREEN=""; C_RED=""; C_YELLOW=""; C_RESET=""
fi

# True if a command exists on PATH
has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# Detect every stack present from marker files, one name per line.
#
# Prints any of "node", "dotnet", "python" — a polyglot repo prints several,
# a repo with no recognised markers prints nothing.
detect_stacks() {
  local dir="${1:-.}"
  if [ -f "$dir/package.json" ]; then
    echo "node"
  fi
  if ls "$dir"/*.sln >/dev/null 2>&1 || ls "$dir"/*.csproj >/dev/null 2>&1 \
    || ls "$dir"/*/*.csproj >/dev/null 2>&1; then
    echo "dotnet"
  fi
  if [ -f "$dir/pyproject.toml" ] || [ -f "$dir/setup.py" ] \
    || [ -f "$dir/requirements.txt" ]; then
    echo "python"
  fi
  return 0
}

# Detect the primary project type: the first stack found, or "unknown".
#
# NB. Kept for callers that handle one stack at a time (run-tests.sh,
# check-prereqs.sh); check.sh uses detect_stacks instead.
detect_project_type() {
  local first
  first="$(detect_stacks "${1:-.}" | head -n 1)"
  echo "${first:-unknown}"
}

# True if package.json in $1 declares an npm script named $2
npm_has_script() {
  local dir="$1" name="$2"
  [ -f "$dir/package.json" ] || return 1
  if has_cmd node; then
    node -e "process.exit(((require('$dir/package.json').scripts||{})['$name'])?0:1)" 2>/dev/null
  else
    # Fallback without node: crude but adequate for a presence check
    grep -q "\"$name\"[[:space:]]*:" "$dir/package.json"
  fi
}

# Result accumulators (parallel arrays: bash 3.2 has no associative arrays)
RESULT_NAMES=()
RESULT_STATES=()
RESULT_HINTS=()

# Record one stage result: record_result <name> <PASS|FAIL|SKIP> [hint]
record_result() {
  RESULT_NAMES[${#RESULT_NAMES[@]}]="$1"
  RESULT_STATES[${#RESULT_STATES[@]}]="$2"
  RESULT_HINTS[${#RESULT_HINTS[@]}]="${3:-}"
}

# Print the result table; return 1 if any stage FAILed
report_results() {
  local i state colour failed=0
  echo ""
  echo "== Results =="
  i=0
  while [ "$i" -lt "${#RESULT_NAMES[@]}" ]; do
    state="${RESULT_STATES[$i]}"
    case "$state" in
      PASS) colour="$C_GREEN" ;;
      FAIL) colour="$C_RED"; failed=1 ;;
      *)    colour="$C_YELLOW" ;;
    esac
    if [ -n "${RESULT_HINTS[$i]}" ]; then
      printf "%s%-4s%s %-18s — %s\n" "$colour" "$state" "$C_RESET" "${RESULT_NAMES[$i]}" "${RESULT_HINTS[$i]}"
    else
      printf "%s%-4s%s %s\n" "$colour" "$state" "$C_RESET" "${RESULT_NAMES[$i]}"
    fi
    i=$((i + 1))
  done
  return "$failed"
}
