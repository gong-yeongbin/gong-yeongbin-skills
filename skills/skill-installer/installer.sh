#!/usr/bin/env bash
# 카탈로그 스킬 목록 조회(list)와 선택 스킬의 유저/프로젝트 범위 설치(install)를 처리하는 스크립트
set -euo pipefail

REPO="${SKILLS_REPO:-https://github.com/gong-yeongbin/gong-yeongbin-skills}"
CLONED=0
SRC=""

usage() {
  echo "usage: installer.sh list" >&2
  echo "       installer.sh install <user|project> <skill>..." >&2
  exit 1
}

cleanup() {
  if [[ "$CLONED" == 1 && -n "$SRC" ]]; then rm -rf "$SRC"; fi
}
trap cleanup EXIT

# REPO가 skills/ 를 가진 로컬 디렉터리면 그대로 쓰고, 아니면 얕은 clone
resolve_source() {
  if [[ -d "$REPO/skills" ]]; then
    SRC="$REPO"
  else
    SRC="$(mktemp -d)"
    CLONED=1
    git clone --quiet --depth 1 "$REPO" "$SRC"
  fi
  if [[ ! -d "$SRC/skills" ]]; then
    echo "error: no skills/ directory in $REPO" >&2
    exit 1
  fi
}

# frontmatter 첫 블록에서 필드 값 추출. $1=SKILL.md 경로, $2=필드명
frontmatter_field() {
  awk -v field="$2" '
    NR == 1 && $0 == "---" { in_fm = 1; next }
    in_fm && $0 == "---" { exit }
    in_fm && index($0, field ": ") == 1 { print substr($0, length(field) + 3); exit }
  ' "$1"
}

# 스킬명<TAB>설치상태<TAB>설명 을 한 줄씩 출력. 설치상태는 user, project, user,project, - 중 하나
cmd_list() {
  resolve_source
  local dir name desc status
  for dir in "$SRC"/skills/*/; do
    [[ -f "$dir/SKILL.md" ]] || continue
    name="$(basename "$dir")"
    desc="$(frontmatter_field "$dir/SKILL.md" description)"
    status=""
    [[ -f "$HOME/.claude/skills/$name/SKILL.md" ]] && status="user"
    if [[ -f "$PWD/.claude/skills/$name/SKILL.md" ]]; then
      status="${status:+$status,}project"
    fi
    printf '%s\t%s\t%s\n' "$name" "${status:--}" "$desc"
  done
}

cmd_install() {
  local scope="$1"; shift
  [[ $# -ge 1 ]] || usage
  local target
  case "$scope" in
    user)    target="$HOME/.claude/skills" ;;
    project) target="$PWD/.claude/skills" ;;
    *)       usage ;;
  esac
  resolve_source
  local name
  for name in "$@"; do
    if [[ ! -f "$SRC/skills/$name/SKILL.md" ]]; then
      echo "error: skill not found in catalog: $name" >&2
      exit 1
    fi
  done
  mkdir -p "$target"
  for name in "$@"; do
    rm -rf "$target/$name"
    cp -R "$SRC/skills/$name" "$target/$name"
    echo "installed: $name -> $target/$name"
  done
}

[[ $# -ge 1 ]] || usage
case "$1" in
  list)    cmd_list ;;
  install) shift; [[ $# -ge 2 ]] || usage; cmd_install "$@" ;;
  *)       usage ;;
esac
