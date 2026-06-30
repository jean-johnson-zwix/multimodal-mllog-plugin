#!/usr/bin/env bash
# mllog Stop hook: reads transcript_path from Claude Code stdin, passes to mllog capture.
set -euo pipefail

MLLOG="$CLAUDE_PROJECT_ROOT/.venv/bin/mllog"
[ ! -f "$MLLOG" ] && exit 0

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('transcript_path',''))" 2>/dev/null || true)

ARGS=(--type analysis --outcome success --auto)
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    ARGS+=(--transcript "$TRANSCRIPT_PATH")
fi

"$MLLOG" capture "${ARGS[@]}" 2>/dev/null
exit 0
