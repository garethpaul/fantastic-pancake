#!/usr/bin/env python3

from __future__ import annotations

import html
import re
import sys
import unicodedata
from pathlib import Path
from urllib.parse import unquote, urlsplit


LINK_PATTERN = re.compile(
    r"!?\[[^\]]*\]\(\s*(?P<destination><[^>]+>|[^\s)]+)"
)
REFERENCE_PATTERN = re.compile(
    r"^\s{0,3}\[[^\]]+\]:\s*(?P<destination><[^>]+>|\S+)"
)
ATX_HEADING_PATTERN = re.compile(r"^\s{0,3}#{1,6}(?:[ \t]+|$)(?P<text>.*)$")
SETEXT_HEADING_PATTERN = re.compile(r"^\s{0,3}(?:=+|-+)[ \t]*$")
CUSTOM_ANCHOR_PATTERN = re.compile(
    r"<a\s+[^>]*\bname\s*=\s*(?:\"(?P<double>[^\"]+)\"|'(?P<single>[^']+)')[^>]*>",
    re.IGNORECASE,
)
INLINE_LINK_PATTERN = re.compile(r"!?\[([^\]]*)\]\([^)]*\)")
REFERENCE_LINK_PATTERN = re.compile(r"!?\[([^\]]*)\]\[[^\]]*\]")
CODE_SPAN_PATTERN = re.compile(r"(`+)(.*?)\1")
HTML_TAG_PATTERN = re.compile(r"<[^>]+>")


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


def visible_markdown_lines(content: str):
    in_fence = False
    in_comment = False
    for line_number, line in enumerate(content.splitlines(), 1):
        if not in_fence:
            visible_parts = []
            position = 0
            comment_search = without_code_spans(line)
            while position < len(line):
                if in_comment:
                    comment_end = line.find("-->", position)
                    if comment_end < 0:
                        position = len(line)
                        continue
                    in_comment = False
                    position = comment_end + 3
                    continue

                comment_start = comment_search.find("<!--", position)
                if comment_start < 0:
                    visible_parts.append(line[position:])
                    break
                visible_parts.append(line[position:comment_start])
                in_comment = True
                position = comment_start + 4
            line = "".join(visible_parts)

        stripped = line.lstrip()
        if stripped.startswith("```") or stripped.startswith("~~~"):
            in_fence = not in_fence
            continue
        if not in_fence:
            yield line_number, line


def without_code_spans(line: str) -> str:
    visible = list(line)
    position = 0
    while True:
        start = line.find("`", position)
        if start < 0:
            break

        marker_end = start
        while marker_end < len(line) and line[marker_end] == "`":
            marker_end += 1
        marker = line[start:marker_end]
        end = line.find(marker, marker_end)
        if end < 0:
            break

        visible[start : end + len(marker)] = " " * (end + len(marker) - start)
        position = end + len(marker)

    return "".join(visible)


def destinations(line: str):
    visible = without_code_spans(line)
    for match in LINK_PATTERN.finditer(visible):
        yield match.group("destination")

    reference = REFERENCE_PATTERN.match(visible)
    if reference:
        yield reference.group("destination")


def plain_heading_text(text: str) -> str:
    text = re.sub(r"[ \t]+#+[ \t]*$", "", text)
    text = CODE_SPAN_PATTERN.sub(lambda match: match.group(2), text)
    text = INLINE_LINK_PATTERN.sub(lambda match: match.group(1), text)
    text = REFERENCE_LINK_PATTERN.sub(lambda match: match.group(1), text)
    text = HTML_TAG_PATTERN.sub("", text)
    text = html.unescape(text)
    text = re.sub(r"\\(.)", r"\1", text)
    return text.replace("*", "").replace("_", "").replace("~", "")


def github_heading_slug(text: str) -> str:
    slug = []
    for character in plain_heading_text(text).strip().lower():
        if character == " ":
            slug.append("-")
        elif character.isspace():
            continue
        elif unicodedata.category(character).startswith("P") and character != "-":
            continue
        else:
            slug.append(character)
    return "".join(slug)


def markdown_anchors(content: str) -> set[str]:
    anchors: set[str] = set()
    generated: set[str] = set()
    previous_heading_candidate: str | None = None

    def add_heading(text: str) -> None:
        base = github_heading_slug(text)
        if not base:
            return

        candidate = base
        suffix = 0
        while candidate in generated:
            suffix += 1
            candidate = f"{base}-{suffix}"
        generated.add(candidate)
        anchors.add(candidate)

    for _, line in visible_markdown_lines(content):
        for match in CUSTOM_ANCHOR_PATTERN.finditer(without_code_spans(line)):
            anchors.add(match.group("double") or match.group("single"))

        atx_heading = ATX_HEADING_PATTERN.match(line)
        if atx_heading:
            add_heading(atx_heading.group("text"))
            previous_heading_candidate = None
            continue

        if SETEXT_HEADING_PATTERN.match(line) and previous_heading_candidate is not None:
            add_heading(previous_heading_candidate)
            previous_heading_candidate = None
            continue

        previous_heading_candidate = line if line.strip() else None

    return anchors


def validate_repository(root: Path) -> list[str]:
    root = root.resolve()
    failures: list[str] = []
    anchor_cache: dict[Path, set[str]] = {}

    def anchors_for(path: Path) -> set[str]:
        if path not in anchor_cache:
            anchor_cache[path] = markdown_anchors(path.read_text(encoding="utf-8"))
        return anchor_cache[path]

    for source in markdown_files(root):
        content = source.read_text(encoding="utf-8")
        for line_number, line in visible_markdown_lines(content):
            for raw_destination in destinations(line):
                destination = raw_destination.strip("<>")
                if destination.startswith("//"):
                    continue

                parsed = urlsplit(destination)
                if parsed.scheme or parsed.netloc:
                    continue
                if parsed.path.startswith("/"):
                    continue

                target = (
                    source
                    if not parsed.path
                    else (source.parent / unquote(parsed.path)).resolve()
                )
                location = f"{source.relative_to(root)}:{line_number}"
                if not is_within_root(target, root):
                    failures.append(
                        f"{location}: local link escapes repository: {destination}"
                    )
                elif not target.exists():
                    failures.append(
                        f"{location}: local link target does not exist: {destination}"
                    )
                elif parsed.fragment and target.suffix.lower() == ".md":
                    fragment = unquote(parsed.fragment)
                    if fragment not in anchors_for(target):
                        failures.append(
                            f"{location}: local Markdown anchor does not exist: {destination}"
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
