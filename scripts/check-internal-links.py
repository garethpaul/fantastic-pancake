#!/usr/bin/env python3

from __future__ import annotations

import html
import os
import re
import sys
import unicodedata
from pathlib import Path
from urllib.parse import unquote_to_bytes, urlsplit


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
EMPHASIS_PATTERN = re.compile(
    r"(?<!\\)(?P<marker>_{1,2}|\*{1,2}|~{2})(?P<text>\S(?:.*?\S)?)(?P=marker)"
)
MALFORMED_PERCENT_PATTERN = re.compile(r"%(?![0-9A-Fa-f]{2})")
GITHUB_REMOVED_SYMBOLS = frozenset({"©", "®", "×", "÷"})


def is_within_root(path: Path, root: Path) -> bool:
    try:
        path.relative_to(root)
    except ValueError:
        return False
    return True


def markdown_files(root: Path):
    for path in sorted(root.rglob("*")):
        if path.suffix.lower() == ".md" and ".git" not in path.parts:
            yield path


def decode_url_component(value: str) -> str:
    if MALFORMED_PERCENT_PATTERN.search(value):
        raise ValueError("malformed percent escape")

    decoded = unquote_to_bytes(value).decode("utf-8", errors="strict")
    if any(character == "\0" or unicodedata.category(character).startswith("C") for character in decoded):
        raise ValueError("control character in decoded value")
    return decoded


def symlink_component(path: Path, root: Path) -> bool:
    cursor = root
    for part in path.relative_to(root).parts:
        cursor /= part
        if cursor.is_symlink():
            return True
    return False


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


def visible_markdown_text(content: str) -> str:
    return "\n".join(
        without_code_spans(line) for _, line in visible_markdown_lines(content)
    )


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
    while True:
        unwrapped = EMPHASIS_PATTERN.sub(lambda match: match.group("text"), text)
        if unwrapped == text:
            break
        text = unwrapped
    text = re.sub(r"\\(.)", r"\1", text)
    return text.replace("*", "").replace("~", "")


def github_heading_slug(text: str) -> str:
    slug = []
    for character in plain_heading_text(text).strip().lower():
        if character == " ":
            slug.append("-")
        elif character.isspace():
            continue
        elif character in GITHUB_REMOVED_SYMBOLS:
            continue
        elif character not in {"-", "_"} and unicodedata.category(character).startswith(("C", "P")):
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
        location = str(source.relative_to(root))
        if source.is_symlink() or not source.is_file():
            failures.append(f"{location}: Markdown source must be a regular file")
            continue

        try:
            content = source.read_text(encoding="utf-8")
        except (OSError, UnicodeError) as error:
            failures.append(f"{location}: unable to read Markdown source: {error}")
            continue

        for line_number, line in visible_markdown_lines(content):
            for raw_destination in destinations(line):
                destination = raw_destination.strip("<>")
                if destination.startswith("//"):
                    continue

                parsed = urlsplit(destination)
                if parsed.scheme.lower() == "file":
                    failures.append(
                        f"{source.relative_to(root)}:{line_number}: local file URL is not allowed: {destination}"
                    )
                    continue
                if parsed.scheme or parsed.netloc:
                    continue
                if parsed.path.startswith("/"):
                    continue

                location = f"{source.relative_to(root)}:{line_number}"
                try:
                    decoded_path = decode_url_component(parsed.path)
                    fragment = decode_url_component(parsed.fragment)
                except (UnicodeError, ValueError):
                    failures.append(
                        f"{location}: invalid percent-encoding in local link: {destination}"
                    )
                    continue

                candidate = source if not decoded_path else source.parent / decoded_path
                lexical_target = Path(os.path.normpath(candidate))
                if not is_within_root(lexical_target, root):
                    failures.append(
                        f"{location}: local link escapes repository: {destination}"
                    )
                elif symlink_component(lexical_target, root):
                    failures.append(
                        f"{location}: local link target must not be a symlink: {destination}"
                    )
                elif not lexical_target.exists():
                    failures.append(
                        f"{location}: local link target does not exist: {destination}"
                    )
                elif not lexical_target.is_file():
                    failures.append(
                        f"{location}: local link target is not a regular file: {destination}"
                    )
                elif fragment and lexical_target.suffix.lower() == ".md":
                    if fragment not in anchors_for(lexical_target):
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
