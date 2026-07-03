---
name: andrej-karpathy-guidelines
description: LLM이 코딩에서 자주 저지르는 실수를 줄이기 위한 행동지침을 사용자 전역 CLAUDE.md(~/.claude/CLAUDE.md)에 설치한다. "카파시 지침 설치", "andrej-karpathy 지침 추가", "코딩 행동지침을 CLAUDE.md에 넣어줘" 같은 요청 시 실행한다.
---

# andrej-karpathy-guidelines

Andrej Karpathy가 강조해 온, LLM 코딩 실수를 줄이는 행동지침을 사용자 전역
`~/.claude/CLAUDE.md`에 주입하는 스킬이다. 이 파일에 주입하면 모든 프로젝트의
모든 세션에서 항상 적용된다.

## 무엇을 하는가

`guidelines.md`의 내용을 아래 마커로 감싸 `~/.claude/CLAUDE.md` 끝에 추가한다.

```
<!-- andrej-karpathy-guidelines:start -->
... 지침 본문 ...
<!-- andrej-karpathy-guidelines:end -->
```

동일 마커가 이미 있으면 그 블록만 최신 내용으로 교체한다. 따라서 여러 번
실행해도 중복되지 않는다(idempotent).

## 실행 방법

이 SKILL.md와 같은 디렉터리의 `install.sh`를 실행한다. 이 스크립트가 대상 파일
생성, 마커 기반 삽입/교체를 모두 처리한다.

```bash
bash "$(dirname "$0")/install.sh"
```

스킬이 설치된 디렉터리에서 실행하며, 별도 인자는 없다.

## 실행 후

- 스크립트가 `installed:` 또는 `updated:` 메시지를 출력한다. 그 결과를 사용자에게
  보고한다.
- 전역 CLAUDE.md를 변경했으므로, 변경 사항이 이후 세션부터 적용된다는 점을 알린다.
- 이미 존재하는 세션에는 즉시 반영되지 않을 수 있음을 언급한다.

## 주입되는 지침 내용

`guidelines.md` 참조. 핵심 4개 항목이다.

1. Think Before Coding — 가정을 명시하고, 불명확하면 질문한다.
2. Simplicity First — 문제를 푸는 최소한의 코드만 작성한다.
3. Surgical Changes — 요청과 직접 연결된 변경만 한다.
4. Goal-Driven Execution — 검증 가능한 성공 기준을 정의하고 통과할 때까지 반복한다.
