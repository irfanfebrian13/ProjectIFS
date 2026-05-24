#!/usr/bin/env bash
set -euo pipefail

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

command -v python >/dev/null 2>&1 || fail "Python belum ada. Jalankan bash install-termux.sh dulu."

# The original ProjectIFS generator is the most compatible path on Termux.
# It handles Telethon's interactive prompts better than wrapping them through
# heredoc/stdin, which can trigger EOFError or non-seekable stream errors.
if [ -f string_session.py ]; then
  info "Menjalankan generator bawaan ProjectIFS: python string_session.py"
  python string_session.py
  exit $?
fi

info "string_session.py tidak ditemukan, memakai fallback generator minimal."
python -m pip install --upgrade Telethon pyaes rsa six pyasn1-modules >/dev/null

python - <<'PY'
from telethon.sync import TelegramClient
from telethon.sessions import StringSession

print("ProjectIFS STRING_SESSION generator")
print("Jangan share hasil STRING_SESSION ke siapa pun.\n")
api_id = int(input("API_KEY/API_ID dari my.telegram.org: ").strip())
api_hash = input("API_HASH dari my.telegram.org: ").strip()

with TelegramClient(StringSession(), api_id, api_hash) as client:
    print("\nSTRING_SESSION kamu:\n")
    print(client.session.save())
    print("\nCopy string panjang di atas ke config.env pada bagian STRING_SESSION=.")
PY
