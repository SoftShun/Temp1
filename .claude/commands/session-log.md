---
description: Snapshot today's session into docs/history as a dated log
---

Summarize the current session's work into `docs/history/YYYY-MM-DD-<slug>.md`.

## Workflow
1. 날짜: 시스템 현재 날짜(UTC)를 `YYYY-MM-DD` 형식으로.
2. 슬러그: `$ARGUMENTS` 우선. 없으면 오늘 가장 큰 변경의 주제를 `git log --since=midnight --oneline`에서 추출해 kebab-case로.
3. 본문에 다음을 포함:
   - **Summary** — 3~5줄, 오늘 한 일 핵심.
   - **Commits** — `git log --since=<session-start>` 해시+제목.
   - **Touched files** — `git diff --stat`.
   - **Decisions** — 오늘 만든/갱신한 ADR·PRD 링크.
   - **Open / next** — 내일/다음 세션에 이어갈 것.
4. 파일을 저장하고 경로만 반환. 커밋은 사용자 판단.

## Rules
- 본문은 **600단어 이내**로 압축. 기록의 핵심은 "왜 이걸 했나" 와 "다음에 뭘 할까" 두 가지.
- 민감 정보(토큰·비밀번호)는 어떤 경우에도 본문에 포함하지 않는다.
- 파일이 이미 존재하면 슬러그 뒤에 `-2`, `-3` 으로 증분.
