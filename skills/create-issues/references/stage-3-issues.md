# Stage 3 — 분할안 승인 → 게시 → 폴더 이동 → 검증 (대상 공통)

목표. 확정된 intent.md·spec.md 와 인터뷰 결정으로 이슈를 만든다. 산출물은 대상에 따라 다르다.

| 대상 | 이슈 | 문서 폴더 (이동 후) | 게시 절차 |
| --- | --- | --- | --- |
| github | GitHub 통합 이슈 1개 (`# 구현` / `# TEST` H1 분할) | `intent/<구간>/<iid>-<slug>/` | `publish-github.md` |
| notion | Notion 구현 이슈 1개 (+ TEST 이슈 1개, 양방향 relation) | `intent/<slug>/` | `publish-notion.md` |
| file (대상 없음) | 문서 폴더의 `issue-solve.md` (+ `issue-test.md`) | `intent/<slug>/` | `publish-file.md` |

사용자 입력은 3-1 승인 게이트 한 곳뿐이다. 그 외 단계는 한 턴 안에서 도구 호출 chain 으로 이어간다. 단계 사이 어시스턴트 메시지는 1줄 진행 요약만이다. 본문 markdown 을 메시지로 출력하지 않는다.

`<TMP>` = 세션 스크래치패드 디렉터리. 없으면 `/tmp`.

Stage 3 진입 시 이 파일과 함께 **대상의 `publish-<target>.md` 를 읽는다.** 다른 대상 파일은 읽지 않는다.

## 게시 위임 (선택)

판단이 끝난 뒤의 게시는 실행 작업이라 `general-purpose` 서브에이전트(`sonnet`)에 맡길 수 있다 (`subagent-runtime.md`). 긴 본문이 메인 컨텍스트에 들어오지 않는다. 넘길 것은 base 파일 경로·title·labels·대상 설정값 전부이고, 돌려받을 것은 이슈 URL(github 은 iid 포함)과 검증 결과 표다. 서브에이전트는 메인 대화를 공유하지 않으므로 "위에서 정한 대로" 는 통하지 않는다. 검증을 통과하지 못했다는 보고는 그대로 사용자에게 전달한다. 3-4 폴더 이동은 메인이 직접 한다. 작은 작업(TEST 없음, 본문 짧음)이면 위임 없이 메인이 직접 한다. 절차는 같다.

---

## 3-0. 사전 확인 (승인 게이트 직전, 같은 턴)

`publish-<target>.md` §사전 확인을 수행한다. 요약하면 github 은 `gh auth status` 와 remote 가 GitHub 인지, notion 은 `NOTION_ISSUE_DB_URL` 과 DB 스키마(data source id·속성 목록), file 은 없다. 부족한 값은 3-1 게이트 메시지 끝에 한 줄씩 덧붙여 함께 묻는다.

## 3-1. 분할안 제시 + 승인 게이트 (사용자 입력)

티켓 수는 고정이다. 구현 1 (+ TEST 1). spec 이 여러 슬라이스를 담고 있으면 구현 이슈 `### 진행 단계 체크리스트` 의 단계로 접는다.

```
## 이슈 분할안

| 티켓 | 제목 | 무엇을 전달하는가 | Blocked by |
| --- | --- | --- | --- |
| 구현 | <title> | <종단 행동 1줄> | 없음 |
| TEST | <title> - TEST | <검증 범위 1줄> | 구현 |

구현 진행 단계 (초안)
1. ...

TEST 검증 게이트 (초안)
1. ...

User Story 검증 소유 (TEST 있을 때만, 한 스토리는 한쪽에만)
- 구현: US<n>, ...
- TEST: US<n>, ... (실DB·대조·실측이 필요한 것)

메타데이터
- 대상: github | notion | file
- 라벨: <baseline default 또는 추정> (github 은 labels, notion 은 Labels·Status, file 은 참고만)

[STOP] 이 분할안으로 이슈를 생성할까요? (y/n)
```

- `y` → 3-2 부터 chain 시작.
- `n` 또는 수정 요청 → 반영 뒤 분할안 재출력.
- 비명시 응답 → 게이트 재출력.

## 3-2. base 본문 작성 + 검증

`templates.md` §3 골격으로 `<TMP>/<slug>_solve.md` (+ `<TMP>/<slug>_test.md`) 를 `Write` 한다. 두 파일은 독립이므로 **한 메시지에서 동시에** 쓴다. 이전 세션 잔존 파일로 `Write` 가 거부되면 `Read` 뒤 다시 `Write`.

