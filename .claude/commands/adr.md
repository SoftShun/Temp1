---
description: Create an Architecture Decision Record with auto-incremented number
---

Capture an architectural decision as an ADR for: $ARGUMENTS

## Workflow
1. `docs/adr/` 디렉터리를 스캔해 가장 큰 `NNN`을 찾고, `NNN+1`을 3자리로 포맷(`001`부터).
2. 파일명은 `docs/adr/NNN-<kebab-slug>.md`. 슬러그는 제목에서 추출.
3. `docs/templates/adr.md` 포맷을 그대로 따른다.
4. Context는 리포의 현 상태(관련 코드·PRD·이전 ADR)에서 추출. 모호하면 사용자에게 **한 번만** 질문.
5. Decision은 한 문단 안에 단언형("우리는 X를 한다")으로.
6. Alternatives는 **최소 2개** + 각 기각 사유 필수.
7. 저장 후 파일 경로 + 결정 한 줄 + 상태(Status)만 요약 반환.

## Rules
- Status 기본값은 `proposed`. 사용자가 "결정났다"는 뉘앙스로 지시하면 `accepted`로 올린다.
- 이전 ADR을 대체하는 경우: 새 ADR에 "supersedes ADR-XXX", 구 ADR에 "superseded by ADR-NNN" 양쪽을 모두 업데이트한다.
- 커밋은 하지 않는다.
