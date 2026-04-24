#!/usr/bin/env bash
# PreToolUse hook for Bash: block commits that carry Claude/AI trailers.
# Policy: CLAUDE.md — no `claude.ai/code`, `Co-authored-by: Claude`,
# "🤖 Generated with ...", or "Anthropic" in commit messages.
set -uo pipefail

# Hook input arrives on stdin as JSON: {"tool_name":"Bash","tool_input":{"command":"..."}}
input="$(cat || true)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null)"

# Only guard git commit invocations.
case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

if printf '%s' "$cmd" | grep -qiE 'claude\.ai/code|co-authored-by:[[:space:]]*claude|🤖[[:space:]]*generated with|\banthropic\b'; then
  cat <<'EOF' >&2
Commit blocked by pre-commit-guard:
  The commit message contains a Claude/AI trailer.
  Remove references to: claude.ai/code, "Co-authored-by: Claude",
  "🤖 Generated with ...", or "Anthropic" (policy: CLAUDE.md).
EOF
  exit 2
fi

exit 0
