#!/usr/bin/env bash
set -euo pipefail

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

command -v python >/dev/null 2>&1 || fail "Python belum ada. Jalankan bash install-termux.sh dulu."

if ! python - <<'PY' >/dev/null 2>&1
import pyaes, rsa
from telethon.sync import TelegramClient
from telethon.sessions import StringSession
PY
then
  info "Installing minimal Telethon session dependencies..."
  python -m pip install --upgrade Telethon pyaes rsa six pyasn1-modules
fi

printf 'ProjectIFS STRING_SESSION generator\n'
printf 'Jangan share hasil STRING_SESSION ke siapa pun.\n\n'

API_ID_VALUE="${API_KEY:-}"
API_HASH_VALUE="${API_HASH:-}"

if [ -z "$API_ID_VALUE" ] && [ -f config.env ]; then
  API_ID_VALUE="$(grep -E '^API_KEY=' config.env | head -n1 | cut -d= -f2- || true)"
fi
if [ -z "$API_HASH_VALUE" ] && [ -f config.env ]; then
  API_HASH_VALUE="$(grep -E '^API_HASH=' config.env | head -n1 | cut -d= -f2- || true)"
fi

if [ -z "$API_ID_VALUE" ]; then
  printf 'API_KEY/API_ID dari my.telegram.org: ' > /dev/tty
  IFS= read -r API_ID_VALUE < /dev/tty
fi

if [ -z "$API_HASH_VALUE" ]; then
  printf 'API_HASH dari my.telegram.org: ' > /dev/tty
  IFS= read -r API_HASH_VALUE < /dev/tty
fi

export API_ID_VALUE API_HASH_VALUE

python - <<'PY'
import os
from telethon.sync import TelegramClient
from telethon.sessions import StringSession

api_id = int(os.environ["API_ID_VALUE"].strip())
api_hash = os.environ["API_HASH_VALUE"].strip()

with TelegramClient(StringSession(), api_id, api_hash) as client:
    session = client.session.save()
    print("\nSTRING_SESSION kamu:\n")
    print(session)
    print("\nCopy string panjang di atas ke config.env pada bagian STRING_SESSION=.")
PY
