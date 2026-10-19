# 게시 — 파일로 남기기 (대상 없음)

대상 인자가 없을 때 Stage 3 의 3-0·3-3·3-5 에서 쓰는 절차다. 외부에 게시하지 않고 이슈 본문을 문서 폴더에 파일로 남긴다. 산출물은 `issue-solve.md` 1개와 (TEST 있으면) `issue-test.md` 1개다. 나중에 사용자가 원하는 트래커에 그대로 붙여 넣는 용도다.

## 사전 확인 (3-0)

- 확인할 환경이 없다. 저장소 안인지만 본다 (Stage 0 에서 이미 확인).
- 라벨·Status 같은 트래커 속성은 쓰지 않는다. 분할안 메타데이터의 `라벨` 줄은 참고로만 보인다.

## 게시 (3-3)

### 조립 (한 Bash 로 2건)

base 에 `## Blocked by` 만 붙인다. 메타데이터 추가 줄은 없다.

```sh
SLUG=<slug>; TMP=<TMP>
{
  # baseline 핵심 원칙이 있을 때만 "## 핵심 원칙 (고정)" 블록
  cat "$TMP/${SLUG}_solve.md"
  printf '\n## Blocked by\n\nNone - can start immediately\n'
} > "$TMP/${SLUG}_file_solve.md"
# TEST 있을 때
{
  cat "$TMP/${SLUG}_test.md"
  printf '\n## Blocked by\n\n선행: issue-solve.md 완료 후 진행\n'
} > "$TMP/${SLUG}_file_test.md"
```

### 쓰기

문서 폴더 `intent/_tmp/<slug>/` 에 `issue-solve.md` (+ `issue-test.md`) 로 `Write` 한다. 두 파일은 독립이므로 한 메시지에서 동시에 쓴다. 이 시점의 메타데이터 경로는 아직 `intent/_tmp/<slug>/` 이고 3-4 이동 때 함께 치환된다.

## 보충·검증 (3-5)

### 메타데이터 경로 보충

3-4 에서 폴더 전체가 `intent/<slug>/` 로 옮겨지면서 `issue-*.md` 안의 경로도 같이 치환된다 (3-4 의 `sed`/`Edit` 대상에 두 파일을 포함한다). 별도 보충은 없다.

### 검증

```sh
ls intent/<slug>/            # intent.md spec.md issue-solve.md (issue-test.md)
grep -rn "_tmp" intent/<slug>/   # 0건
grep -n "^- \[ \] (" intent/<slug>/issue-*.md   # 체크박스 전부 - [ ] (N)
grep -ohE "\(D[0-9]+(, ?D[0-9]+)*\)" intent/<slug>/issue-*.md | grep -oE "D[0-9]+" | sort -u   # spec.md 의 D 와 대조
```

| 확인 | 무엇을 보는가 |
| --- | --- |
| 파일 존재 | `issue-solve.md`, TEST 있으면 `issue-test.md` |
| 경로 토큰 | `intent/<slug>/intent.md`·`spec.md` 가 본문에 있고 `_tmp` 가 없는가 |
| 체크박스 | 전부 `- [ ]` 이고 `(N)` 형식인가 |
| 근거 번호 | `(D<n>)` 이 spec.md 에 실제로 있는가 |

어긋나면 `Edit` 으로 고치고 다시 확인한다. 통과 전에는 종료 출력으로 가지 않는다.
