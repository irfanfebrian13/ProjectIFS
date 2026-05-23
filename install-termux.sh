#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="ProjectIFS"
LOG_FILE="projectifs.log"

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
success() { printf '\033[1;32m[DONE]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

if ! command -v pkg >/dev/null 2>&1; then
  fail "Script ini khusus Termux/Android karena memakai command pkg."
fi

info "Updating Termux package index..."
pkg update -y

info "Installing system packages needed by ${PROJECT_NAME}..."
pkg install -y \
  python \
  python-psutil \
  git \
  clang \
  make \
  pkg-config \
  libxml2 \
  libxslt \
  openssl \
  libffi \
  libjpeg-turbo \
  zlib \
  ffmpeg \
  aria2 \
  neofetch

info "Upgrading pip/setuptools/wheel..."
python -m pip install --upgrade pip setuptools wheel

info "Installing Python requirements. This can take several minutes on first run..."
python -m pip install --no-deps -r requirements.txt

if [ ! -f config.env ]; then
  info "Creating config.env from sample_config.env..."
  cp sample_config.env config.env
else
  warn "config.env already exists; not overwriting it."
fi

cat <<'MSG'

============================================================
ProjectIFS Termux setup selesai.
============================================================

Langkah berikutnya:
1. Edit config.env lalu isi minimal:
   - API_KEY
   - API_HASH
   - STRING_SESSION

   Command:
     nano config.env

2. Kalau belum punya STRING_SESSION, jalankan:
     bash session-termux.sh

3. Start bot:
     bash start-termux.sh

4. Cek log:
     tail -f projectifs.log

5. Stop bot:
     bash stop-termux.sh

Tips:
- Jalankan termux-wake-lock supaya Android tidak mudah menidurkan proses.
- Jangan share STRING_SESSION/API_HASH ke siapa pun.
============================================================
MSG
