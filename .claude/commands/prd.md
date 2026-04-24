---
description: Draft a Product Requirements Document for a feature
---

ultrathink

Create a PRD for: $ARGUMENTS

## Workflow
1. 슬러그(파일명)가 명확하지 않으면 사용자에게 **한 번만** 확인하고 진행.
2. `docs/templates/prd.md`를 읽어 그 구조를 그대로 따른다.
3. 배경 자료는 다음 순으로 탐색: 사용자 프롬프트 → `README.md` → 기존 `docs/prd/*.md` → 최신 `docs/designs/*.md`.
4. 경쟁 제품·도메인 관례가 필요하면 `web-researcher` 서브에이전트에 위임(요약+URL만 받는다).
5. 작성한 PRD를 `docs/prd/<kebab-slug>.md`로 저장한다. 커밋은 사용자 판단에 맡긴다.
6. 결과는 파일 경로 + 핵심 결정 3줄 + Open questions 목록만 반환.

## Rules
- **Open questions 섹션에는 최소 2개**를 채운다 — 불확실성을 숨기지 않는다.
- Requirements는 Must / Should / Won't 3등급으로 분류한다.
- Success metrics는 측정 가능한 지표 또는 검증 방법을 포함한다.
- 추측이 아닌 정보는 References로 근거를 남긴다.
