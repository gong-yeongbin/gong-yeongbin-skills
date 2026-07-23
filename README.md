# gong-yeongbin-skills

자주 쓰는 Claude Code 스킬을 스킬별 플러그인으로 제공하는 개인 플러그인 마켓플레이스다. 이 저장소의 자체 스킬뿐 아니라 외부 저장소의 플러그인도 함께 등록해 하나의 허브에서 설치할 수 있다.

## 설치

Claude Code에서 마켓플레이스를 한 번 등록한다.

```
/plugin marketplace add gong-yeongbin/gong-yeongbin-skills
```

이후 원하는 플러그인을 골라 설치한다.

```
/plugin install humanizer@gong-yeongbin-skills
```

`/plugin` 명령만 입력하면 마켓플레이스 목록을 UI로 탐색하면서 골라 설치할 수도 있다.

- 설치 범위는 기본이 유저(모든 프로젝트에서 사용)이며, 프로젝트 범위로 설치하려면 터미널에서 `claude plugin install --scope project <플러그인>@gong-yeongbin-skills`를 쓴다.
- 업데이트는 `/plugin update <플러그인>`, 마켓플레이스 갱신은 `/plugin marketplace update gong-yeongbin-skills`로 한다.
- 업데이트를 자동으로 받으려면 `/plugin` → **Marketplaces** 탭 → `gong-yeongbin-skills` → **Enable auto-update**를 켠다. 서드파티 마켓플레이스는 기본이 off다. 켜 두면 세션 시작 후 백그라운드에서 자동 갱신되며, 다음 세션 또는 `/reload-plugins`부터 반영된다.
- 제거는 `/plugin uninstall <플러그인>`이다.

> 과거 skills CLI(`npx skills add`)로 설치해 둔 스킬 사본은 이번 전환의 영향을 받지 않고 그대로 남는다. 이후 업데이트를 받으려면 해당 사본을 지우고 플러그인으로 다시 설치한다.

## 제공 플러그인

| 플러그인 | 설명 | 출처 / 라이선스 |
|---|---|---|
| `andrej-karpathy-guidelines` | LLM 코딩 실수를 줄이는 행동지침 4가지를 SessionStart 훅으로 매 세션 컨텍스트에 자동 주입한다. 원본에 없는 훅 자동 주입 메커니즘을 더한 변형판이라 사본으로 유지한다. | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT) |

## 등록된 외부 플러그인

파일을 이 저장소에 두지 않고, 설치 시점에 원 저장소에서 직접 받아 온다. 버전 업데이트가 원 저장소를 자동으로 따라간다.

| 플러그인 | 설명 | 출처 / 라이선스 |
|---|---|---|
| `humanizer` | AI가 쓴 티가 나는 글쓰기 패턴을 감지하고 자연스럽게 고쳐 쓴다. | [blader/humanizer](https://github.com/blader/humanizer) (MIT) |
| `mattpocock-skills` | Matt Pocock의 엔지니어링·생산성 스킬 22종 컬렉션. `setup-matt-pocock-skills`, `tdd`, `code-review`, 자체 구현 `grill-me` 등을 포함한다. | [mattpocock/skills](https://github.com/mattpocock/skills) (MIT) |
| `superpowers` | TDD, 디버깅, 협업 패턴 등 스킬 14종 컬렉션. `brainstorming`, `writing-plans`, `executing-plans` 등을 포함한다. | [obra/superpowers](https://github.com/obra/superpowers) (MIT) |

> 과거 이 저장소가 사본으로 제공하던 `brainstorming`·`writing-plans`(→ `superpowers`), `humanizer`(→ `humanizer`), `setup-matt-pocock-skills`(→ `mattpocock-skills`)는 원본 외부 플러그인 설치로 대체됐다. `grill-me` 사본(satya-janghu 구현)은 카탈로그에서 내렸으며, 유사한 인터뷰 용도는 `mattpocock-skills`의 `grilling`·`grill-me`가 담당한다.

### `andrej-karpathy-guidelines` — 동작 방식

설치하면 SessionStart 훅이 매 세션 시작 때 지침(`guidelines.md`)을 컨텍스트에 주입한다. 별도 실행 단계가 없고, 설치 후 새 세션부터 자동 적용된다. `/plugin uninstall` 또는 disable만으로 깨끗하게 중단된다.

지침 내용은 커밋 SHA를 버전으로 쓰므로(plugin.json에 version 없음), 이 저장소에 커밋이 push되면 곧바로 새 버전으로 인식된다. 마켓플레이스 auto-update까지 켜 두면 지침 수정 → push → 설치자 세션에 자동 반영까지 사람 손이 가지 않는다.

> v1(install.sh 방식)으로 `~/.claude/CLAUDE.md`에 지침을 주입해 둔 머신이라면, 그 파일에서 `<!-- andrej-karpathy-guidelines:start -->` ~ `<!-- andrej-karpathy-guidelines:end -->` 마커 블록을 삭제한다. 남겨 두면 지침이 이중으로 주입된다.

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
