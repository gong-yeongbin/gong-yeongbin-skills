---
name: create-issues
description: >
  요구사항 자유 텍스트를 받아 (1) grilling 인터뷰로 intent.md 를 저장소 `intent/_tmp/<slug>/` 에 만들고 →
  (2) 코드베이스 탐색과 설계 인터뷰로 spec.md 를 같은 폴더에 만든 뒤 → (3) 두 문서와 결정으로 이슈를 생성한다.
  이슈 대상은 선택 인자다. `github` 이면 gh CLI 로 GitHub 통합 이슈 1개, `notion` 이면 Notion MCP 로 구현/TEST 이슈 1~2개,
  대상이 없으면 같은 폴더에 `issue-solve.md`(+`issue-test.md`) 파일로 남긴다.
  생성 뒤 문서 폴더를 최종 경로로 옮기고 이슈 메타데이터에 문서 경로를 적는다. 코드는 쓰지 않는다. 구현은 사용자가 계획 모드에서 이어받는다.
  개발자가 다음과 같이 말할 때 반드시 이 스킬을 사용하세요.
  "요구사항 정리해서 이슈 만들어줘", "intent 랑 spec 만들고 이슈 생성해줘", "설계 문서랑 이슈 같이 만들어줘",
  "이 작업 인터뷰해서 이슈로 만들어줘", "GitHub 이슈 만들어줘", "Notion 이슈 만들어줘", "/create-issues".
  이슈를 만들기 전에 요구사항을 굳혀야 하는 상황이면 사용자가 "이슈" 라는 말을 쓰지 않아도 이 스킬을 쓴다.
argument-hint: "[github|notion] [요구사항 자유 텍스트 — 대상을 비우면 파일로, 요구사항을 비우면 Stage 0 에서 묻습니다]"
---

## 역할

너는 시니어 PM 겸 엔지니어다. 사용자의 요구사항을 인터뷰로 굳혀 두 개의 버전 관리되는 문서(intent.md·spec.md)로 남기고, 그 문서를 근거로 이슈를 만든다. 다음 단계(구현)를 맡는 사람이나 에이전트가 이 대화를 보지 않고 문서와 이슈만으로 시작할 수 있어야 한다.

이 스킬은 **준비 단계** 다. 코드·테스트·빌드·plan.md 를 만들지 않는다. 산출물은 intent.md 1개, spec.md 1개, 그리고 대상에 따라 GitHub 이슈 1개, Notion 이슈 1~2개, 또는 이슈 파일 1~2개다.

외부 인터뷰·명세 스킬을 호출하지 않는다. 절차와 템플릿은 `references/` 에 내장되어 있다. 공용 스킬 `codebase-design` 이 설치되어 있으면 Stage 2 에서 SKILL.md 를 파일로 읽는 선택 의존이다. 없으면 `references/stage-2-spec.md` 의 정의만으로 진행한다.

---

## 입력

- **인자.** `[대상] <요구사항>`. 첫 토큰이 `github` 또는 `notion` 이면 대상이고 나머지가 요구사항 자유 텍스트다. URL·파일 경로·예시가 섞여 있어도 된다.
  - 대상 토큰이 없으면 대상은 `file` 이다. 묻지 않는다. 이슈를 외부에 게시하지 않고 문서 폴더에 파일로 남긴다.
  - 요구사항이 비어 있으면 "어떤 작업을 준비할까요? (목적·범위·맥락을 자유롭게)" 를 1회 묻는다.
- **환경.** 대상별로 다르다. github 은 `gh` 로그인. notion 은 Notion MCP 와 `NOTION_ISSUE_DB_URL` (env 또는 셸. 없으면 Stage 3 게이트에서 1회 묻는다). file 은 없다.
- **자동 추출.** `git remote get-url origin` 에서 호스트와 저장소. 자유 텍스트에서 slug (kebab-case, 모호하면 `task-YYYYMMDD-HHmm`). `git config user.name`/`user.email` 은 intent Author.
- **baseline.** `./.claude/skills/create-issues/baseline.md` (없으면 스킬 폴더의 것). 스킬 폴더는 이 SKILL.md 가 있는 디렉터리다 (플러그인으로 설치됐으면 `${CLAUDE_PLUGIN_ROOT}`). 없어도 동작한다.

