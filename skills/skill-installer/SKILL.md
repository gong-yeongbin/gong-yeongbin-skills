---
name: skill-installer
description: gong-yeongbin-skills 카탈로그의 스킬 목록을 체크박스로 보여주고, 선택한 스킬을 유저(~/.claude/skills) 또는 프로젝트(.claude/skills) 범위로 현재 디바이스에 설치한다. "스킬 설치해줘", "스킬 추가해줘", "카탈로그에서 스킬 골라줘", "스킬 목록 보여줘" 같은 요청 시 실행한다.
---

# skill-installer

카탈로그 저장소의 스킬을 골라 현재 디바이스에 설치하는 메타 스킬이다. 목록 조회와
파일 복사는 이 SKILL.md와 같은 디렉터리의 `installer.sh`가 전담하고, 이 문서는
그 사이의 대화 절차를 정의한다.

**경로 주의.** 아래에서 `<skill-dir>`은 이 SKILL.md가 설치되어 있는 디렉터리의
절대 경로다. 스킬이 로드될 때 표시된 경로를 그대로 쓴다. `$(dirname "$0")` 같은
shell 변수로 유추하면 안 된다. Claude가 실행하는 shell에서 `$0`은 이 파일이 아니다.

## 1. 목록 조회

```bash
bash <skill-dir>/installer.sh list
```

출력은 한 줄에 하나씩 `스킬명<TAB>설치상태<TAB>설명` 형식이다. 설치상태는
`user`, `project`, `user,project`, `-`(미설치) 중 하나다. 기본 소스는 GitHub의
`gong-yeongbin/gong-yeongbin-skills` 원격이며, 얕은 clone으로 가져온다.

## 2. 스킬 선택 (체크박스)

AskUserQuestion 도구로 설치할 스킬을 고르게 한다.

- multiSelect: true 질문을 사용한다. 질문 하나당 옵션은 최대 4개이므로 스킬이
  4개를 넘으면 "설치할 스킬 (1/2)", "설치할 스킬 (2/2)"처럼 질문을 나눈다. 한 번의
  호출에 질문을 4개까지 담을 수 있다.
- 옵션 label은 스킬명, description은 설명 요약이다. 이미 설치된 스킬은 설명 앞에
  `[user 설치됨]`처럼 현재 상태를 표기해 재설치(업데이트)인지 알 수 있게 한다.
- 같은 호출의 **마지막 질문**으로 설치 범위를 묻는다. 옵션 두 개다.
  - `유저` — `~/.claude/skills`. 이 디바이스의 모든 프로젝트에서 사용.
  - `프로젝트` — `<현재 프로젝트>/.claude/skills`. 이 프로젝트에서만 사용하며 git 커밋 대상.

## 3. 설치

선택 결과로 install을 실행한다. scope는 `user` 또는 `project`다.

```bash
bash <skill-dir>/installer.sh install <scope> <스킬명> [<스킬명>...]
```

- 이미 설치된 스킬은 삭제 후 다시 복사되므로 재선택이 곧 업데이트다.
- `project` 범위는 현재 작업 디렉터리 기준이므로 프로젝트 루트에서 실행해야 한다.

## 4. 보고

- installer.sh가 출력한 `installed:` 줄을 근거로 설치된 스킬과 경로를 보고한다.
- 새로 설치된 스킬은 다음 세션부터 자동 로드된다는 점을 알린다.

## 참고

- 원격 대신 로컬 체크아웃을 소스로 쓰려면 `SKILLS_REPO=<카탈로그 경로>` 환경변수를
  앞에 붙인다. 카탈로그 저장소 자체를 수정 중일 때의 테스트 용도다.
