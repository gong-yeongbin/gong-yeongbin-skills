# gong-yeongbin-skills

자주 쓰는 Claude Code 스킬과 지침을 플러그인 단위로 제공하는 개인 플러그인 마켓플레이스다. 이 저장소의 자체 플러그인뿐 아니라 외부 저장소의 플러그인도 함께 등록해 하나의 허브에서 설치할 수 있다.

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

| 플러그인 | 종류 | 설명 |
| --- | --- | --- |
| `create-issues` | 자체 스킬 | 요구사항을 인터뷰로 굳혀 `intent.md`·`spec.md`를 만들고 GitHub Issues(`gh`) 또는 Notion 이슈 DB(Notion MCP)에 이슈를 생성한다. 대상을 생략하면 같은 폴더에 `issue-solve.md`·`issue-test.md` 파일로 남긴다. `/create-issues [github\|notion] <요구사항>`으로 호출한다. |
| `generate-commit-message` | 자체 스킬 | staged diff(없으면 unstaged)와 브랜치명을 분석해 Conventional Commits 형식의 한국어 커밋 메시지를 만든다. `<type>: 요약` 제목과 What·Why 불릿 본문으로 구성하며, 브랜치명에 이슈 번호가 있으면 `Refs: #번호`를 붙인다. 메시지만 출력하고 커밋은 하지 않는다. `/generate-commit-message [보충 설명]`으로 호출한다. |

설치 예시.

```
/plugin install create-issues@gong-yeongbin-skills
```

외부 플러그인이 추가되면 출처와 라이선스를 이 표에 함께 적는다. 외부 플러그인은 파일을 이 저장소에 두지 않고 설치 시점에 원 저장소에서 직접 받아 오며, 버전 업데이트가 원 저장소를 자동으로 따라간다.

## 새 플러그인(자체 스킬) 추가

`skills/<스킬명>/`에 SKILL.md와 plugin.json을 만들고 `.claude-plugin/marketplace.json`에 엔트리를 추가한다. 자세한 규칙은 [CLAUDE.md](CLAUDE.md)를 참조한다.

## 외부 플러그인 등록

다른 저장소의 플러그인도 `.claude-plugin/marketplace.json`의 `plugins` 배열에 엔트리를 추가하면 이 마켓플레이스에서 함께 설치할 수 있다.

```json
{
  "name": "some-plugin",
  "source": { "source": "url", "url": "https://github.com/owner/repo.git" }
}
```

`{ "source": "github", "repo": "owner/repo" }` 형식도 있지만 SSH로 clone을 시도하므로, SSH 키가 없는 환경에서도 설치되도록 HTTPS `url` 형식을 기본으로 쓴다.
