# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 개요

Claude Code 플러그인 마켓플레이스 저장소다. 빌드/테스트/린트 도구는 없으며, 산출물은 매니페스트 JSON과 SKILL.md 문서, 부속 bash 스크립트뿐이다. 사용자는 `/plugin marketplace add gong-yeongbin/gong-yeongbin-skills`로 등록한 뒤 `/plugin install <플러그인>@gong-yeongbin-skills`로 설치한다.

## 핵심 구조

`.claude-plugin/marketplace.json`이 마켓플레이스 매니페스트다. `skills/` 아래 디렉터리 하나가 **단일 스킬 플러그인** 하나이며(SKILL.md가 플러그인 루트에 위치), marketplace.json의 엔트리가 상대 경로로 가리킨다.

```
.claude-plugin/marketplace.json              # 마켓플레이스 매니페스트 (플러그인 목록)
skills/<플러그인명>/.claude-plugin/plugin.json  # 필수. name, description (version은 생략)
skills/<플러그인명>/SKILL.md                    # 스킬 플러그인일 때. frontmatter의 name, description 필수
skills/<플러그인명>/hooks/hooks.json            # 훅 플러그인일 때 (예: andrej-karpathy-guidelines)
skills/<플러그인명>/...                         # LICENSE, guidelines.md 등 부속 파일 (선택)
```

## 새 플러그인(자체 스킬) 추가하기

1. `skills/<스킬명>/SKILL.md`를 만든다. frontmatter의 `name`, `description`이 필수다.
2. `skills/<스킬명>/.claude-plugin/plugin.json`을 만든다. `name`(디렉터리명과 동일), `description`을 넣고, 외부에서 가져온 스킬이면 `license`와 `homepage`(원 저장소)도 표기한다. **`version`은 넣지 않는다.** version이 있으면 그 값을 올려야만 설치자에게 업데이트로 인식되고, 생략하면 git 커밋 SHA가 버전으로 쓰여 커밋·push만으로 새 버전이 된다. 이 저장소의 자체 플러그인은 후자를 쓴다.
3. `.claude-plugin/marketplace.json`의 `plugins` 배열에 엔트리를 추가한다. `{ "name": "<스킬명>", "source": "./skills/<스킬명>", "description": "<한국어 한 줄>" }` 형식이다.
4. 외부에서 가져온 스킬이면 원본 라이선스 파일(예: `LICENSE`)을 같은 디렉터리에 함께 둔다. 플러그인 설치 시 디렉터리 전체가 복사되므로 재배포 조건이 유지된다.
5. 매 세션 자동으로 적용돼야 하는 지침형 플러그인은 SKILL.md 대신 `hooks/hooks.json`의 SessionStart 훅으로 만든다. 훅 command의 stdout이 세션 컨텍스트에 그대로 주입되며, 번들 파일은 `${CLAUDE_PLUGIN_ROOT}` 기준으로 참조한다. `andrej-karpathy-guidelines`가 이 방식이다(`cat "${CLAUDE_PLUGIN_ROOT}"/guidelines.md`). 플러그인에는 설치 시점 1회 실행 훅이 없으므로, 설치형 스크립트 방식은 쓰지 않는다.

## 외부 플러그인 등록하기

다른 저장소의 플러그인을 이 마켓플레이스에 노출하려면 `.claude-plugin/marketplace.json`의 `plugins` 배열에 엔트리만 추가하면 된다. `source`는 세 가지 형식을 지원한다.

```json
{ "name": "<이름>", "source": { "source": "url", "url": "https://github.com/owner/repo.git" } }
{ "name": "<이름>", "source": { "source": "github", "repo": "owner/repo" } }
{ "name": "<이름>", "source": { "source": "npm", "package": "@org/plugin" } }
```

- **`url`(HTTPS) 형식을 기본으로 쓴다.** `github` 형식은 SSH로 clone을 시도해서 GitHub SSH 키가 없는 환경에서 설치가 실패하는 것을 확인했다(2026-07-23). 공개 저장소는 HTTPS면 인증 없이 받는다.
- 대상 저장소가 플러그인 형태(`.claude-plugin/plugin.json` 보유)인지 먼저 확인한다. 매니페스트가 없는 저장소는 엔트리에 `strict: false`가 필요하다.
- 외부 플러그인은 파일을 이 저장소로 복사하지 않으므로 LICENSE 동봉 의무가 없다. README의 "등록된 외부 플러그인" 표에 출처를 표기한다.

## 자주 쓰는 명령

```bash
# JSON 매니페스트 문법 검증
python3 -m json.tool .claude-plugin/marketplace.json > /dev/null

# 마켓플레이스·플러그인 스키마 검증
claude plugin validate .

# 로컬 체크아웃으로 설치 동작 검증 (커밋 전 테스트)
claude plugin marketplace add <저장소 절대경로>
claude plugin install <스킬명>@gong-yeongbin-skills
# 확인 후 원복
claude plugin uninstall <스킬명>
claude plugin marketplace remove gong-yeongbin-skills
```

GitHub 원격 기준 설치는 push된 상태만 반영하므로, 커밋 전 검증은 반드시 로컬 절대 경로로 한다.

## 컨벤션

- 커밋 메시지는 한국어이며 Conventional Commits 접두사(`feat:`, `refactor:` 등)를 쓴다.
- SKILL.md 본문 등 문서는 한국어로 작성한다. 단 외부에서 원문 그대로 가져온 스킬(예: `humanizer`)은 원문을 유지한다. marketplace.json 엔트리의 `description`은 한국어 한 줄, plugin.json의 `description`은 SKILL.md frontmatter 원문을 따른다.
- 외부 스킬·플러그인은 출처와 라이선스를 README 표에 표기한다.

## 절대 규칙

- **git 명령어 실행 금지.** `git commit`, `git add`, `git push` 같은 변경 명령뿐 아니라 `git status`, `git log` 같은 조회성 명령도 포함한다. 버전 관리는 사용자가 직접 수행한다.
