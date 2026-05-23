#!/usr/bin/env bash
set -euo pipefail

fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

command -v python >/dev/null 2>&1 || fail "Python belum ada. Jalankan bash install-termux.sh dulu."

python - <<'PY'
from telethon.sync import TelegramClient
from telethon.sessions import StringSession

print("ProjectIFS STRING_SESSION generator")
print("Jangan share hasil STRING_SESSION ke siapa pun.\n")
api_id = int(input("API_KEY/API_ID dari my.telegram.org: ").strip())
api_hash = input("API_HASH dari my.telegram.org: ").strip()

with TelegramClient(StringSession(), api_id, api_hash) as client:
    session = client.session.save()
    print("\nSTRING_SESSION kamu:\n")
    print(session)
    print("\nCopy string panjang di atas ke config.env pada bagian STRING_SESSION=." )
PY
