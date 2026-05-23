#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="projectifs.log"
PID_FILE="projectifs.pid"

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m[DONE]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

if [ ! -f config.env ]; then
  fail "config.env belum ada. Jalankan: bash install-termux.sh lalu isi config.env"
fi

set -a
# shellcheck disable=SC1091
. ./config.env
set +a

missing=""
[ -n "${API_KEY:-}" ] || missing="$missing API_KEY"
[ -n "${API_HASH:-}" ] || missing="$missing API_HASH"
[ -n "${STRING_SESSION:-}" ] || missing="$missing STRING_SESSION"

if [ -n "$missing" ]; then
  fail "Env wajib belum diisi:$missing. Edit dulu: nano config.env"
fi

if [ -f "$PID_FILE" ]; then
  old_pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$old_pid" ] && kill -0 "$old_pid" >/dev/null 2>&1; then
    warn "ProjectIFS sepertinya sudah jalan dengan PID $old_pid"
    warn "Log: tail -f $LOG_FILE"
    exit 0
  fi
fi

if command -v termux-wake-lock >/dev/null 2>&1; then
  info "Requesting Termux wake lock..."
  termux-wake-lock || true
fi

info "Starting ProjectIFS in background..."
nohup python -m userbot > "$LOG_FILE" 2>&1 &
pid=$!
echo "$pid" > "$PID_FILE"
success "ProjectIFS started with PID $pid"

cat <<MSG

Cek log:
  tail -f $LOG_FILE

Stop bot:
  bash stop-termux.sh

Test di Telegram:
  .alive
MSG
