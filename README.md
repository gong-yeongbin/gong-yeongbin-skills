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

아직 등록된 플러그인은 없다. 자체 플러그인과 외부 플러그인이 추가되면 여기에 표로 기록한다. 외부 플러그인은 파일을 이 저장소에 두지 않고 설치 시점에 원 저장소에서 직접 받아 오며, 버전 업데이트가 원 저장소를 자동으로 따라간다.

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
