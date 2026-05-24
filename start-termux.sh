#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="projectifs.log"
PID_FILE="projectifs.pid"

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m[DONE]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

RESTART=false
NO_UPDATE=false
for arg in "$@"; do
  case "$arg" in
    --restart) RESTART=true ;;
    --no-update) NO_UPDATE=true ;;
    *) fail "Argumen tidak dikenal: $arg" ;;
  esac
done

if [ ! -f config.env ]; then
  fail "config.env belum ada. Jalankan bash install-termux.sh lalu isi config.env."
fi

if [ "$RESTART" = true ]; then
  bash stop-termux.sh || true
fi

if [ -f "$PID_FILE" ]; then
  old_pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
    success "ProjectIFS sudah berjalan dengan PID $old_pid"
    exit 0
  fi
fi

if [ "$NO_UPDATE" = false ]; then
  if [ -x ./update-termux.sh ]; then
    bash ./update-termux.sh
  else
    info "Updating repository and requirements..."
    git pull --ff-only || true
    python -m pip install -r requirements.txt
  fi
fi

if command -v termux-wake-lock >/dev/null 2>&1; then
  termux-wake-lock || true
fi

info "Starting ProjectIFS in background..."
nohup python -m userbot > "$LOG_FILE" 2>&1 &
pid=$!
echo "$pid" > "$PID_FILE"
sleep 2

if kill -0 "$pid" 2>/dev/null; then
  success "ProjectIFS started with PID $pid"
  printf 'Log: tail -f %s\n' "$LOG_FILE"
else
  warn "ProjectIFS tampaknya langsung berhenti. Log terakhir:"
  tail -80 "$LOG_FILE" || true
  exit 1
fi
