#!/bin/sh
# AGENTS.md 전역 설치 (macOS/Linux) — Codex + Claude Code + Grok Build 동시 적용
# 사용법: 레포 클론 후 레포 루트에서  sh install.sh
set -e

SRC="$(cd "$(dirname "$0")" && pwd)/AGENTS.md"
[ -f "$SRC" ] || { echo "AGENTS.md를 찾을 수 없습니다: $SRC"; exit 1; }

# 1) Codex 전역 (실파일 = 단일 원본)
mkdir -p "$HOME/.codex"
CODEX_FILE="$HOME/.codex/AGENTS.md"
if [ -f "$CODEX_FILE" ]; then
  BAK="$CODEX_FILE.bak-$(date +%Y%m%d-%H%M%S)"
  cp "$CODEX_FILE" "$BAK"
  echo "기존 파일 백업: $BAK"
fi
cp "$SRC" "$CODEX_FILE"
echo "설치: $CODEX_FILE"

# 2) Claude Code 전역 (참조 한 줄, 기존 내용 보존)
mkdir -p "$HOME/.claude"
CLAUDE_FILE="$HOME/.claude/CLAUDE.md"
IMPORT_LINE='@~/.codex/AGENTS.md'
if [ -f "$CLAUDE_FILE" ]; then
  if ! grep -qF "$IMPORT_LINE" "$CLAUDE_FILE"; then
    TMP="$(mktemp)"
    { printf '%s\n\n' "$IMPORT_LINE"; cat "$CLAUDE_FILE"; } > "$TMP"
    mv "$TMP" "$CLAUDE_FILE"
    echo "기존 CLAUDE.md 첫 줄에 참조 추가: $CLAUDE_FILE"
  else
    echo "참조 이미 존재: $CLAUDE_FILE"
  fi
else
  printf '%s\n' "$IMPORT_LINE" > "$CLAUDE_FILE"
  echo "생성: $CLAUDE_FILE"
fi

# 3) Grok Build 전역 (~/.grok/rules/ 는 모든 프로젝트에 항상 로드됨)
GROK_RULES="${GROK_HOME:-$HOME/.grok}/rules"
mkdir -p "$GROK_RULES"
cp "$SRC" "$GROK_RULES/AGENTS.md"
echo "설치: $GROK_RULES/AGENTS.md"

echo ""
echo "완료. 새 세션부터 Claude Code·Codex·Grok Build 모두에 적용됩니다."
