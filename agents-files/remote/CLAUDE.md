# Claude Code instructions

Follow `dev-environment/agents-files/remote/AGENTS.md` — those rules are mandatory. If this project has its own AGENTS.md merged from it, that copy governs.

## Claude Code specifics

- Skills from `dev-environment/skills/` may be installed at `.claude/skills/` — prefer invoking them over improvising the same workflow.
- If hooks are configured (via `dev-environment/adapters/claude-code/`), `check.sh --fast` runs automatically after edits — read its output in the transcript and fix failures; don't re-run it redundantly.
- Otherwise run `dev-environment/scripts/check.sh` yourself after every change.
- Git hooks installed by `dev-environment/scripts/setup-hooks.sh` are the final gate: a failing pre-commit means fix the reported problems, never `--no-verify`.
