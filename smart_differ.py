#!/usr/bin/python3

import os
import re
import sys


def prefjs_parser(prefsjs: str) -> dict[str, str]:
    prefs = {}
    for line in prefsjs.splitlines():
        m = re.match(r"""^pref\("(?P<pref>.*?)", "?(?P<value>.*?)"?\);$""", line)
        prefs[m.group("pref")] = m.group("value")
    return prefs


def main(argv: list[str]) -> int:
    old_version = argv[0]
    new_version = argv[1]

    with open(f"all-prefs-{old_version}.js") as file:
        old_prefs = prefjs_parser(file.read())
    with open(f"all-prefs-{new_version}.js") as file:
        new_prefs = prefjs_parser(file.read())

    added = new_prefs.keys() - old_prefs.keys()
    removed = old_prefs.keys() - new_prefs.keys()
    changed = set()
    for pref in new_prefs.keys() & old_prefs.keys():
        if new_prefs[pref] != old_prefs[pref]:
            changed.add(pref)

    print(f"# {new_version}")
    print("")
    print(f"{len(added) + len(removed) + len(changed)} diffs ({len(added)} new, {len(removed)} gone, {len(changed)} different)")
    print("")
    print(f"### new in {new_version}:")
    print("")
    print("```js")
    for pref in sorted(added):
        value = new_prefs[pref]
        if re.match(r"""^(true|false|-?[0-9]+)$""", value):
            print(f"""pref("{pref}", {value});""")
        else:
            print(f"""pref("{pref}", "{value}");""")
    print("```")
    print("")
    print(f"### removed, renamed or hidden in {new_version}:")
    print("")
    print("```js")
    for pref in sorted(removed):
        value = old_prefs[pref]
        if re.match(r"""^(true|false|-?[0-9]+)$""", value):
            print(f"""pref("{pref}", {value});""")
        else:
            print(f"""pref("{pref}", "{value}");""")
    print("```")
    print("")
    print(f"### changed in {new_version}:")
    print("")
    print("```js")
    for pref in sorted(changed):
        value = new_prefs[pref]
        old_value = old_prefs[pref]
        if re.match(r"""^(true|false|-?[0-9]+)$""", value):
            print(f"""pref("{pref}", {value}); // {old_value}""")
        else:
            print(f"""pref("{pref}", "{value}"); // {old_value}""")
    print("```")
    print("")
    print("---")
    print("")
    print("### ignore")
    print("")
    print("<details><summary>click me for details</summary><p>")
    print("")
    print("==NEW")
    print("```js")
    print("````")
    print("")
    print("==REMOVED, RENAMED or HIDDEN")
    print("```js")
    print("````")
    print("")
    print("==CHANGED")
    print("```js")
    print("````")
    print("")
    print("</p></details>")

    return os.EX_OK


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
