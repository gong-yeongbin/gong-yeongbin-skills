---
name: install
description: gong-yeongbin-skills 플러그인 library에 있는 설치 가능한 스킬 목록을 보여주고, 사용자가 선택한 스킬만 ~/.claude/skills 에 설치한다. "스킬 설치", "설치 가능한 스킬 보여줘", "스킬 목록에서 골라서 설치" 같은 요청 시 실행한다.
---

# install

플러그인 `library/` 디렉터리에 모아 둔 스킬들의 목록을 사용자에게 보여주고,
선택된 스킬만 사용자 전역 `~/.claude/skills/` 에 복사 설치하는 스킬이다.

## 절차

### 1. 설치 가능한 스킬 목록 조회

스킬 디렉터리의 `install.sh`를 `--list` 옵션으로 실행한다.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/install/install.sh" --list
```

`CLAUDE_PLUGIN_ROOT`가 없는 환경(로컬 개발 등)에서는 이 SKILL.md가 있는
디렉터리의 `install.sh`를 직접 지정해 실행한다.

출력은 한 줄에 스킬 하나씩, 탭으로 구분된 세 필드다.

```
<스킬명>	<상태>	<설명>
```

- 상태 `new`: 아직 설치되지 않음.
- 상태 `installed`: `~/.claude/skills/<스킬명>` 이 이미 존재함. 다시 선택하면
  library의 최신 내용으로 갱신된다.

목록이 비어 있으면 "library에 설치 가능한 스킬이 없다"고 보고하고 종료한다.

### 2. 선택 UI 표시

AskUserQuestion 도구로 스킬 선택 UI를 띄운다.

- `multiSelect: true`로 설정해 여러 개를 한 번에 고를 수 있게 한다.
- 각 옵션의 `label`은 스킬명, `description`은 목록의 설명을 사용한다.
  상태가 `installed`면 설명 앞에 "[설치됨 — 선택 시 최신으로 갱신] "을 붙인다.
- 질문 하나에 옵션은 최대 4개다. 스킬이 4개를 넘으면 4개씩 나눠 질문을
  구성한다(호출당 질문 최대 4개, 그래도 넘치면 AskUserQuestion을 여러 번 호출).

### 3. 선택된 스킬 설치

사용자가 아무것도 선택하지 않았으면 설치 없이 종료한다.
선택된 스킬명들을 인자로 `install.sh`를 실행한다.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/install/install.sh" <스킬명1> <스킬명2> ...
```

스크립트는 스킬별로 `installed:` 또는 `updated:` 한 줄을 출력한다.

### 4. 결과 보고

- 설치/갱신된 스킬 목록을 사용자에게 보고한다.
- 새로 설치된 스킬은 다음 세션부터 로드된다는 점을 안내한다.
