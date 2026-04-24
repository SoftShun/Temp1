#!/usr/bin/env bash
# SessionStart hook: print a one-line repo summary. Never block the session.
set -uo pipefail

branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
branch="${branch:-detached}"
upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)"
upstream="${upstream:-none}"
if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
  dirty="clean"
else
  dirty="dirty"
fi
printf 'repo: branch=%s upstream=%s tree=%s\n' "$branch" "$upstream" "$dirty"

if [ -d docs/designs ]; then
  latest_design="$(ls -t docs/designs/*.md 2>/dev/null | head -n1 || true)"
  [ -n "$latest_design" ] && printf 'latest design: %s\n' "$latest_design"
fi

if [ -f .claude/context/pack.md ]; then
  printf 'context pack available: .claude/context/pack.md (Read this first to restore flow)\n'
fi

exit 0
