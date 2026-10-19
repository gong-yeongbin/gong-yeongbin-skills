# 게시 — Notion 이슈 DB (Notion MCP)

대상이 `notion` 일 때 Stage 3 의 3-0·3-3·3-5 에서 쓰는 절차다. 산출물은 구현 이슈 페이지 1개와 (TEST 있으면) TEST 이슈 페이지 1개다. 템플릿·아이콘 적용 절차는 없다. 본문은 생성 시 `content` 로 바로 넣는다.

도구. `notion-fetch`, `notion-create-pages`, `notion-update-page`. 없으면 [STOP] `Notion MCP 가 연결되어 있지 않습니다.`

## 사전 확인 (3-0)

아래 두 호출은 독립이므로 한 메시지에서 동시에 보낸다.

- `NOTION_ISSUE_DB_URL` (env). 없으면 3-1 게이트에서 함께 묻는다. `notion-fetch` 로 DB 를 읽어 **data source id 와 속성 목록** 을 얻는다.
- 현재 사용자. `notion-fetch` 에 `id: "self"`. 실패하면 담당자 속성을 비운다. 이메일·UUID 를 스킬에 박지 않는다.

속성 결정. baseline `## Notion 속성 매핑` 의 값을 DB 속성 목록과 대조해 **DB 에 실제로 있는 속성만** 쓴다. 매핑이 비어 있으면 Title 만 필수이고, `Status`·`Labels`·담당자·relation 은 같은 이름의 속성이 DB 에 있을 때만 쓴다. relation 속성(`선행 작업`·`후속 작업`)이 없으면 3-3 의 relation 단계를 건너뛰고 종료 출력 `미결·잔여` 에 `relation 속성 없음` 으로 적는다. 속성명은 대소문자까지 DB 와 같아야 한다. 틀리면 Notion 이 조용히 비운 채 성공을 반환한다.

## 게시 (3-3)

### 조립 (한 Bash 로 2건)

base `### 메타데이터` 의 `- spec:` 줄 뒤에 사용자 제공 Notion URL 이 있을 때만 `- 참고 자료:` 줄을 끼우고, 끝에 `## Blocked by` 를 붙인다. `## 참조` 섹션은 만들지 않는다.

```sh
SLUG=<slug>; TMP=<TMP>
{
  # baseline 핵심 원칙이 있을 때만 "## 핵심 원칙 (고정)" 블록
  sed -e '/^- spec:/a\
- 참고 자료: <mention-page url="<사용자 제공 Notion URL>"/>' "$TMP/${SLUG}_solve.md"
  printf '\n## Blocked by\n\nNone - can start immediately\n'
} > "$TMP/${SLUG}_notion_solve.md"
# TEST 있을 때. Blocked by 는 relation 속성 유무에 따라 둘 중 하나.
{
  sed -e '/^- spec:/a\
- 참고 자료: <mention-page url="<사용자 제공 Notion URL>"/>' "$TMP/${SLUG}_test.md"
  printf '\n## Blocked by\n\n선행 구현 이슈는 본 페이지 선행 작업 relation 으로 연결됨.\n'
} > "$TMP/${SLUG}_notion_test.md"
```

- 참고 자료가 없으면 `sed` 없이 `cat` 한다. 여러 개면 한 줄에 mention 을 이어 쓴다. **Notion 페이지는 반드시 `<mention-page url="..."/>`** 다.
- 조립 뒤 `grep -n "^- \(intent\|spec\|참고 자료\):"` 로 줄이 들어갔는지 확인한다.

### 생성 (한 메시지에서 동시에 2건)

`notion-create-pages` 인자.

- `parent`: `{type: "data_source_id", data_source_id: "<3-0 의 id>"}`
- `content`: `<TMP>/<slug>_notion_solve.md` (TEST 는 `_notion_test.md`) 를 `Read` 한 결과 그대로. 손으로 옮겨 적지 않는다.
- `properties` (DB 에 있는 것만)
  - Title: `<title>` (TEST 는 `<title> - TEST`)
  - Status: baseline default (없으면 생략해 DB 기본값을 받는다)
  - Labels: 분할안 값 (구현은 baseline 구현 라벨, TEST 는 `TEST`)
  - 담당자: `["<self uuid>"]` (self 조회가 됐을 때만)

