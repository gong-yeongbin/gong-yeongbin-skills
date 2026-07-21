# gong-yeongbin-skills

자주 쓰는 Claude Code 스킬을 모아 둔 카탈로그다. `skill-installer` 메타 스킬로 Claude Code 안에서 골라 설치하거나, 표준 [`skills`](https://github.com/vercel-labs/skills) CLI를 직접 쓴다.

## 설치 (권장) — skill-installer

새 디바이스에서 한 번만 부트스트랩한다.

```
npx -y skills@latest add gong-yeongbin/gong-yeongbin-skills --skill skill-installer -g -a claude-code -y
```

이후에는 터미널 명령이 필요 없다. Claude Code에서 이렇게 말하면 된다.

```
스킬 설치해줘
```

카탈로그 스킬 목록이 체크박스로 표시되고, 고른 뒤 설치 범위를 묻는다.

- **유저** — `~/.claude/skills`. 이 디바이스의 모든 프로젝트에서 사용.
- **프로젝트** — `<프로젝트>/.claude/skills`. 해당 프로젝트에서만 사용하며 git 커밋 대상.

이미 설치된 스킬을 다시 선택하면 최신 내용으로 덮어쓴다(업데이트).

## 설치 (대안) — 표준 skills CLI

```
npx skills@latest add gong-yeongbin/gong-yeongbin-skills --list
```

- 설치 가능한 스킬 목록이 표시되고, 원하는 스킬을 골라 설치한다.
- 특정 스킬만 바로 설치하려면 `--skill <스킬명>`을 쓴다.

```
npx skills@latest add gong-yeongbin/gong-yeongbin-skills --skill humanizer
```

`skills` CLI가 어느 에이전트(Claude Code, Cursor, Codex 등)에 설치할지, 프로젝트 로컬과 유저 전역 중 어디에 둘지 물어본다.

### 전역(유저 레벨) 설치

모든 프로젝트에서 쓰려면 `-g`로 유저 전역(`~/.claude/skills/`)에 설치한다. 이때 `-a claude-code`로 대상 에이전트를 Claude Code로 좁혀야 한다.

```
npx skills@latest add gong-yeongbin/gong-yeongbin-skills --skill grill-me -a claude-code -g
```

> 대상을 지정하지 않으면 CLI가 감지한 모든 에이전트에 설치를 시도하는데, 그중 일부(예: `PromptScript`)는 전역 설치를 지원하지 않아 빨간 `Failed to install` 메시지가 뜬다. 이는 해당 에이전트에만 해당하며 Claude Code 설치 자체는 성공하지만, `-a claude-code`로 좁히면 이 메시지 없이 깔끔하게 설치된다.

### `andrej-karpathy-guidelines` — 설치 후 한 단계 더

이 스킬만 다른 스킬과 다르다. `skills add`는 스킬 **파일을 복사만** 할 뿐 `install.sh`를 실행하지 않는다. 실제 지침은 `install.sh`가 실행될 때 비로소 사용자 전역 `~/.claude/CLAUDE.md`에 주입된다. 따라서 아래 2단계를 거쳐야 한다.

```bash
# 1. 스킬을 전역에 복사
npx skills@latest add gong-yeongbin/gong-yeongbin-skills --skill andrej-karpathy-guidelines -a claude-code -g

# 2. 복사된 install.sh를 실행해 ~/.claude/CLAUDE.md에 지침 주입
bash ~/.claude/skills/andrej-karpathy-guidelines/install.sh
```

- `installed:` 또는 `updated:` 메시지가 뜨면 성공이다. 마커 블록으로 감싸 주입하므로 여러 번 실행해도 중복되지 않고 블록만 교체된다(idempotent).
- 전역 `~/.claude/CLAUDE.md`는 새 세션부터 로드되므로, 변경은 **다음 세션부터** 적용된다.
- `skills add` 없이 이 저장소를 clone 했다면 복사 단계를 건너뛰고 `bash skills/andrej-karpathy-guidelines/install.sh`를 바로 실행해도 된다.

### `create-issue` — agent teams 전제조건

이 스킬은 Claude Code 실험 기능 **agent teams**가 필요하다. 리더(현재 세션)가 팀원 2명을 spawn해 토론시키는 구조라, 이 기능이 꺼져 있으면 동작하지 않는다.

활성화하려면 `~/.claude/settings.json`(또는 프로젝트 `.claude/settings.json`)의 `env`에 다음을 추가한다.

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

- 실험 기능이라 적용에 Claude Code **재시작**이 필요할 수 있다.
- 자세한 내용은 공식 문서 참조: <https://code.claude.com/docs/en/agent-teams>

## 제공 스킬

| 스킬 | 설명 | 출처 / 라이선스 |
|---|---|---|
| `andrej-karpathy-guidelines` | LLM 코딩 실수를 줄이는 행동지침 4가지를 사용자 전역 CLAUDE.md(`~/.claude/CLAUDE.md`)에 설치한다. | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT) |
| `create-issue` | 간단한 작업 설명을 받아 agent teams(리더1+팀원2)로 세부 작업을 토론·보완해 이슈 초안으로 정리한다. | 자작 |
| `grill-me` | 의도, 제약, 숨은 가정, 대안을 집요한 인터뷰로 끌어내 컨텍스트를 확장한다. | [satya-janghu/agent-skills](https://github.com/satya-janghu/agent-skills) (MIT) |
| `humanizer` | AI가 쓴 티가 나는 글쓰기 패턴 33가지를 감지하고 자연스럽게 고쳐 쓴다. | [blader/humanizer](https://github.com/blader/humanizer) (MIT) |
| `setup-matt-pocock-skills` | Matt Pocock 엔지니어링 스킬들이 전제하는 저장소 설정(이슈 트래커, 트리아지 라벨, 도메인 문서)을 스캐폴딩한다. | [mattpocock/skills](https://github.com/mattpocock/skills) (MIT) |
| `skill-installer` | 이 카탈로그의 스킬을 체크박스로 골라 유저/프로젝트 범위로 현재 디바이스에 설치하는 메타 스킬. | 자작 |

## 새 스킬 추가

`skills/<스킬명>/SKILL.md`만 만들면 별도 등록 없이 목록에 잡힌다. frontmatter의 `name`, `description`이 필수다. 자세한 규칙은 [CLAUDE.md](CLAUDE.md)를 참조한다.
