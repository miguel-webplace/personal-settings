import sys, json

path, name = sys.argv[1], sys.argv[2]

try:
    with open(path) as f:
        data = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    data = {}

data["flutter.ls_alias"] = name
with open(path, "w") as f:
    json.dump(data, f, indent=4)