응답 `id`·`url` → `solve_notion_page_id`·`solve_notion_url`, `test_notion_page_id`·`test_notion_url`. 둘 중 하나라도 실패하면 성공한 쪽 URL 을 보이고 [STOP].

### 양방향 relation (TEST 있고 relation 속성이 있을 때만, 동시 2건)

1. `notion-update-page` (`update_properties`) — TEST 페이지에 `{"<선행 작업 속성명>": "[\"<solve_notion_url>\"]"}`.
2. `notion-update-page` (`update_properties`) — 구현 페이지에 `{"<후속 작업 속성명>": "[\"<test_notion_url>\"]"}`.

## 보충·검증 (3-5)

### 메타데이터 경로 보충

3-4 폴더 이동으로 `intent/_tmp/<slug>/` 가 `intent/<slug>/` 로 바뀌었다. 두 페이지의 `- intent:`·`- spec:` 줄을 `notion-update-page` `update_content` 로 고친다. `old_str` 은 직전 fetch 결과에서 복사한 짧고 유일한 앵커를 쓰고 한 번에 하나씩 보낸다.

### 재조회 검증

두 페이지를 `notion-fetch` 로 다시 읽는다 (한 메시지에서 동시에).

| 확인 | 무엇을 보는가 |
| --- | --- |
| 본문이 원본과 같은가 | 파일의 문장 몇 개를 페이지에서 그대로 찾는다. 도구 인자는 모델이 재생산하므로 긴 한글 본문에서 음절이 틀어질 수 있다. |
| 숫자·경로·컬럼명 | `intent/<slug>/spec.md` 같은 토큰을 대조한다. 경로 한 글자가 바뀌면 다른 문서를 가리킨다. |
| 코드 요소가 백틱인가 | 파일명·경로·클래스·테이블·명령이 인라인 코드로 렌더됐는가. 맨 글자로 남은 것은 `update_content` 로 감싼다. |
| 체크박스 | 전부 `- [ ]` 이고 `(N)` 번호가 보존됐는가. |
| Status·Labels | 넣은 값 그대로인가. |
| relation | 구현의 후속 작업과 TEST 의 선행 작업이 서로를 가리키는가. |

### 깨짐을 발견했을 때

- 깨짐이 **정상 음절** 로만 이루어졌으면 `update_content` 로 고친다. `content_updates` 는 한 번에 하나씩.
- 재입력이 안 되는 글자(다시 치면 또 다른 글자가 되는 경우)를 만나면 부분 수정을 포기한다. 소수이고 오타 수준이면 위치·현재·올바른 표현을 표로 보고한다. 많거나 의미가 바뀌면(경로·수치·판정 기준) `replace_content` 로 통째 교체하고 검증을 다시 돈다. 두 번 교체해도 안 잡히면 멈추고 사용자에게 넘긴다.
- 이미 렌더된 표를 고칠 때는 `update_content` 가 아니라 `replace_content`. 표는 `<table>` 로 저장되어 markdown 파이프로는 `old_str` 이 맞지 않는다.
- 깨진 채로 "게시 완료" 라고 보고하지 않는다. 고치지 못한 곳은 `미결·잔여` 에 위치와 올바른 표현을 함께 적는다.

## 함정 요약

- 체크박스 `- [ ] N. text` 금지. Notion 이 `N.` 을 nested numbered list 로 분리한다. `- [ ] (N) text`.
- Notion 페이지 참조는 `<mention-page url="..."/>` 만. raw URL·markdown 링크 금지. 저장소 파일 경로는 코드 스팬.
- `{` 가 든 값은 속성 문법으로 오인되므로 코드 블록으로 빼거나 풀어 쓴다.
- 속성명 대소문자가 틀리면 조용히 비워진다. 검증에서 반드시 본다.
