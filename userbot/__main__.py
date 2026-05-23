# Copyright (C) 2019 The Raphielscape Company LLC.
#
# Licensed under the Raphielscape Public License, Version 1.c (the "License");
# you may not use this file except in compliance with the License.
#
""" Userbot start point """

import os
from importlib import import_module
from sys import argv

from telethon.errors.rpcerrorlist import PhoneNumberInvalidError
from userbot import LOGS, bot
from userbot.modules import ALL_MODULES


INVALID_PH = '\nERROR: The Phone No. entered is INVALID' \
             '\n Tip: Use Country Code along with number.' \
             '\n or check your phone number and try again !'

try:
    bot.start()
except PhoneNumberInvalidError:
    print(INVALID_PH)
    exit(1)

_disabled_modules = {
    module.strip()
    for module in os.environ.get("DISABLED_MODULES", "").split(",")
    if module.strip()
}
loaded_modules = []
failed_modules = {}

for module_name in ALL_MODULES:
    if module_name in _disabled_modules:
        LOGS.info("Skipping disabled module: %s", module_name)
        continue
    try:
        import_module("userbot.modules." + module_name)
        loaded_modules.append(module_name)
    except Exception as exc:  # pragma: no cover - defensive runtime isolation
        failed_modules[module_name] = str(exc)
        LOGS.exception("Failed to load module %s", module_name)

LOGS.info("Loaded %s modules", len(loaded_modules))
if failed_modules:
    LOGS.warning("Failed to load %s modules: %s",
                 len(failed_modules), ", ".join(sorted(failed_modules)))

LOGS.info(
    "You are running ProjectIFS [v3] Userbot Go to Telegram and Type .alive or .on")

if len(argv) not in (1, 3, 4):
    bot.disconnect()
else:
    bot.run_until_disconnected()
