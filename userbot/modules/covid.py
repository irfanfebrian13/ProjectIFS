# Copyright (C) 2019 The Raphielscape Company LLC.
#
# Licensed under the Raphielscape Public License, Version 1.d (the "License");
# you may not use this file except in compliance with the License.
#
# Port to UserBot by @MoveAngel

from userbot import CMD_HELP
from userbot.events import register


@register(outgoing=True, pattern="^.covid (.*)")
async def corona(event):
    await event.edit("Processing...")
    try:
        from covid import Covid
    except ImportError:
        await event.edit("`covid package is not installed. This legacy command is unavailable in this Termux setup.`")
        return

    country = event.pattern_match.group(1)
    covid = Covid(source="worldometers")
    try:
        country_data = covid.get_status_by_country_name(country)
    except Exception as exc:
        await event.edit(f"`Failed to fetch COVID data: {exc}`")
        return

    if country_data:
        output_text = f"`😕New Cases       : {country_data.get('new_cases')}`\n"
        output_text += f"`😭New Deaths      : {country_data.get('new_deaths')}`\n\n"
        output_text += f"`😔Total Cases     : {country_data.get('confirmed')}`\n"
        output_text += f"`😔Active Cases    : {country_data.get('active')}`\n\n"
        output_text += f"`😭Total Deaths    : {country_data.get('deaths')}`\n"
        output_text += f"`😍Total Recovered : {country_data.get('recovered')}`\n\n"
        output_text += f"`😥Critical cases  : {country_data.get('critical')}`\n"
        output_text += f"`💉Total Tests     : {country_data.get('total_tests')}`\n\n"
        output_text += f"Data provided by [Worldometer](https://www.worldometers.info/coronavirus/country/{country})"
    else:
        output_text = "No information yet about this country!"
    await event.edit(f"**Corona Virus Info in {country}:\n\n{output_text}**")


CMD_HELP.update({
    "covid":
        ".covid <country>"
        "\nUsage: Get an information about data covid-19 in your country.\n"
})
