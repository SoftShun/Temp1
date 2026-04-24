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
- `/design <topic>` — `architect` → 내장 `Plan` 이중 검증(ultrathink). 설계 합의 전 구현 금지.
- `/cross-review [ref|path]` — 리뷰어 4종(위 표) **병렬** + 사용자 로컬 Codex = 5관점. Blockers/Agrees/Disagrees/Gaps/QA plan 통합.
- `/commit-msg` — staged diff → Conventional Commits 초안 (실제 커밋 X).
- `/summarize-diff` — 작업 트리 변경 한눈 요약 + 위험 플래그.
- `/security-review` — 내장 `security-review` 스킬 래퍼.

## Hooks (`.claude/hooks/`)
- `session-start.sh` (SessionStart: startup|resume) — 브랜치·upstream·dirty + 최신 설계 문서 경로 출력. 세션 차단 안 함.
- `user-prompt-context.sh` (UserPromptSubmit) — 매 프롬프트에 `[state] branch=… tree=… latest_design=…` 헤더 주입. 방향 이탈·설계 누락을 매 턴 자동 환기.
- `pre-commit-guard.sh` (PreToolUse, matcher=`Bash`) — `git commit` 호출 직전 메시지에서 Claude/AI trailer(`claude.ai/code`, `Co-authored-by: Claude`, `🤖 Generated with`, `Anthropic`) 검출 시 exit 2로 차단.

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
