# Temp1 — Claude Code Project Memory

## Purpose
웹 + 앱 개발 예정. 구체 스택·목적 미확정. 스택이 확정되면 이 섹션과 `README.md`를 먼저 채움.

## Conventions
- 커밋 메시지: Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `perf:`, `build:`, `ci:`).
- **커밋 메시지에 Claude 관련 trailer·태그·세션 URL을 절대 삽입하지 않는다.** `https://claude.ai/code/...` 포함 자동 문구 금지.
- 라인 끝: LF (`.gitattributes` 강제). 인코딩 UTF-8. 기본 indent 2 spaces.
- 브랜치: 기능 브랜치에서 작업 → squash 머지 선호.

## Design-first policy
- 새 기능·모듈 착수 전 `/design <topic>`으로 설계 산출물(10섹션)을 확정한다.
- `/design`은 내부에서 `architect`(opus) 설계 → 내장 `Plan` 에이전트 독립 검증의 **울트라 플랜** 2단계를 수행. 두 관점 불일치는 사용자에게 조정 요청한다.
- 설계 합의 전 구현을 시작하지 않는다. 구현 중 설계와 어긋나는 판단이 필요하면 코드 변경 전 `architect`를 재호출한다.
- 설계 산출물은 `docs/designs/<kebab-case-slug>.md`로 버전 관리한다.

## Parallel delegation policy
- 메인 세션은 설계·핵심 구현에 집중. 리서치·문서화·UI 스캐폴드·리뷰·QA는 서브에이전트에 **병렬** 위임한다.
- 서브에이전트 출력은 "요약 + file:line + 제안"만 허용. raw 로그·전체 파일 에코 금지.
- 병렬 호출은 토큰 비용이 선형으로 늘어나므로, `/cross-review`는 PR급 변경에만 트리거한다.
- Agent Skills는 재사용 절차(`/review`, `/security-review`, `/summarize-diff` 등)에, 서브에이전트는 독립 컨텍스트가 필요한 장기 탐색·문서화·리뷰에 쓴다.

## Review workflow (다모델·다관점 크로스체크)
PR 또는 큰 변경 전 `/cross-review`:
- `code-reviewer` (opus) — 전체(correctness·설계 일관성·가독성·테스트 커버리지).
- `ux-a11y-reviewer` (haiku) — WCAG 2.2 AA·UX.
- `frontend-security-reviewer` (sonnet) — OWASP·XSS·CSP·auth·secret.
- `qa-tester` (sonnet) — 수용기준 매핑·엣지케이스·회귀 위험·수동 QA 스크립트·자동 테스트 제안.
- **사용자 로컬 Codex CLI** — 추가 correctness 관점(외부 모델).

총 5관점. 리뷰어 간 `Disagrees`가 나오면 사용자가 조정.

## Delegation Guide
- **architect** — 설계 문서 작성(코드 X).
- **code-reviewer** — 전체 코드 리뷰.
- **ux-a11y-reviewer** — a11y·UX 리뷰.
- **frontend-security-reviewer** — 프런트엔드 보안 리뷰.
- **qa-tester** — QA 계획·엣지케이스·수동/자동 테스트 제안.
- **web-researcher** — 공식 문서·API 레퍼런스·버전 확인.
- **doc-writer** — README·CHANGELOG·주석 블록 작성.

## Automated guardrails (hooks)
- **UserPromptSubmit** 훅이 매 프롬프트에 `[state] branch=… tree=… latest_design=…` 를 주입한다 → 방향 이탈·dirty 누적·설계 미갱신이 매 턴 자동 환기된다.
- **PreToolUse(Bash)** 훅이 `git commit` 호출 직전 커밋 메시지를 검사 → Claude/AI trailer가 있으면 exit 2로 즉시 차단한다. 차단되면 trailer를 제거한 메시지로 재시도한다.
- **SessionStart** 훅이 세션 시작·재개 시 같은 상태 한 줄 + 최신 설계 문서 경로를 출력한다.

## Guardrails (.claude/settings.json)
- `git push`, `rm -rf`, `git reset --hard` 는 ask 게이트.
- `.env*`, `secrets/**` 읽기 금지. `curl`/`wget` 금지.
- 서드파티 플러그인 마켓은 훅 기반 권한 우회(PromptArmor 2025-10) 위험이 확인됐으므로 신중히 검토 후 추가. 추가 시 auto-update=off 기본.
- 새 언어/툴체인 명령(`npm run …`, `pytest`, `go test` 등)은 스택 확정 시 allow 리스트에 추가.

## Open Items
- 스택 확정 → `allow` 리스트 보강, Playwright/Chrome-DevTools MCP 추가 검토.
- 실제 프로젝트 구조(`src/`, `tests/`, `app/` 등) 결정 시 이 파일 업데이트.
- `README.md`의 서비스 목적·사용자·핵심 기능 채우기.
