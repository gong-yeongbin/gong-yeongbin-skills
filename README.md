# gong-yeongbin-skills

직접 만든 Claude Code 스킬을 플러그인 단위로 제공하는 개인 플러그인 마켓플레이스다. 이 저장소의 자체 플러그인뿐 아니라 외부 저장소의 플러그인도 함께 등록해 하나의 허브에서 설치할 수 있다.

## 설치

Claude Code에서 마켓플레이스를 한 번 등록한다.

```
/plugin marketplace add gong-yeongbin/gong-yeongbin-skills
```

이후 원하는 플러그인을 골라 설치한다.

```
/plugin install <플러그인>@gong-yeongbin-skills
```

`/plugin` 명령만 입력하면 마켓플레이스 목록을 UI로 탐색하면서 골라 설치할 수도 있다.

- 설치 범위는 기본이 유저(모든 프로젝트에서 사용)이며, 프로젝트 범위로 설치하려면 터미널에서 `claude plugin install --scope project <플러그인>@gong-yeongbin-skills`를 쓴다.
- 업데이트는 `/plugin update <플러그인>`, 마켓플레이스 갱신은 `/plugin marketplace update gong-yeongbin-skills`로 한다.
- 업데이트를 자동으로 받으려면 `/plugin` → **Marketplaces** 탭 → `gong-yeongbin-skills` → **Enable auto-update**를 켠다. 서드파티 마켓플레이스는 기본이 off다. 켜 두면 세션 시작 후 백그라운드에서 자동 갱신되며, 다음 세션 또는 `/reload-plugins`부터 반영된다.
- 제거는 `/plugin uninstall <플러그인>`이다.

## 제공 플러그인

| 플러그인 | 설명 |
| --- | --- |
| `create-issues` | 요구사항을 인터뷰로 굳혀 `intent.md`·`spec.md`를 만들고 GitHub Issues(`gh`) 또는 Notion 이슈 DB(Notion MCP)에 이슈를 생성한다. 대상을 생략하면 같은 폴더에 `issue-solve.md`·`issue-test.md` 파일로 남긴다. `/create-issues [github\|notion] <요구사항>`으로 호출한다. |
| `generate-commit-message` | staged diff(없으면 unstaged)와 브랜치명을 분석해 Conventional Commits 형식의 한국어 커밋 메시지를 만든다. `<type>: 요약` 제목과 What·Why 불릿 본문으로 구성하며, 브랜치명에 이슈 번호가 있으면 `Refs: #번호`를 붙인다. 메시지만 출력하고 커밋은 하지 않는다. `/generate-commit-message [보충 설명]`으로 호출한다. |

설치 예시.

```
/plugin install create-issues@gong-yeongbin-skills
/plugin install generate-commit-message@gong-yeongbin-skills
```
