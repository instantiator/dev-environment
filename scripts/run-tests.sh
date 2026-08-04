#!/usr/bin/env bash
# Test suite dispatcher. Prefers the project's own per-suite scripts
# (scripts/run-<suite>-tests.sh), falling back to npm / dotnet conventions.
#
# Usage: run-tests.sh <suite> [--project <dir>]
#   <suite>  unit | integration | e2e | browser | api | smoke | all | ...
# Exit code: that of the underlying test run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

SUITE="${1:-}"; PROJECT="."
[ "$SUITE" = "--help" ] || [ "$SUITE" = "-h" ] || [ -z "$SUITE" ] && {
  sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; [ -n "$SUITE" ] && exit 0 || exit 2
}
shift
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?--project needs a directory}"; shift ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

cd "$PROJECT"
TYPE="$(detect_project_type .)"

# 'all' runs the project's orchestrator, or every discovered suite in turn
if [ "$SUITE" = "all" ]; then
  if [ -x "scripts/run-all-tests.sh" ]; then
    exec scripts/run-all-tests.sh
  fi
  found=0
  for script in scripts/run-*-tests.sh; do
    [ -e "$script" ] || continue
    found=1
    echo "== $script =="
    bash "$script"
  done
  if [ "$found" = 1 ]; then exit 0; fi
  SUITE="unit"  # nothing discovered: fall through to the default suite
fi

# Project convention first: scripts/run-<suite>-tests.sh
if [ -e "scripts/run-$SUITE-tests.sh" ]; then
  exec bash "scripts/run-$SUITE-tests.sh"
fi

# Fallbacks by project type
case "$TYPE" in
  node)
    if [ "$SUITE" = "unit" ] && npm_has_script . test; then
      exec npm test
    elif npm_has_script . "test:$SUITE"; then
      exec npm run "test:$SUITE"
    fi
    ;;
  dotnet)
    exec dotnet test --nologo
    ;;
  python)
    # pytest markers are the per-tier convention when there are no tier scripts
    if [ "$SUITE" = "unit" ] && has_cmd pytest; then
      exec pytest
    elif has_cmd pytest; then
      exec pytest -m "$SUITE"
    fi
    ;;
esac

echo "No runner found for suite '$SUITE' (looked for scripts/run-$SUITE-tests.sh," >&2
echo "an npm 'test:$SUITE' script, or a dotnet/python project). See guidance/standards/testing.md." >&2
exit 2
