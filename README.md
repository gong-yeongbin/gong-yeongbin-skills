# gong-yeongbin-skills

자주 쓰는 Claude Code 스킬을 모아 둔 카탈로그다. 표준 [`skills`](https://github.com/vercel-labs/skills) CLI로 원하는 스킬만 골라 설치한다.

## 설치

명령 한 줄로 목록을 띄우고 골라 설치한다.

```
npx skills@latest add gong-yeongbin/gong-yeongbin-skills --list
```

- 설치 가능한 스킬 목록이 표시되고, 원하는 스킬을 골라 설치한다.
- 특정 스킬만 바로 설치하려면 `--skill <스킬명>`을 쓴다.

```
npx skills@latest add gong-yeongbin/gong-yeongbin-skills --skill humanizer
```

`skills` CLI가 어느 에이전트(Claude Code, Cursor, Codex 등)에 설치할지, 프로젝트 로컬과 유저 전역 중 어디에 둘지 물어본다.

## 제공 스킬

| 스킬 | 설명 | 출처 / 라이선스 |
|---|---|---|
| `andrej-karpathy-guidelines` | LLM 코딩 실수를 줄이는 행동지침 4가지를 사용자 전역 CLAUDE.md(`~/.claude/CLAUDE.md`)에 설치한다. | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT) |
| `grill-me` | 의도, 제약, 숨은 가정, 대안을 집요한 인터뷰로 끌어내 컨텍스트를 확장한다. | [satya-janghu/agent-skills](https://github.com/satya-janghu/agent-skills) (MIT) |
| `humanizer` | AI가 쓴 티가 나는 글쓰기 패턴 33가지를 감지하고 자연스럽게 고쳐 쓴다. | [blader/humanizer](https://github.com/blader/humanizer) (MIT) |

## 새 스킬 추가

`skills/<스킬명>/SKILL.md`만 만들면 별도 등록 없이 목록에 잡힌다. frontmatter의 `name`, `description`이 필수다. 자세한 규칙은 [CLAUDE.md](CLAUDE.md)를 참조한다.
