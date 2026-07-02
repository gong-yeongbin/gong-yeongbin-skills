#!/usr/bin/env bash
# guidelines.md 내용을 사용자 전역 ~/.claude/CLAUDE.md 에 마커 블록으로 idempotent하게 주입하는 스크립트
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUIDELINES="$SCRIPT_DIR/guidelines.md"
TARGET="$HOME/.claude/CLAUDE.md"
START_MARKER="<!-- andrej-karpathy-guidelines:start -->"
END_MARKER="<!-- andrej-karpathy-guidelines:end -->"

if [[ ! -f "$GUIDELINES" ]]; then
  echo "error: guidelines.md not found at $GUIDELINES" >&2
  exit 1
fi

mkdir -p "$(dirname "$TARGET")"
touch "$TARGET"

# 마커로 감싼 새 블록을 임시 파일로 구성
BLOCK="$(mktemp)"
trap 'rm -f "$BLOCK"' EXIT
{
  echo "$START_MARKER"
  cat "$GUIDELINES"
  echo "$END_MARKER"
} > "$BLOCK"

if grep -qF "$START_MARKER" "$TARGET"; then
  # 기존 블록을 새 블록으로 교체 (start~end 구간 삭제 후 그 자리에 삽입)
  UPDATED="$(mktemp)"
  awk -v start="$START_MARKER" -v end="$END_MARKER" -v blockfile="$BLOCK" '
    $0 == start { inblock=1; while ((getline line < blockfile) > 0) print line; next }
    $0 == end   { inblock=0; next }
    !inblock    { print }
  ' "$TARGET" > "$UPDATED"
  mv "$UPDATED" "$TARGET"
  echo "updated: replaced existing andrej-karpathy-guidelines block in $TARGET"
else
  # 파일 끝에 새 블록을 추가 (앞에 빈 줄 하나)
  if [[ -s "$TARGET" ]]; then echo "" >> "$TARGET"; fi
  cat "$BLOCK" >> "$TARGET"
  echo "installed: appended andrej-karpathy-guidelines block to $TARGET"
fi
