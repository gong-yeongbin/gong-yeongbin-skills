# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 개요

Claude Code 플러그인 마켓플레이스 저장소다. 빌드/테스트/린트 도구는 없으며, 산출물은 SKILL.md 문서와 bash 스크립트뿐이다.

- `.claude-plugin/marketplace.json` — 마켓플레이스 매니페스트. 플러그인 목록과 소스 경로를 정의한다.
- `plugins/gong-yeongbin-skills/` — 유일한 플러그인. 매니페스트는 `.claude-plugin/plugin.json`이다.

## 핵심 아키텍처 — 2단계 스킬 구조

플러그인 안에서 스킬이 두 계층으로 나뉜다. 이 구분이 이 저장소를 이해하는 열쇠다.

| 경로 | 역할 |
|---|---|
| `plugins/gong-yeongbin-skills/skills/` | 플러그인 설치 시 자동 로드되는 스킬. 현재 `install` 하나뿐이다. |
| `plugins/gong-yeongbin-skills/library/` | 배포용 카탈로그. 플러그인 스킬로 로드되지 않는다. |

동작 흐름은 다음과 같다. `install` 스킬이 `skills/install/install.sh`를 호출하고, 이 스크립트가 `library/*/SKILL.md`를 스캔해 목록을 만들거나(`--list`) 사용자가 선택한 스킬 디렉터리를 `~/.claude/skills/<스킬명>`으로 통째로 복사한다. 기존 디렉터리는 삭제 후 재복사되어 갱신된다.

## library에 새 스킬 추가하기

1. `plugins/gong-yeongbin-skills/library/<스킬명>/SKILL.md`를 만든다. frontmatter의 `name`, `description`이 필수다.
2. `description`은 frontmatter에서 반드시 한 줄이어야 한다. `install.sh --list`가 `awk '/^description:/'`로 첫 줄만 파싱하므로 여러 줄로 쓰면 목록에서 잘린다.
3. `plugins/gong-yeongbin-skills/.claude-plugin/plugin.json`의 `version`을 올린다. 기존 커밋들이 이 관례를 따른다.

별도 등록 절차는 없다. `library/` 아래 디렉터리에 SKILL.md만 있으면 `--list`가 자동으로 집어 올린다.

## 자주 쓰는 명령

```bash
# library 스킬 목록 확인 (스킬명<TAB>상태<TAB>설명)
bash plugins/gong-yeongbin-skills/skills/install/install.sh --list

# 특정 스킬 설치 동작 검증 — 실제 ~/.claude/skills 에 복사되므로 주의
bash plugins/gong-yeongbin-skills/skills/install/install.sh <스킬명>
```

## 컨벤션

- 커밋 메시지는 한국어이며 Conventional Commits 접두사(`feat:`, `refactor:` 등)를 쓴다.
- SKILL.md 본문, 매니페스트의 description 등 문서는 한국어로 작성한다.
- 일부 library 스킬(예: `andrej-karpathy-guidelines`)은 자체 `install.sh`를 포함하며, 스킬 실행 시 그 스크립트가 실제 설치 동작을 수행한다.

## 절대 규칙

- **git 명령어 실행 금지.** `git commit`, `git add`, `git push` 같은 변경 명령뿐 아니라 `git status`, `git log` 같은 조회성 명령도 포함한다. 버전 관리는 사용자가 직접 수행한다.
