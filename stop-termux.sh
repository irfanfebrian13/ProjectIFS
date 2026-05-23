#!/usr/bin/env bash
set -euo pipefail

PID_FILE="projectifs.pid"
LOG_FILE="projectifs.log"

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m[DONE]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }

stopped=0

if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" >/dev/null 2>&1; then
    info "Stopping ProjectIFS PID $pid..."
    kill "$pid" || true
    stopped=1
  fi
  rm -f "$PID_FILE"
fi

# Fallback if PID file is stale/missing.
if pgrep -f "python -m userbot" >/dev/null 2>&1; then
  info "Stopping remaining python -m userbot processes..."
  pkill -f "python -m userbot" || true
  stopped=1
fi

if [ "$stopped" = "1" ]; then
  success "ProjectIFS stopped. Log tetap tersimpan di $LOG_FILE"
else
  warn "Tidak ada proses ProjectIFS yang sedang jalan."
fi

if command -v termux-wake-unlock >/dev/null 2>&1; then
  termux-wake-unlock || true
fi
