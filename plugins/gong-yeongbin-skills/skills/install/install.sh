#!/usr/bin/env bash
# library의 스킬 목록을 조회(--list)하거나 선택된 스킬을 ~/.claude/skills 에 복사 설치하는 스크립트
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBRARY_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)/library"
TARGET_DIR="$HOME/.claude/skills"

if [[ $# -lt 1 ]]; then
  echo "usage: install.sh --list | install.sh <skill-name>..." >&2
  exit 1
fi

if [[ ! -d "$LIBRARY_DIR" ]]; then
  echo "error: library directory not found at $LIBRARY_DIR" >&2
  exit 1
fi

# --list: 스킬명<TAB>상태(new|installed)<TAB>설명 형식으로 한 줄씩 출력
if [[ "$1" == "--list" ]]; then
  for skill_md in "$LIBRARY_DIR"/*/SKILL.md; do
    [[ -f "$skill_md" ]] || continue
    name="$(basename "$(dirname "$skill_md")")"
    desc="$(awk '/^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$skill_md")"
    if [[ -d "$TARGET_DIR/$name" ]]; then status="installed"; else status="new"; fi
    printf '%s\t%s\t%s\n' "$name" "$status" "$desc"
  done
  exit 0
fi

mkdir -p "$TARGET_DIR"
for name in "$@"; do
  # 경로 조작으로 ~/.claude/skills 밖을 건드리지 못하게 스킬명을 검증
  case "$name" in
    */*|.|..|"") echo "error: invalid skill name: $name" >&2; exit 1 ;;
  esac
  src="$LIBRARY_DIR/$name"
  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "error: skill not found in library: $name" >&2
    exit 1
  fi
  if [[ -d "$TARGET_DIR/$name" ]]; then verb="updated"; else verb="installed"; fi
  rm -rf "$TARGET_DIR/$name"
  cp -R "$src" "$TARGET_DIR/$name"
  echo "$verb: $name -> $TARGET_DIR/$name"
done