---

## 절차 개요

| Stage | 요약 | 사용자 입력 | 상세 |
| --- | --- | --- | --- |
| 0 사전 점검 | 대상·요구사항 수신, slug, 대상별 환경 점검, TEST 1차 판단 | 요구사항 (빠졌을 때만) | 본 파일 §Stage 0 |
| 1 intent | 컨텍스트 로드 → 인터뷰 (한 번에 하나씩) → `intent/_tmp/<slug>/intent.md` → 확정 | 질문마다 답 + 확정 y | `references/stage-1-intent.md` |
| 2 spec | 코드베이스 탐색 → 설계 인터뷰 (한 번에 하나씩) → `intent/_tmp/<slug>/spec.md` → 확정 | 질문마다 답 + 확정 y | `references/stage-2-spec.md` |
| 3 이슈 | 분할안 승인 → base 2건 → 대상별 게시(또는 파일) → 폴더 이동 → 보충·검증 → 완료 | 분할안 y | `references/stage-3-issues.md` + `references/publish-<대상>.md` (github · notion · file) |

각 Stage 의 reference 는 **그 Stage 에 진입할 때** 읽는다. 템플릿은 `references/templates.md`, 인터뷰 방식은 `references/grilling.md`, 서브에이전트 위임은 `references/subagent-runtime.md` 가 단일 출처다.

---

## 사용자 입력 게이트

사용자 응답을 기다리는 시점은 아래뿐이다. 그 외에는 도구 호출 chain 으로 이어간다.

1. Stage 0 요구사항 (인자에 없을 때만).
2. Stage 1 인터뷰. 질문 하나마다 1회.
3. Stage 1 확정. `intent 를 확정하고 Stage 2 (spec) 로 진행할까요? (y/n)`.
4. Stage 2 인터뷰. 질문 하나마다 1회.
5. Stage 2 확정. `spec 을 확정하고 Stage 3 (이슈 생성) 로 진행할까요? (y/n)`.
6. Stage 3 분할안 승인 (+ env 보충).
7. `[STOP]` 항목 발생 시 확인.

게이트 규칙.
- 게이트 메시지에는 결과 표와 질문만 넣는다. "다음 Stage 로 진입합니다" 같은 예고 문장은 넣지 않는다. 진입 여부는 사용자 응답 뒤에 결정된다.
- 명시적 `y` / `n` (또는 숫자 선택) 외의 응답("계속", "진행", "ok")은 결정으로 해석하지 않는다. 같은 게이트를 다시 보인다.
- 확정 `y` 를 받으면 문서를 다시 `Read` 한다. 사용자가 파일을 직접 고쳤을 수 있다.

---

## Stage 0 · 사전 점검 (한 턴)

1. 대상과 요구사항 텍스트 확보. 대상 토큰이 없으면 `file` 로 둔다. 요구사항이 비었을 때만 1회 묻고 응답을 기다린다.
2. slug 추출. 한글·영문 키워드 → kebab-case. 이 slug 는 임시 식별자다. github 대상은 Stage 3 에서 이슈 번호를 받으면 `<iid>-<slug>` 가 최종 식별자가 되어 폴더명 `intent/<구간>/<iid>-<slug>/` 에 쓰이고, notion·file 대상은 `intent/<slug>/` 가 최종이다. Stage 0 요약에 이 사실을 한 줄로 보인다.
3. **대상별 환경 점검.** 어느 대상이든 저장소 밖이면 [STOP] (intent 폴더를 둘 곳이 필요하다).
   - github. `git remote get-url origin` 의 호스트가 GitHub 인지, `gh auth status` 가 성공하는지. 둘 중 하나라도 아니면 [STOP] 하고 확인한다.
   - notion. Notion MCP 도구(`notion-fetch`)가 있는지, `NOTION_ISSUE_DB_URL` 이 있는지 기록한다. 도구가 없으면 [STOP]. URL 부재는 Stage 3 게이트에서 처리한다.
   - file. 점검할 것이 없다.
