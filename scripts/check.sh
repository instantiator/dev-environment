#!/usr/bin/env bash
# The quality gate. Detects the project type, then runs:
#   format check -> lint -> typecheck -> build -> unit tests -> aislop scan
# and prints a PASS/FAIL/SKIP table with a fix-hint per failure.
# Missing tools SKIP with an install hint; the gate never crashes on absence.
#
# Usage: check.sh [--fast] [--fix] [--suite <name>] [--project <dir>]
#   --fast          skip build, tests, and aislop (used by the pre-commit hook)
#   --fix           apply formatters/autofixes before checking
#   --suite <name>  additionally run one test suite via run-tests.sh
#   --project <dir> project directory (default: current directory)
# Exit code: 0 only when no stage FAILs.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

FAST=0; FIX=0; SUITE=""; PROJECT="."
while [ $# -gt 0 ]; do
  case "$1" in
    --fast) FAST=1 ;;
    --fix) FIX=1 ;;
    --suite) SUITE="${2:?--suite needs a name}"; shift ;;
    --project) PROJECT="${2:?--project needs a directory}"; shift ;;
    --help|-h)
      sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

cd "$PROJECT"
TYPE="$(detect_project_type .)"
echo "check.sh — project type: $TYPE$( [ "$FAST" = 1 ] && echo ' (fast mode)')"

# Run one stage and record the outcome: run_stage <name> <hint-on-fail> <command...>
run_stage() {
  local name="$1" hint="$2"; shift 2
  echo ""
  echo "-- $name: $*"
  if "$@"; then
    record_result "$name" PASS
  else
    record_result "$name" FAIL "$hint"
  fi
}

if [ "$TYPE" = "node" ]; then
  # Apply autofixes first when asked
  if [ "$FIX" = 1 ]; then
    npm_has_script . format && run_stage "format-fix" "review formatter output" npm run format
    npm_has_script . lint && run_stage "lint-fix" "review lint output" npm run lint
  fi
  # Format check (only when a dedicated check script exists; else lint covers it)
  if npm_has_script . "format:check"; then
    run_stage "format" "run: npm run format" npm run format:check
  else
    record_result "format" SKIP "no format:check script; assuming lint covers formatting"
  fi
  # Lint (prefer a non-mutating script)
  if npm_has_script . "lint:check"; then
    run_stage "lint" "run: npm run lint" npm run lint:check
  elif npm_has_script . lint; then
    run_stage "lint" "fix reported lint problems" npm run lint
  else
    record_result "lint" SKIP "add a lint script (see guidance/languages/typescript.md)"
  fi
  # Typecheck
  if npm_has_script . typecheck; then
    run_stage "typecheck" "fix reported type errors" npm run typecheck
  elif [ -f tsconfig.json ]; then
    run_stage "typecheck" "fix reported type errors" npx --no-install tsc --noEmit
  else
    record_result "typecheck" SKIP "no typecheck script or tsconfig.json"
  fi
  if [ "$FAST" = 0 ]; then
    if npm_has_script . build; then
      run_stage "build" "fix build errors/warnings" npm run build
    else
      record_result "build" SKIP "no build script"
    fi
    if npm_has_script . test; then
      run_stage "unit-tests" "fix failing tests" npm test
    else
      record_result "unit-tests" SKIP "no test script (see guidance/standards/testing.md)"
    fi
  fi

elif [ "$TYPE" = "dotnet" ]; then
  if ! has_cmd dotnet; then
    record_result "dotnet" SKIP "install the .NET SDK (mac: brew install dotnet-sdk)"
  else
    if [ "$FIX" = 1 ]; then
      run_stage "format-fix" "review formatter output" dotnet format
    fi
    run_stage "format" "run: dotnet format" dotnet format --verify-no-changes
    if [ "$FAST" = 0 ]; then
      # Analyzers run within the build, so build doubles as lint
      run_stage "build" "fix build errors/warnings" dotnet build --nologo
      run_stage "unit-tests" "fix failing tests" dotnet test --nologo
    fi
  fi

else
  record_result "project" SKIP "no package.json or .csproj found; running generic checks only"
fi

# Generic stages for any project type
if find . -name '*.sh' -not -path './node_modules/*' -not -path './.git/*' | grep -q .; then
  if has_cmd shellcheck; then
    # Word-splitting the file list is intended here
    # shellcheck disable=SC2046
    run_stage "shellcheck" "fix shellcheck findings" shellcheck $(find . -name '*.sh' -not -path './node_modules/*' -not -path './.git/*')
  else
    record_result "shellcheck" SKIP "install shellcheck (mac: brew install shellcheck)"
  fi
fi

if [ "$FAST" = 0 ] && [ "$TYPE" = "node" ]; then
  if npx --yes aislop@latest --version >/dev/null 2>&1; then
    # With a project config, use the ci command (score threshold, ratchetable);
    # bare scan exits non-zero on any finding, including warnings-only.
    if [ -f .aislop/config.yml ]; then
      run_stage "aislop" "fix reported slop (see guidance/standards/pitfalls.md)" npx --yes aislop@latest ci
    else
      run_stage "aislop" "fix reported slop (see guidance/standards/pitfalls.md)" npx --yes aislop@latest scan
    fi
  else
    record_result "aislop" SKIP "optional: npm i -D aislop, or npx aislop scan"
  fi
fi

# Optional extra suite
if [ -n "$SUITE" ]; then
  run_stage "suite:$SUITE" "fix failing $SUITE tests" "$SCRIPT_DIR/run-tests.sh" "$SUITE"
fi

report_results
