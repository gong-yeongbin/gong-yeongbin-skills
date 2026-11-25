---
name: agent-definition
description: "인터뷰로 명세를 굳힌 뒤 3인 팀(spec-reviewer·author·reviewer)으로 에이전트 정의 파일(.claude/agents/<name>.md) 1개를 생성. '에이전트 정의', '에이전트 만들어줘', '서브에이전트 만들어줘', 'agent definition' 같은 자연어 요청 시 반드시 사용."
allowed-tools: Bash Read Write
---

# Agent Definition Skill
메인 세션이 인터뷰로 명세를 만들고, 3인 팀을 순차로 호출해 `references/template.md` 규격의 에이전트 정의 파일 1개를 생성한다.

## 준비
- 이 스킬의 base directory 를 `<SKILL_DIR>` 라 한다. 서브에이전트는 이 경로를 모르므로 매 호출 프롬프트에 `<SKILL_DIR>/references/template.md` 절대경로를 넣는다.
- 작업 파일은 현재 프로젝트의 `_workspace/` 에 둔다.

## Workflow
1. 인터뷰.
   `<SKILL_DIR>/references/interview.md` 규칙대로 사용자와 1문1답 인터뷰를 한다.
   결정 표를 보여 주고 사용자가 확인하면 같은 문서의 명세 형식으로 `_workspace/agent-spec.md` 를 쓴다.
2. 명세 검증.
   `agent-definition:agent-spec-reviewer` 에이전트를 Agent 도구로 호출.
   출력은 `_workspace/spec-review.md`.
   - PASS. 3단계로.
   - REDO. 수정 지시에 해당하는 항목만 사용자에게 다시 물어 명세를 고친 뒤 재호출 (최대 3회).
3. author 호출.
   `agent-definition:agent-def-author` 에이전트를 Agent 도구로 호출.
   출력은 `_workspace/agent-draft.md`.
4. reviewer 호출.
   `agent-definition:agent-def-reviewer` 에이전트를 Agent 도구로 호출.
   출력은 `_workspace/def-review.md`.
   - PASS. 5단계로.
   - REDO. reviewer 수정 지시를 프롬프트에 포함해 author 재호출 (최대 3회).
5. 반영.
   `_workspace/agent-draft.md` 를 사용자에게 제시하고 `.claude/agents/<name>.md` 로 복사한다.
   같은 경로에 파일이 이미 있으면 덮어쓰기 전에 사용자 확인을 받는다.
6. 루프 종료.
   2·4단계에서 재호출 3회 초과 시 종료.
   초과 시 "자동 승인 한계 도달 – 수동 검토 권장" 경고와 함께 마지막 명세 또는 draft 를 반환하고 복사하지 않는다.
