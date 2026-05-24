#!/usr/bin/env bash
set -euo pipefail

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m[DONE]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }

info "Updating ProjectIFS repository..."
if command -v git >/dev/null 2>&1 && [ -d .git ]; then
  git pull --ff-only
else
  warn "Folder ini bukan git repo atau git belum tersedia; skip git pull."
fi

info "Installing/updating Python requirements..."
python -m pip install -r requirements.txt

success "Update selesai. Kalau bot sedang jalan, restart dengan: bash start-termux.sh --restart"
