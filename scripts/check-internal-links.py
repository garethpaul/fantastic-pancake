#!/usr/bin/env python3

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit


LINK_PATTERN = re.compile(
    r"!?\[[^\]]*\]\(\s*(?P<destination><[^>]+>|[^\s)]+)"
)


def is_within_root(path: Path, root: Path) -> bool:
    try:
        path.relative_to(root)
    except ValueError:
        return False
    return True


def markdown_files(root: Path):
    for path in sorted(root.rglob("*.md")):
        if ".git" not in path.parts:
            yield path


def validate_repository(root: Path) -> list[str]:
    root = root.resolve()
    failures: list[str] = []

    for source in markdown_files(root):
        in_fence = False
        for line_number, line in enumerate(source.read_text(encoding="utf-8").splitlines(), 1):
            stripped = line.lstrip()
            if stripped.startswith("```") or stripped.startswith("~~~"):
                in_fence = not in_fence
                continue
            if in_fence:
                continue

            for match in LINK_PATTERN.finditer(line):
                destination = match.group("destination").strip("<>")
                if destination.startswith("#") or destination.startswith("//"):
                    continue

                parsed = urlsplit(destination)
                if parsed.scheme or parsed.netloc:
                    continue
                if not parsed.path or parsed.path.startswith("/"):
                    continue

                target = (source.parent / unquote(parsed.path)).resolve()
                location = f"{source.relative_to(root)}:{line_number}"
                if not is_within_root(target, root):
                    failures.append(
                        f"{location}: local link escapes repository: {destination}"
                    )
                elif not target.exists():
                    failures.append(
                        f"{location}: local link target does not exist: {destination}"
                    )

    return failures


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: check-internal-links.py <repository-root>", file=sys.stderr)
        return 2

    failures = validate_repository(Path(sys.argv[1]))
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1

    print("Offline internal Markdown link checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
