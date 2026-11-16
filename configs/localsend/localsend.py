#!/usr/bin/env python3

"""Set the public host name (alias) of the LocalSend application.
Usage:
  python localsend.py <preferences_file> <host_name>
"""

import argparse
import json
import os
import shutil
import sys
import tempfile

ALIAS_KEY = "flutter.ls_alias"


def parse_args():
    parser = argparse.ArgumentParser(
        description="Configure the public host name (alias) used by LocalSend."
    )
    parser.add_argument("preferences_file",
                        help="path to LocalSend's shared_preferences.json")
    parser.add_argument("host_name",
                        help="new public host name to advertise")
    parser.add_argument("--no-backup", action="store_true",
                        help="do not create a .bak copy of the original file")
    return parser.parse_args()


def main():
    args = parse_args()
    path = os.path.expanduser(args.preferences_file)
    host_name = args.host_name.strip()

    if not host_name:
        sys.exit("Error: the host name cannot be empty.")

    if not os.path.isfile(path):
        sys.exit(f"Error: preferences file not found: {path}")

    try:
        with open(path, "r", encoding="utf-8") as f:
            prefs = json.load(f)
    except json.JSONDecodeError as exc:
        sys.exit(f"Error: {path} is not valid JSON ({exc}).")

    if not isinstance(prefs, dict):
        sys.exit("Error: unexpected preferences format (expected a JSON object).")

    prefs[ALIAS_KEY] = host_name

    # Write atomically so a crash can't leave a half-written file.
    directory = os.path.dirname(os.path.abspath(path))
    fd, tmp_path = tempfile.mkstemp(dir=directory, suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            json.dump(prefs, f, ensure_ascii=False)
        shutil.copymode(path, tmp_path)
        os.replace(tmp_path, path)
    except Exception:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)
        raise

if __name__ == "__main__":
    main()
