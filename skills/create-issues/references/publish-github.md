# 게시 — GitHub Issues (gh CLI)

대상이 `github` 일 때 Stage 3 의 3-0·3-3·3-5 에서 쓰는 절차다. 산출물은 통합 이슈 1개다. 구현과 TEST 는 한 이슈 안의 `# 구현` / `# TEST` H1 phase 로 나뉜다.

## 사전 확인 (3-0)

- `gh auth status` 가 성공하는가. 실패면 [STOP] `gh auth login 으로 GitHub 에 로그인해 주세요.`
- `git remote get-url origin` 의 호스트가 GitHub 인가 (`github.com` 또는 GitHub Enterprise 호스트). 아니면 [STOP] 하고 확인한다. `gh repo view --json nameWithOwner` 로 저장소를 다시 확인한다.
- 라벨. `gh label list --json name` 으로 저장소 라벨을 읽는다. 분할안의 라벨이 저장소에 없으면 `--label` 에서 빼고 종료 출력 `미결·잔여` 에 `라벨 <이름> 미존재` 로 적는다. 라벨을 만들지 않는다.

## 게시 (3-3)

### 통합 본문 조립

TEST 있을 때.

```sh
SLUG=<slug>; TMP=<TMP>
{
  # baseline 핵심 원칙이 있을 때만
  printf '# 핵심 원칙 (고정)\n\n<baseline 본문 그대로>\n\n'
  printf '# 구현\n\n'
  cat "$TMP/${SLUG}_solve.md"
  printf '\n## Blocked by\n\nNone - can start immediately\n\n# TEST\n\n'
  cat "$TMP/${SLUG}_test.md"
  printf '\n## Blocked by\n\n선행: # 구현 phase 완료 후 진행\n'
} > "$TMP/${SLUG}_github_merged.md"
```

TEST 없으면 `# 구현`·`# TEST` 마커와 TEST 블록을 빼고 solve.md + `## Blocked by` 1회.

### 생성

```sh
gh issue create --title "<title>" --body-file "$TMP/${SLUG}_github_merged.md" --label "<label1>,<label2>"
```

- 출력은 이슈 URL 한 줄이다. URL 끝의 숫자가 `iid`, URL 전체가 `issue_url`.
- 실패하면 stderr 를 그대로 보이고 [STOP]. 재시도하지 않는다 (중복 이슈가 생긴다).

## 보충·검증 (3-5)

### 메타데이터 경로 보충

3-4 폴더 이동으로 `intent/_tmp/<slug>/` 가 `intent/<구간>/<iid>-<slug>/` 로 바뀌었다. base 파일은 3-4 에서 이미 치환됐으므로 통합 본문을 다시 조립해 교체한다.

```sh
# 위 조립을 다시 실행해 $TMP/${SLUG}_github_final.md 를 만든 뒤
gh issue edit <iid> --body-file "$TMP/${SLUG}_github_final.md"
```

### 재조회 검증

```sh
gh issue view <iid> --json title,labels,body
```

| 확인 | 무엇을 보는가 |
| --- | --- |
| 제목 | `<title>` 그대로 |
| 라벨 | 넣은 라벨이 전부 있는가 |
| 경로 토큰 | `intent/<구간>/<iid>-<slug>/intent.md`·`spec.md` 가 본문에 있고 `_tmp` 가 없는가 |
| 체크박스 | 전부 `- [ ]` 이고 `- [ ] (N)` 형식인가 |
| phase 마커 | TEST 있으면 `# 구현`·`# TEST` H1 이 각 1회인가 |
| 근거 번호 | 체크리스트 항목의 `(D<n>)` 이 보존됐는가 |

어긋나면 `gh issue edit` 으로 고치고 다시 읽는다. 통과 전에는 종료 출력으로 가지 않는다.
