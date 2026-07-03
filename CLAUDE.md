# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 개요

Claude Code 스킬 카탈로그 저장소다. 빌드/테스트/린트 도구는 없으며, 산출물은 SKILL.md 문서와 부속 bash 스크립트뿐이다. 표준 도구 [`skills`](https://github.com/vercel-labs/skills) CLI로 설치하는 것을 전제로 한다.

## 핵심 구조

`skills/` 아래에 스킬 하나당 디렉터리 하나가 있고, 각 디렉터리에 `SKILL.md`와 필요한 부속 파일이 들어간다.

```
skills/<스킬명>/SKILL.md      # 필수. frontmatter의 name, description 필수
skills/<스킬명>/...           # LICENSE, install.sh 등 부속 파일 (선택)
```

`skills` CLI는 기본 탐색에서 `skills/<스킬명>/SKILL.md` 깊이를 자동으로 집어 올린다. 사용자가 `npx skills@latest add gong-yeongbin/gong-yeongbin-skills --list` 를 실행하면 이 목록이 그대로 선택지로 뜨고, 고른 스킬이 SKILL.md와 같은 디렉터리의 부속 파일까지 통째로 복사된다.

## 새 스킬 추가하기

1. `skills/<스킬명>/SKILL.md`를 만든다. frontmatter의 `name`, `description`이 필수다.
2. 외부에서 가져온 스킬이면 원본 라이선스 파일(예: `LICENSE`)을 같은 디렉터리에 함께 둔다. `skills` CLI가 부속 파일까지 복사하므로 재배포 조건이 유지된다.
3. 스킬이 실행 시 별도 설치 동작(예: CLAUDE.md에 지침 주입)을 수행해야 하면 `install.sh` 같은 부속 스크립트를 같은 디렉터리에 두고, SKILL.md 본문에서 그 실행 방법을 지시한다. `andrej-karpathy-guidelines`가 이 방식이다.

별도 등록 절차는 없다. `skills/` 아래 디렉터리에 SKILL.md만 있으면 `skills` CLI가 자동으로 집어 올린다.

## 자주 쓰는 명령

```bash
# 카탈로그 스킬 목록 확인 (로컬 저장소 기준)
npx -y skills@latest add . --list

# 특정 스킬 설치 동작 검증 (프로젝트 로컬 .claude/skills 에 복사됨)
npx -y skills@latest add . --skill <스킬명> --yes
```

## 컨벤션

- 커밋 메시지는 한국어이며 Conventional Commits 접두사(`feat:`, `refactor:` 등)를 쓴다.
- SKILL.md 본문 등 문서는 한국어로 작성한다. 단 외부에서 원문 그대로 가져온 스킬(예: `humanizer`)은 원문을 유지한다.
- 외부 스킬은 출처와 라이선스를 README 표에 표기한다.

## 절대 규칙

- **git 명령어 실행 금지.** `git commit`, `git add`, `git push` 같은 변경 명령뿐 아니라 `git status`, `git log` 같은 조회성 명령도 포함한다. 버전 관리는 사용자가 직접 수행한다.