작성 뒤 검증한다.
- 첫 H2 `## What to build`, 두 번째 H2 `## Acceptance criteria`. 체크박스 `- [ ] (N)` 패턴. wrapper 섹션 미포함. `### 핵심 결정 사항` 5줄 이하.
- TEST 케이스에 시점 의존 절대값·자기 참조 증거 없음.
- `<title>` 이 요구사항 언어이고 영역 접두어 뒤가 작업 전체의 목적·개념이며 20자 이내.
- 체크리스트·DoD 에 "인계"·"커밋"·"Status 전환" 항목 없음 (`grep -n "인계\|커밋\|Done\|상태 전환\|Status"`).
- TEST 이슈가 있으면 구현 DoD 에 "User Stories 전부" 가 없고, 두 base 의 `US<n>` 목록이 겹치지 않음 (`grep -o "US[0-9]*"` 로 뽑아 대조. 범위 표기는 펼쳐서 본다).
- **근거 대조 (필수).** 체크리스트·검증 게이트의 모든 항목에 `(D<n>)` 이 있고 그 D 가 spec.md 에 실제로 있는지 `grep -oE "\(D[0-9]+(, ?D[0-9]+)*\)" <파일> | grep -oE "D[0-9]+" | sort -u` 로 뽑아 대조한다 (`(D4, D5)` 묶음의 둘째 이후와 `(DoD)` 오인을 피하기 위해 두 단계로 뽑는다). 항목 안의 값(날짜·기간·건수·기본값)이 해당 D 문장에 그대로 있는지도 본다. 하나라도 어긋나면 이슈를 만들지 않고 Stage 2 로 돌아가 Facts 확인 → D 추가 → 사용자 확정 뒤 다시 온다.

`### 메타데이터` 의 문서 경로는 아직 `intent/_tmp/<slug>/...` 로 쓰고, 3-4 에서 최종 경로로 치환한다.

진행 메시지. `"이슈 본문 base N건 작성 완료. 게시 진행."`

## 3-3. 게시

`publish-<target>.md` §게시를 수행한다. github 은 통합 본문 조립 → `gh issue create` → `iid`·URL 확보. notion 은 구현·TEST 본문 조립 → `notion-create-pages` 동시 2건 → relation → URL 확보. file 은 조립 → `intent/_tmp/<slug>/issue-solve.md` (+ `issue-test.md`) `Write`. 실패 시 각 파일의 [STOP] 규칙을 따른다.

진행 메시지. `"<대상> 이슈 게시 완료. intent 폴더 이동 진행."` (file 은 `"이슈 파일 2건 작성 완료. ..."`)

## 3-4. 폴더 이동 `intent/_tmp/<slug>/` → 최종 경로

- **github.** 최종 식별자는 `<iid>-<slug>` 다. `시작 = floor(iid / 50) * 50`, `끝 = 시작 + 49`, `<구간> = <시작>-<끝>`. 예. `#268` → `intent/250-299/268-<slug>/`. 셸로는 `S=$(( iid / 50 * 50 )); BUCKET="${S}-$(( S + 49 ))"`. 구간 폴더가 없으면 만든다.
- **notion · file.** 최종 경로는 `intent/<slug>/`. 번호를 붙이지 않는다.
- Stage 1 에서 읽어 둔 기존 `intent/` 규칙(`intent/README.md` 우선)이 위와 다르면 그 규칙을 따른다.
- `mv` 로 옮긴다. 이 스킬은 `git add`·`git commit` 을 하지 않는다. 커밋은 사용자가 종료 출력을 본 뒤 직접 한다.
- base 파일과 intent.md·spec.md (file 대상은 `issue-*.md` 도) 안의 `intent/_tmp/<slug>/` 문자열을 최종 경로로 치환한다 (`sed -i ''` 또는 `Edit`). 치환 뒤 `grep -rn '_tmp'` 로 잔존이 없는지 확인한다.
- 이동은 되돌릴 수 있는 로컬 작업이라 별도 승인 없이 수행한다.

진행 메시지. `"<최종 경로> 로 이동 완료. 보충·검증 진행."`

## 3-5. 메타데이터 보충 + 게시 검증 (생략 금지)

`publish-<target>.md` §보충·검증을 수행한다. 3-4 에서 문서 경로가 바뀌었으므로 이슈 본문의 intent/spec 경로를 최종 경로로 갱신하고, 재조회(file 은 파일 grep)로 본문·경로 토큰·체크박스·라벨(notion 은 Status·relation 포함)을 대조한다. 어긋나면 고치고 다시 읽는다. 통과 전에는 종료 출력으로 가지 않는다.

## 3-6. 종료 출력

```
## 완료

| 종류 | 위치 |
| --- | --- |
| intent | <최종 경로>/intent.md |
| spec | <최종 경로>/spec.md |
| GitHub 이슈 (#<iid>) | <url> |            ← github 대상
| Notion 구현 이슈 | <url> |                 ← notion 대상
| Notion TEST 이슈 | <url> |                 ← notion 대상, TEST 있을 때
| 이슈 파일 | <최종 경로>/issue-solve.md (, issue-test.md) |   ← file 대상
| 미결·잔여 | <항목 — 종류> 를 `;` 로 이어 전부, 또는 "없음" |
```

대상에 없는 행은 뺀다. `미결·잔여` 행은 빼지 않는다. spec Further Notes 의 이월·미결 항목과 3-5 에서 고치지 못한 깨짐, relation 속성 부재로 건너뛴 단계를 모아 적는다. 건수로 줄이거나 표 밖 문장으로 빼지 않는다. 이어서 두 줄. `문서 폴더는 커밋하지 않았습니다. git add <최종 경로> 로 직접 커밋해 주세요.` 와 `다음은 구현입니다. 계획 모드에서 intent.md 와 spec.md 를 함께 넘겨 plan.md 를 만드세요.`
