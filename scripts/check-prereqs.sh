#!/usr/bin/env bash
# Checks that the tools a project needs are installed, and prints per-OS
# install commands for anything missing.
#
# Usage: check-prereqs.sh [--project <dir>]
# Exit code: 1 if any REQUIRED tool is missing, else 0.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

PROJECT="."
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?--project needs a directory}"; shift ;;
    --help|-h) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

cd "$PROJECT"
TYPE="$(detect_project_type .)"
MISSING_REQUIRED=0

# Report one tool: check_tool <required|optional> <cmd> <brew> <apt> <winget>
check_tool() {
  local level="$1" cmd="$2" brew="$3" apt="$4" winget="$5"
  if has_cmd "$cmd"; then
    record_result "$cmd" PASS
  elif [ "$level" = "required" ]; then
    record_result "$cmd" FAIL "install: brew install $brew | apt install $apt | winget install $winget"
    MISSING_REQUIRED=1
  else
    record_result "$cmd" SKIP "optional — install: brew install $brew | apt install $apt | winget install $winget"
  fi
}

echo "check-prereqs.sh — project type: $TYPE"

check_tool required git git git Git.Git
case "$TYPE" in
  node)
    check_tool required node node nodejs OpenJS.NodeJS.LTS
    check_tool required npm node npm OpenJS.NodeJS.LTS
    ;;
  dotnet)
    check_tool required dotnet dotnet-sdk dotnet-sdk-8.0 Microsoft.DotNet.SDK.8
    ;;
esac
if find . -name '*.sh' -not -path './node_modules/*' -not -path './.git/*' | grep -q .; then
  check_tool optional shellcheck shellcheck shellcheck koalaman.shellcheck
fi
if [ -f Dockerfile ] || ls docker-compose*.y*ml compose*.y*ml >/dev/null 2>&1; then
  check_tool optional docker docker docker.io Docker.DockerDesktop
  check_tool optional hadolint hadolint hadolint hadolint.hadolint
fi
if [ -d .github/workflows ] || [ -d .gitea/workflows ]; then
  check_tool optional actionlint actionlint actionlint rhysd.actionlint
fi

report_results || true
exit "$MISSING_REQUIRED"
