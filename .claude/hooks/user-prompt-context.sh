#!/usr/bin/env bash
# UserPromptSubmit hook: inject a 1-line repo state header so the agent
# always sees current branch, tree cleanliness, and the latest design doc.
# Keep output small — it attaches to every user prompt.
set -uo pipefail

branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
branch="${branch:-detached}"

if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
  tree="clean"
else
  tree="dirty"
fi

latest_design=""
if [ -d docs/designs ]; then
  latest_design="$(ls -t docs/designs/*.md 2>/dev/null | head -n1 || true)"
fi

printf '[state] branch=%s tree=%s' "$branch" "$tree"
[ -n "$latest_design" ] && printf ' latest_design=%s' "$latest_design"
printf '\n'

exit 0
