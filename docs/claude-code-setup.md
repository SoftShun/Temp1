# Claude Code 개발 환경

이 리포의 `.claude/` 프로젝트 설정 요약. 실제 정책·가드레일은 `CLAUDE.md` 참고.

## Subagents (`.claude/agents/`)
| 이름 | 모델 | 역할 |
|---|---|---|
| `architect` | opus | 설계 전담 — 요구/제약/옵션/트레이드오프/수용기준 문서만 생성, 코드 X |
| `code-reviewer` | opus | 전체 리뷰 — correctness·설계 일관성·가독성·테스트 커버리지 |
| `ux-a11y-reviewer` | haiku | WCAG 2.2 AA·UX 관점 리뷰 (빠른 규칙 기반) |
| `frontend-security-reviewer` | sonnet | OWASP/XSS/CSP/auth/secret 관점 리뷰 |
| `qa-tester` | sonnet | 수용기준 매핑, 엣지케이스, 회귀 위험, 수동 QA 스크립트, 자동 테스트 제안 |
| `web-researcher` | haiku | 외부 문서·웹 조사 (요약+URL만 반환) |
| `doc-writer` | haiku | markdown 문서 작성·수정 |

## Slash Commands (`.claude/commands/`)
문서화 파이프라인:
- `/prd <slug>` — Product Requirements Document 작성 → `docs/prd/<slug>.md`.
- `/design <topic>` — ultrathink + architect + 내장 Plan 이중 검증 → `docs/designs/<slug>.md`.
- `/task-breakdown [path]` — PRD/설계를 `docs/tasks/T-NNN-<slug>.md` 다수로 분해.
- `/adr <title>` — ADR 자동 번호 할당 → `docs/adr/NNN-<slug>.md`.
- `/session-log [slug]` — 세션 요약 → `docs/history/YYYY-MM-DD-<slug>.md`.

리뷰·개발 보조:
- `/cross-review [ref|path]` — 리뷰어 4종 **병렬** + 사용자 로컬 Codex = 5관점. Blockers/Agrees/Disagrees/Gaps/QA plan 통합.
- `/commit-msg` — staged diff → Conventional Commits 초안(커밋 X).
- `/summarize-diff` — 작업 트리 변경 한눈 요약 + 위험 플래그.
- `/security-review` — 내장 `security-review` 스킬 래퍼.

## Hooks (`.claude/hooks/`)
- `session-start.sh` (SessionStart: startup|resume) — 브랜치·upstream·dirty + 최신 설계 문서 경로 + 컨텍스트 팩 존재 여부 출력.
- `user-prompt-context.sh` (UserPromptSubmit) — 매 프롬프트에 `[state] branch=… tree=… latest_design=…` 헤더 주입.
- `pre-commit-guard.sh` (PreToolUse, matcher=`Bash`) — `git commit` 호출 직전 메시지에서 Claude/AI trailer 검출 시 exit 2로 차단.
- `pre-compact.sh` (PreCompact) — compact 직전 현재 상태를 `.claude/context/pack.md`에 동결. 포함: git 상태·최근 커밋 10개·최신 PRD/설계/ADR/태스크 경로·열린 태스크. 수동으로는 `/snapshot`.

## Context management
`.claude/context/pack.md`(gitignored)와 `docs/history/*.md`(영구)를 2중으로 유지한다. compact 후 첫 턴은 반드시 팩을 먼저 Read 한 뒤 진행한다. 자세한 규칙은 `CLAUDE.md`의 "Context management" 섹션 참고.

## MCP (`.mcp.json`)
- `context7` — 최신 라이브러리 문서 즉시 주입. API 키는 `CONTEXT7_API_KEY` 환경변수 참조, 커밋 금지.
- 기타(Playwright / Chrome DevTools / Figma / Supabase / Vercel 등)는 스택·계정 확정 후 `--scope user`로 추가.

## Permissions (`.claude/settings.json`)
- `allow`: 언어중립 read-only Bash(git 조회, ls, grep, find, rg, jq, bash -n 등) + `Skill`·`Read`·`Grep`·`Glob`.
- `deny`: `.env*`, `secrets/**` 읽기 금지. `curl`/`wget` 금지.
- `ask` 게이트: `git push`, `rm -rf`, `git reset --hard`.
- 스택 확정 시 `npm`, `pnpm`, `pytest`, `go test` 등 필요한 명령 추가.

## Optional tooling (수동 설치)
- **TypeScript LSP 플러그인** (스택이 TS/JS일 때): `/plugin install typescript-lsp@claude-plugins-official`
- **Codex CLI** (correctness 관점 추가): `npm i -g @openai/codex` → `codex` 실행 후 "Sign in with ChatGPT".
