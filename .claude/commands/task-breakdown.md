---
description: Break a PRD or design doc into individually tracked task files
---

ultrathink

Break down into implementable tasks: $ARGUMENTS

## Workflow
1. `$ARGUMENTS`가 파일 경로면 그대로 사용. 비어있으면 최근 수정된 `docs/prd/*.md` → `docs/designs/*.md` 순서로 가장 최신 파일 선택.
2. 입력 문서의 Requirements / Acceptance criteria / Open questions를 읽는다.
3. 각 작업은 반나절~이틀(M 또는 L)로 수렴하도록 쪼갠다. XL이 나오면 재분할한다.
4. `docs/tasks/` 스캔 → 현재 최대 `T-NNN` 다음 번호부터 할당.
5. 각 태스크를 `docs/templates/task.md` 포맷으로 `docs/tasks/T-NNN-<slug>.md`에 저장.
6. 태스크 간 의존관계는 각 파일의 `Depends on:` 필드에 기록.
7. 결과는 표(번호 / 제목 / Priority / Effort / Depends)만 반환. 본문은 파일에만.

## Rules
- Priority 3단계: P0 블로커 / P1 주요 / P2 개선.
- Acceptance criteria는 각 태스크별 **최소 2개** 채우고, 모두 체크 가능한(측정) 형태.
- 의존 체인이 3단 이상이면 상위 작업을 재분할한다.
- 커밋은 하지 않는다. 태스크 파일만 작업 트리에 남긴다.