4. TEST 필요 여부 1차 판단 (아래 규칙).
5. 같은 턴에서 Stage 1 의 컨텍스트 로드(1-1)까지 수행하고 첫 인터뷰 질문 하나를 묻는다. Stage 0→1 사이에 별도 진입 게이트는 없다.

Stage 0 요약 표.

```
| 항목 | 값 |
| --- | --- |
| 대상 | github <owner/repo> 또는 notion <DB URL 또는 보류> 또는 file |
| 요구사항 | <한 줄 요약> |
| slug | <slug> (github 은 iid 확보 후 <iid>-<slug>) |
| 환경 | github: gh 로그인 ok 또는 notion: Notion MCP ok, DB URL 받음/보류 또는 file: 없음 |
| TEST | confirmed: yes (강제) 또는 tentative: no 또는 undecided |
```

표 셀의 "또는" 은 대상에 맞는 쪽 하나만 적으라는 뜻이다.

### TEST 이슈 강제 규칙

| 자유 텍스트·컨텍스트의 성격 | 판단 |
| --- | --- |
| 코드 / 구현 / 개발 / API / 리팩터링 / 버그 수정 / 기능 추가 / 컨트롤러 / 서비스 / Repository / DTO / Entity / DB / 마이그레이션 / 스크립트 / 라이브러리 | `confirmed: yes (강제)` |
| 매뉴얼 / 문서 / README / 가이드 / 디자인 / 기획 / 정책 / 회의록 / 조사 / 분석 | `tentative: no` (인터뷰에서 재확인) |
| 그 외·모호 | `undecided` (인터뷰에서 결정) |

코드/개발 작업으로 확정되면 TEST 이슈는 강제다. 사용자가 "TEST 안 만들어줘" 라고 해도 격하하지 않는다. 산출물 범위만 인터뷰 안건으로 남긴다. 반대 방향(문서 작업 → 사용자가 TEST 원함)은 허용한다. 구현에는 회귀 방지·기능 검증을 위한 TEST 가 별도 책임 단위로 필요하고, 미리 분리해 두면 구현을 끝낸 사람이 TEST 를 "선택사항" 으로 미루는 일이 줄기 때문이다.

---

## 산출물 규칙

- **문서 위치.** 작성은 `intent/_tmp/<slug>/intent.md`·`spec.md`. Stage 3 에서 github 은 `intent/<구간>/<iid>-<slug>/`, notion·file 은 `intent/<slug>/` 로 이동한다. file 대상은 같은 폴더에 `issue-solve.md`(+`issue-test.md`)가 더 놓인다. `_tmp/` 는 아직 끝나지 않은 작업의 대기 폴더이며 버전 관리 대상이다. 기존 `intent/README.md` 가 있으면 그 규칙이 우선이다.
- **git 쓰기를 하지 않는다.** 문서 폴더 이동은 `mv` 로만 하고 `git add`·`git commit`·push 를 하지 않는다. 종료 출력에서 사용자에게 직접 커밋하라고 안내한다.
- **이슈 참조는 `### 메타데이터` 한 곳.** 별도 `## 참조` 섹션을 만들지 않는다. 문서 경로는 경로 텍스트만이며 커밋 SHA·"미커밋"·저장소 웹 링크를 붙이지 않는다. Notion 페이지는 전부 `<mention-page/>`. spec 을 이슈에 복제하지 않는다. 구현 이슈 `### 핵심 결정 사항` 은 5줄 이하다.
- **근거 사슬.** 탐색 사실은 spec `## Facts`(F) 로, 결정은 `D<n> — 근거: F|Q|intent|baseline` 으로, 이슈 체크리스트 항목은 `(D<n>)` 으로 이어진다. spec 에 없는 값(날짜·범위·건수·기본값)이 이슈에서 처음 등장하면 규칙 위반이다. 범위·기간·경계·기본값은 항상 명시적 D 다. Stage 3 base 검증에서 어긋나면 Stage 2 로 돌아간다.
- **문서 경계.** intent 에는 정책·계약·금지만 남기고 도구명·경로·명령이 들어간 구현 결정은 spec 으로 보낸다. 시점 의존 수치는 상대 조건으로 쓰고, 이 실행 자체를 검증 증거로 삼지 않는다. 제목·본문은 요구사항 언어를 따른다.
- **본문 출력 금지.** intent·spec·이슈 본문 markdown 을 어시스턴트 메시지로 출력하지 않는다. 경로와 요약 표만 보인다. 단계 사이 메시지는 1줄 진행 요약이다.
- **독립 호출은 병렬.** 서로 의존하지 않는 도구 호출(Stage 2 영역별 탐색, Stage 3 base 2건 Write, Notion 2건 생성, relation 2건, 검증 fetch 2건)은 한 메시지에서 동시에 보낸다.
- **판단은 메인 세션, 실행은 위임 가능.** 결정·추천·사용자 대화는 메인이 한다. 리서치와 게시는 `Agent` 도구에 맡길 수 있다. 상세는 `references/subagent-runtime.md`.

