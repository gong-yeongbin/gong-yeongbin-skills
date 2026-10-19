# Stage 1 — 컨텍스트 로드 + intent 인터뷰 + intent.md

목표. 요구사항을 `intent/_tmp/<slug>/intent.md` 로 굳힌다. 사람이 읽을 수 있고 다음 단계가 그대로 읽을 수 있는 문서다.

## 1-1. 컨텍스트 로드 (Stage 0 과 같은 턴)

1. 요구사항 자유 텍스트에서 URL·파일 경로·예시를 골라낸다. Notion URL 은 `notion-fetch`, 저장소 파일은 `Read`, 그 외 URL 은 `WebFetch`.
2. `intent/` 디렉터리를 살핀다.
   - 없으면 Stage 1 종료 시 새로 만든다.
   - `intent/README.md` 가 있으면 먼저 읽는다. 폴더 규칙의 단일 출처이며 아래 관찰과 스킬 기본 규칙보다 우선한다.
   - 기존 폴더의 이름·계층 규칙을 읽어 둔다 (구간 폴더 2뎁스인지, 평면 1뎁스인지). Stage 3 의 이동 규칙에 쓴다.
   - 같은 slug 폴더가 이미 있으면 [STOP] 하고 덮어쓸지 다른 slug 로 갈지 묻는다. `intent/_tmp/<slug>/`, `intent/*/<iid>-<slug>/`(GitHub 대상), `intent/<slug>/`(Notion·file 대상) 을 모두 본다. `intent/` 자체가 없으면 충돌 없음이다.
3. `baseline.md` 를 읽는다. 프로젝트 `./.claude/skills/create-issues/baseline.md` 가 있으면 그것, 없으면 스킬 폴더의 것. 각 섹션을 메모리에 둔다. 없거나 비어 있으면 `baseline_available: false`.
4. 프로젝트 도메인 문서를 훑는다. `CLAUDE.md`, `CONTEXT.md`, `docs/adr/` 가 있으면 용어와 결정을 기억해 둔다. spec 에서 그 용어를 쓴다.
5. TEST 필요 여부 1차 판단을 재확인한다 (SKILL.md §TEST 이슈 강제 규칙).

## 1-2. intent 인터뷰 (한 번에 하나씩)

`grilling.md` 절차로 질문을 하나씩 묻는다. 프론티어의 씨앗은 intent 여섯 섹션에서 나온다. 자유 텍스트와 컨텍스트로 이미 답이 분명한 항목은 묻지 않고 "이렇게 이해했다" 로 확인만 받는다. Stage 0 사실 확인 표는 첫 질문 앞에 한 번만 보인다.

| intent 섹션 | 질문 씨앗 |
| --- | --- |
| Problem | 지금 무엇이 안 되는가. 누가 언제 아픈가. 왜 지금인가. |
| Proposed outcome | 끝났을 때 무엇이 관찰되는가. 성공을 어떻게 아는가. |
| Affected users and systems | 어떤 사용자·역할, 어떤 저장소·모듈·외부 시스템·데이터가 닿는가. |
| Constraints | 지켜야 할 정책·계약·기술 제약. 하지 말아야 할 것. |
| Out of scope | 인접하지만 이번에 안 하는 것. |
| Open questions | 지금 답할 수 없는 것. 누가 답해야 하는가. |

- 코드로 알 수 있는 것(모듈이 어디 있는지, 호출처가 몇 개인지)은 묻지 않고 찾는다.
- TEST 필요 여부가 `tentative` 나 `undecided` 면 인터뷰 중 질문 하나로 확정한다. `confirmed: yes (강제)` 면 안건에서 뺀다.
- 답이 만든 새 프론티어에서 다음 질문 하나를 고른다. 프론티어가 비면 인터뷰를 끝낸다.

## 1-3. intent.md 작성

인터뷰가 끝나면 같은 턴에서 수행한다.

1. `templates.md` §1 골격으로 본문을 만든다. Author 는 `git config user.name` / `user.email`. Status 는 `draft`.
2. **구현 결정 걸러내기.** 쓰기 전에 Constraints·Proposed outcome 각 줄을 훑는다. 도구명·스킬명·파일 경로·명령·함수명이 들어간 줄은 intent 에서 빼고 "spec 으로 이월" 메모에 모아 둔다 (Stage 2 Implementation Decisions 의 씨앗). 메모는 파일로 만들지 않고 메인 세션이 기억한다. 길면 `<TMP>/<slug>_carry-over.md` 에 둔다. 정책·계약·금지만 남긴다. 시점 의존 수치는 상대 표현으로 바꾼다.
3. `intent/_tmp/<slug>/intent.md` 를 `Write` 한다 (`mkdir -p` 필요).
4. 어시스턴트 메시지로 본문을 출력하지 않는다. 경로와 섹션별 한 줄 요약 표만 보인다.

## 1-4. 확정 게이트 (사용자 입력)

```
intent/_tmp/<slug>/intent.md 를 작성했습니다. 파일을 열어 검토·수정해 주세요.

| 섹션 | 요약 |
| --- | --- |
| Problem | ... |
| Proposed outcome | ... |
| Affected users and systems | ... |
| Constraints | ... |
| Out of scope | ... |
| Open questions | N건 |
| spec 으로 이월한 구현 결정 | N건 (예. 배포 도구 선택, 검증 명령) |

[STOP] intent 를 확정하고 Stage 2 (spec) 로 진행할까요? (y/n)
```

- `y` → 파일을 다시 `Read` 한다 (사용자가 직접 고쳤을 수 있다). Status 를 `accepted` 로 `Edit` 한다. Stage 2 진입.
- `n` → 무엇을 바꿀지 묻고 인터뷰 또는 문서를 고친 뒤 게이트를 다시 보인다.
- 그 외 비명시 응답 → 같은 게이트를 다시 보인다.
- 게이트 메시지에는 표와 질문 외의 문장(다음 단계 예고 등)을 넣지 않는다.
