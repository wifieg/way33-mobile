"""Create screenshot simulators using the runtimes selected by Xcode."""
import json
import os
import subprocess


def simctl(*arguments):
    return subprocess.check_output(["xcrun", "simctl", *arguments], text=True)


runtimes = json.loads(simctl("list", "runtimes", "--json"))["runtimes"]
runtime = next(
    item for item in reversed(runtimes)
    if item.get("isAvailable")
    and "iOS" in item["identifier"]
    and int(item["version"].split(".")[0]) >= 26
)
types = json.loads(simctl("list", "devicetypes", "--json"))["devicetypes"]
phone = next(item for item in types if item["name"] == "iPhone 16 Pro Max")
tablet = next(item for item in types if item["name"].startswith("iPad Pro 13-inch"))
with open(os.environ["GITHUB_ENV"], "a") as environment:
    for key, device in (("WAY33_IPHONE", phone), ("WAY33_IPAD", tablet)):
        identifier = simctl("create", f"Way33 {key}", device["identifier"], runtime["identifier"]).strip()
        environment.write(f"{key}={identifier}\n")
        print(f"{key}: {device['name']} / iOS {runtime['version']}")
