#!/usr/bin/env bash
# Template for a per-suite test launch script.
# Copy to <project>/scripts/run-<suite>-tests.sh and fill in the TODO blocks.
# Convention: each suite script is self-contained — it starts and stops
# anything it needs, and exits with the test runner's exit code.
set -euo pipefail

cd "$(dirname "$0")/.."

# TODO: start required services (delete this block if none are needed), e.g.:
# docker compose up -d --wait db
# trap 'docker compose down' EXIT

# TODO: replace with the real runner for this suite, e.g.:
# npm run test:integration
echo "TODO: no test command configured in $0" >&2
exit 2