---

## 금지 사항

- 코드·테스트·빌드·plan.md 생성. 이 스킬은 준비 단계다.
- 외부 인터뷰·명세·티켓 스킬 호출. 내장 reference 를 쓴다.
- 팩트를 사용자에게 묻기. 코드·파일·도구로 알 수 있는 것은 직접 찾는다.
- 게이트 우회. 확정 `y` 없이 다음 Stage 문서를 쓰지 않는다.
- `git add`·`git commit`·push 등 모든 git 쓰기. 커밋은 사용자 몫이다.
- 이슈 본문을 손으로 옮겨 적기. 파일을 `Read` 한 결과를 그대로 넘기고 재조회로 검증한다.
- `- [ ] N. text` 체크박스. `- [ ] (N) text` 로 쓴다.
- 선택지에 알파벳 라벨. 숫자 라벨만 쓴다.
- 이메일·UUID·호스트·DB URL 을 스킬 파일에 박기. env·git remote·`notion-fetch self` 로 해석한다.

---

## 실패·중단

- 저장소 밖에서 실행 → [STOP] `git 저장소 안에서 실행해 주세요.`
- 첫 토큰이 `github`·`notion` 이 아니면 대상 토큰이 아니라 요구사항의 일부로 본다 (대상은 `file`).
- `intent/_tmp/<slug>/` 가 이미 있음 → [STOP] 덮어쓸지 다른 slug 로 갈지 묻는다. 이동이 끝난 같은 slug 폴더가 있는지도 함께 본다.
- github: `gh auth status` 실패 또는 remote 가 GitHub 아님 → [STOP].
- notion: Notion MCP 없음 → [STOP]. `NOTION_ISSUE_DB_URL` 없음 + 사용자 보충 거부 → [STOP].
- 이슈 생성 API 실패 → 오류 본문 그대로 출력 후 [STOP]. 재시도하지 않는다 (중복 이슈 방지). 이미 만든 이슈 URL 은 함께 보인다.

---

## 시작

1. 인자를 읽는다. 대상 토큰이 없으면 `file`. 요구사항이 비었으면 1회 묻는다.
2. 같은 턴에서 Stage 0 점검과 `references/stage-1-intent.md` §1-1 컨텍스트 로드를 수행하고, **같은 메시지에** Stage 0 요약 표를 한 번 보인 뒤 `references/grilling.md` 형식으로 **첫 질문 하나** 를 묻는다.
3. 이후는 §절차 개요 표대로 Stage 1 → 2 → 3 을 진행한다. 각 Stage 진입 시 해당 reference 를 읽는다. Stage 3 은 `references/publish-<대상>.md` (`publish-github.md` · `publish-notion.md` · `publish-file.md`) 도 함께 읽는다.
4. Stage 3 종료 출력 뒤 직접 커밋 안내 한 줄과 `다음은 구현입니다. 계획 모드에서 intent.md 와 spec.md 를 함께 넘겨 plan.md 를 만드세요.` 한 줄로 끝낸다.
