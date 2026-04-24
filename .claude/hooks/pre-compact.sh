#!/usr/bin/env bash
# PreCompact hook: freeze key state to a local context pack so the
# post-compact agent can rehydrate without replaying the whole history.
# Also runnable manually (via /snapshot) at any turn.
set -uo pipefail

out=".claude/context/pack.md"
mkdir -p "$(dirname "$out")"

{
  printf '# Context pack\n\n'
  printf '_Written at: %s (UTC)_\n\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

  printf '## Git\n'
  branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
  printf -- '- branch: %s\n' "${branch:-detached}"
  upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)"
  printf -- '- upstream: %s\n' "${upstream:-none}"
  if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
    printf -- '- tree: clean\n'
  else
    printf -- '- tree: dirty\n'
    printf -- '- dirty files:\n'
    git status --short 2>/dev/null | sed 's/^/    /'
  fi
  printf -- '- recent commits:\n'
  git log --oneline -n 10 2>/dev/null | sed 's/^/    - /'

  printf '\n## Latest docs\n'
  for d in prd designs adr tasks history; do
    latest="$(ls -t docs/"$d"/*.md 2>/dev/null | head -n1 || true)"
    [ -n "$latest" ] && printf -- '- %s: %s\n' "$d" "$latest"
  done

  printf '\n## Open tasks (status != done)\n'
  if ls docs/tasks/*.md >/dev/null 2>&1; then
    for f in docs/tasks/*.md; do
      status="$(grep -E '^- Status:' "$f" 2>/dev/null | head -1 | sed 's/.*Status://' | tr -d ' ')"
      case "$status" in
        todo|in-progress|blocked)
          title="$(head -1 "$f" 2>/dev/null | sed 's/^# //')"
          printf -- '- %s (%s) — %s\n' "$title" "$status" "$f"
          ;;
      esac
    done
  fi

  printf '\n## Instructions for the post-compact agent\n'
  printf '1. Read this file first on resume to restore context.\n'
  printf '2. Re-read the linked PRD/design/ADR/tasks as needed — do not guess state from memory.\n'
  printf '3. If this pack conflicts with live repo state (e.g. the branch has moved), trust the live repo and refresh the pack via `/snapshot`.\n'
} > "$out"

exit 0
