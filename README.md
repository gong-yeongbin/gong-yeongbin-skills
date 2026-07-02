# gong-yeongbin-skills

자주 쓰는 스킬을 모아 둔 Claude Code 플러그인 마켓플레이스다. 스킬 카탈로그(`library/`)에서 원하는 스킬만 골라 사용자 전역 `~/.claude/skills/`에 설치한다.

## 동작 방식

플러그인을 설치해도 library의 스킬이 전부 로드되지는 않는다. 플러그인이 로드하는 것은 `install` 스킬 하나뿐이다. `install` 스킬이 library의 스킬 목록을 보여 주고, 사용자가 선택한 스킬만 `~/.claude/skills/<스킬명>`으로 복사한다. 필요한 스킬만 설치해 컨텍스트를 가볍게 유지하는 구조다.

## 설치

Claude Code에서 마켓플레이스를 추가하고 플러그인을 설치한다.

```
/plugin marketplace add gong-yeongbin/gong-yeongbin-skills
/plugin install gong-yeongbin-skills@gong-yeongbin
```

## 사용 방법

플러그인 설치 후 Claude Code에서 다음과 같이 요청한다.

```
스킬 설치해줘
```

"설치 가능한 스킬 보여줘", "스킬 목록에서 골라서 설치" 같은 표현도 동작한다. 이후 흐름은 다음과 같다.

1. 설치 가능한 스킬 목록이 선택 UI로 표시된다. 이미 설치된 스킬은 `[설치됨]`으로 표시된다.
2. 원하는 스킬을 여러 개 선택할 수 있다.
3. 선택한 스킬이 `~/.claude/skills/<스킬명>`으로 복사된다. 이미 설치된 스킬을 다시 선택하면 library의 최신 내용으로 갱신된다.
4. 새로 설치된 스킬은 다음 세션부터 로드된다.

## 제공 스킬

| 스킬 | 설명 | 출처 / 라이선스 |
|---|---|---|
| `andrej-karpathy-guidelines` | LLM 코딩 실수를 줄이는 행동지침 4가지를 유저 전역 또는 프로젝트 CLAUDE.md에 설치한다. | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT) |
| `grill-me` | 의도, 제약, 숨은 가정, 대안을 집요한 인터뷰로 끌어내 컨텍스트를 확장한다. | [satya-janghu/agent-skills](https://github.com/satya-janghu/agent-skills) (MIT) |
| `humanizer` | AI가 쓴 티가 나는 글쓰기 패턴 33가지를 감지하고 자연스럽게 고쳐 쓴다. | [blader/humanizer](https://github.com/blader/humanizer) (MIT) |

## 새 스킬 추가

`library/<스킬명>/SKILL.md`만 만들면 별도 등록 없이 목록에 잡힌다. frontmatter의 `description`은 반드시 한 줄로 작성한다. 자세한 규칙은 [CLAUDE.md](CLAUDE.md)를 참조한다.
