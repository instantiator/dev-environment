#!/usr/bin/env bash
# Checks that the tools a project needs are installed, prints the install
# command for anything missing, and optionally installs them.
#
# Usage: check-prereqs.sh [--project <dir>] [--install]
#   --install  run the install command for each missing tool, then re-check
# Exit code: 1 if any REQUIRED tool is still missing, else 0.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

PROJECT="."; INSTALL=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:?--project needs a directory}"; shift ;;
    --install) INSTALL=1 ;;
    --help|-h) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

cd "$PROJECT"
STACKS="$(detect_stacks .)"

# Which package manager this machine installs with: brew, apt, winget, unknown
detect_installer() {
  case "$(uname -s)" in
    Darwin) echo "brew" ;;
    # NB. assumes a Debian-family package manager; on Fedora or Arch, read the
    # printed command and translate it
    Linux) echo "apt" ;;
    MINGW*|MSYS*|CYGWIN*) echo "winget" ;;
    *) echo "unknown" ;;
  esac
}
INSTALLER="$(detect_installer)"

# Install commands collected for the tools found to be missing
MISSING_CMDS=()
MISSING_REQUIRED=0

# Check one tool and record the outcome, remembering how to install it:
#   check_tool <required|optional> <cmd> <brew-cmd> <apt-cmd> <winget-cmd>
#
# NB. the last three are complete shell commands, not package names, so tools
# installed by pip or npm fit the same table as tools installed by brew.
check_tool() {
  local level="$1" cmd="$2" brew="$3" apt="$4" winget="$5" install=""
  if has_cmd "$cmd"; then
    record_result "$cmd" PASS
    return 0
  fi
  case "$INSTALLER" in
    brew) install="$brew" ;;
    apt) install="$apt" ;;
    winget) install="$winget" ;;
  esac
  if [ -z "$install" ]; then
    install="(no install command known for this OS)"
  else
    MISSING_CMDS[${#MISSING_CMDS[@]}]="$install"
  fi
  if [ "$level" = "required" ]; then
    record_result "$cmd" FAIL "install: $install"
    MISSING_REQUIRED=1
  else
    record_result "$cmd" SKIP "optional — install: $install"
  fi
}

echo "check-prereqs.sh — stacks: $(echo "${STACKS:-none}" | tr '\n' ' ')"

check_tool required git "brew install git" "sudo apt install -y git" "winget install Git.Git"

for stack in $STACKS; do
  case "$stack" in
    node)
      check_tool required node "brew install node" "sudo apt install -y nodejs" "winget install OpenJS.NodeJS.LTS"
      check_tool required npm "brew install node" "sudo apt install -y npm" "winget install OpenJS.NodeJS.LTS"
      ;;
    dotnet)
      check_tool required dotnet "brew install dotnet-sdk" "sudo apt install -y dotnet-sdk-8.0" "winget install Microsoft.DotNet.SDK.8"
      ;;
    python)
      check_tool required python3 "brew install python" "sudo apt install -y python3" "winget install Python.Python.3.12"
      check_tool required ruff "brew install ruff" "pip install ruff" "pip install ruff"
      check_tool optional mypy "pip install mypy" "pip install mypy" "pip install mypy"
      check_tool optional pytest "pip install pytest" "pip install pytest" "pip install pytest"
      check_tool optional pip-audit "pip install pip-audit" "pip install pip-audit" "pip install pip-audit"
      ;;
  esac
done

if find . -name '*.sh' -not -path './node_modules/*' -not -path './.git/*' | grep -q .; then
  check_tool optional shellcheck "brew install shellcheck" "sudo apt install -y shellcheck" "winget install koalaman.shellcheck"
fi
if find . -name '*.md' -not -path './node_modules/*' -not -path './.git/*' | grep -q .; then
  check_tool optional markdownlint "npm i -g markdownlint-cli" "npm i -g markdownlint-cli" "npm i -g markdownlint-cli"
fi
if [ -f Dockerfile ] || ls docker-compose*.y*ml compose*.y*ml >/dev/null 2>&1; then
  check_tool optional docker "brew install docker" "sudo apt install -y docker.io" "winget install Docker.DockerDesktop"
  check_tool optional hadolint "brew install hadolint" "sudo apt install -y hadolint" "winget install hadolint.hadolint"
fi
if [ -d .github/workflows ] || [ -d .gitea/workflows ]; then
  check_tool optional actionlint "brew install actionlint" "sudo apt install -y actionlint" "winget install rhysd.actionlint"
fi

report_results || true

# With --install, run each collected command and then re-check. One failure
# does not stop the rest: a missing optional tool is not fatal.
if [ "$INSTALL" = 1 ] && [ "${#MISSING_CMDS[@]}" -gt 0 ]; then
  echo ""
  echo "== Installing ${#MISSING_CMDS[@]} missing tool(s) via $INSTALLER =="
  i=0
  while [ "$i" -lt "${#MISSING_CMDS[@]}" ]; do
    echo ""
    echo "-- ${MISSING_CMDS[$i]}"
    if ! eval "${MISSING_CMDS[$i]}"; then
      echo "   failed — install this one by hand" >&2
    fi
    i=$((i + 1))
  done
  echo ""
  echo "== Re-checking =="
  exec "$SCRIPT_DIR/check-prereqs.sh"
fi

exit "$MISSING_REQUIRED"
