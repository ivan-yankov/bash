#!/usr/bin/env python3
"""Run the bash command test suite inside a container.

The suite is plain bash and runs fine on the host, but the host has the
developer's own ~/.bash, their installed tools and their sudo policy. Running
in a container is what makes a green suite mean something.

Usage:
    ci/run-tests.py                     # default image
    ci/run-tests.py --matrix            # every image in IMAGES
    ci/run-tests.py --image debian:12
    ci/run-tests.py --shell             # interactive shell in the container
    ci/run-tests.py archive             # pass a filter through to the runner
"""

import argparse
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Distributions worth checking. Ubuntu is the development target; Debian
# catches packaging differences without dragging in busybox's non-GNU tools.
IMAGES = ["ubuntu:24.04", "debian:12"]

DEFAULT_IMAGE = IMAGES[0]


def tag_for(base_image: str) -> str:
    return "bash-cmds-test:" + base_image.replace(":", "-").replace("/", "-")


def run(cmd: list[str], **kwargs) -> int:
    print("\033[2m$ " + " ".join(cmd) + "\033[0m", flush=True)
    return subprocess.call(cmd, **kwargs)


def build(base_image: str, quiet: bool) -> bool:
    cmd = [
        "docker", "build",
        "--build-arg", f"BASE_IMAGE={base_image}",
        "-f", str(REPO_ROOT / "ci" / "Dockerfile"),
        "-t", tag_for(base_image),
        str(REPO_ROOT),
    ]
    if quiet:
        cmd.insert(2, "--quiet")
    return run(cmd) == 0


def test(base_image: str, filter_arg: str | None, interactive: bool) -> bool:
    # The repo is mounted read-only: a command that writes into the source tree
    # during a test is a bug the suite should surface, not tolerate.
    cmd = [
        "docker", "run", "--rm",
        "-v", f"{REPO_ROOT}:/repo:ro",
        "--tmpfs", "/tmp:exec,mode=1777",
    ]
    if interactive and sys.stdin.isatty():
        cmd += ["-it"]
    cmd += [tag_for(base_image)]
    if interactive:
        cmd += ["bash"]
    else:
        cmd += ["./test/runner.sh"]
        if filter_arg:
            cmd += [filter_arg]
    return run(cmd) == 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("filter", nargs="?", help="only run matching test files or functions")
    parser.add_argument("--image", default=DEFAULT_IMAGE, help="base image to test against")
    parser.add_argument("--matrix", action="store_true", help="test against every image")
    parser.add_argument("--shell", action="store_true", help="open a shell in the container")
    parser.add_argument("--no-build", action="store_true", help="reuse the existing image")
    parser.add_argument("--verbose-build", action="store_true", help="show full build output")
    args = parser.parse_args()

    images = IMAGES if args.matrix else [args.image]

    results: dict[str, bool] = {}
    for image in images:
        print(f"\n\033[36m=== {image} ===\033[0m", flush=True)
        if not args.no_build:
            if not build(image, quiet=not args.verbose_build):
                print(f"\033[31mbuild failed for {image}\033[0m", file=sys.stderr)
                results[image] = False
                continue
        results[image] = test(image, args.filter, args.shell)

    if args.shell:
        return 0 if all(results.values()) else 1

    print("\n\033[36m=== summary ===\033[0m")
    for image, ok in results.items():
        status = "\033[32mPASS\033[0m" if ok else "\033[31mFAIL\033[0m"
        print(f"  {status}  {image}")

    return 0 if all(results.values()) else 1


if __name__ == "__main__":
    sys.exit(main())
