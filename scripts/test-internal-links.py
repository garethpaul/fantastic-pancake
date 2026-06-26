#!/usr/bin/env python3

from __future__ import annotations

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


CHECKER_PATH = Path(__file__).with_name("check-internal-links.py")
sys.dont_write_bytecode = True
SPEC = importlib.util.spec_from_file_location("check_internal_links", CHECKER_PATH)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("Unable to load internal-link checker")
CHECKER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CHECKER)


class InternalLinkChecks(unittest.TestCase):
    def validate(self, files: dict[str, str]) -> list[str]:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for relative_path, content in files.items():
                path = root / relative_path
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(content, encoding="utf-8")
            return CHECKER.validate_repository(root)

    def test_accepts_existing_targets_and_skips_external_destinations(self):
        failures = self.validate(
            {
                "README.md": (
                    "# Section\n"
                    "[Guide](docs/guide.md?view=1#intro)\n"
                    "![Overview](docs/overview.svg)\n"
                    "[Section](#section)\n"
                    "[Source](https://example.com/guide)\n"
                    "[Email](mailto:maintainer@example.com)\n"
                    "[Inline data](data:text/plain,example)\n"
                ),
                "docs/guide.md": "# Intro\n",
                "docs/overview.svg": "<svg/>\n",
            }
        )
        self.assertEqual(failures, [])

    def test_generates_unique_github_style_heading_anchors(self):
        anchors = CHECKER.markdown_anchors(
            "## Repeat\n"
            "## Repeat\n"
            "## Repeat-1\n"
            "## *Helpful* [Link](https://example.com) `Code`!\n"
            "Setext Section\n"
            "--------------\n"
            "```markdown\n"
            "# Hidden\n"
            "```\n"
            "<a name='serving-note'></a>\n"
        )
        self.assertEqual(
            anchors,
            {
                "repeat",
                "repeat-1",
                "repeat-1-1",
                "helpful-link-code",
                "setext-section",
                "serving-note",
            },
        )

    def test_matches_github_slugger_for_literal_underscores_and_symbols(self):
        anchors = CHECKER.markdown_anchors(
            "## ingredient_name\n"
            "## _Emphasized_ heading\n"
            "## A©B\n"
            "## A©B\n"
        )
        self.assertEqual(
            anchors,
            {
                "ingredient_name",
                "emphasized-heading",
                "ab",
                "ab-1",
            },
        )

    def test_accepts_generated_and_custom_markdown_anchors(self):
        failures = self.validate(
            {
                "README.md": (
                    "# Local Section\n"
                    "[Local](#local-section)\n"
                    "[Formatted](docs/guide.md#helpful-link-code)\n"
                    "[Setext](docs/guide.md#setext-section)\n"
                    "[Duplicate](docs/guide.md#repeat-1)\n"
                    "[Collision](docs/guide.md#repeat-1-1)\n"
                    "[Custom](docs/guide.md#serving-note)\n"
                    "[Encoded](docs/guide.md#caf%C3%A9-notes)\n"
                ),
                "docs/guide.md": (
                    "## *Helpful* [Link](https://example.com) `Code`!\n"
                    "\n"
                    "Setext Section\n"
                    "--------------\n"
                    "\n"
                    "## Repeat\n"
                    "## Repeat\n"
                    "## Repeat-1\n"
                    "<a name=\"serving-note\"></a>\n"
                    "## Café Notes\n"
                ),
            }
        )
        self.assertEqual(failures, [])

    def test_rejects_missing_same_and_cross_document_anchors(self):
        failures = self.validate(
            {
                "README.md": (
                    "# Existing\n"
                    "[Missing local](#missing)\n"
                    "[Missing remote](docs/guide.md#missing)\n"
                ),
                "docs/guide.md": "# Existing\n",
            }
        )
        self.assertEqual(len(failures), 2)
        self.assertTrue(
            all("local Markdown anchor does not exist" in failure for failure in failures)
        )

    def test_ignores_heading_syntax_inside_fenced_examples(self):
        failures = self.validate(
            {
                "README.md": "[Hidden](docs/guide.md#hidden)\n",
                "docs/guide.md": "```markdown\n# Hidden\n```\n",
            }
        )
        self.assertEqual(len(failures), 1)
        self.assertIn("local Markdown anchor does not exist", failures[0])

    def test_ignores_links_and_anchors_inside_html_comments(self):
        failures = self.validate(
            {
                "README.md": (
                    "<!-- [Ignored](docs/missing.md) -->\n"
                    "[Hidden](docs/guide.md#hidden)\n"
                    "[Comment anchor](docs/guide.md#comment-anchor)\n"
                ),
                "docs/guide.md": (
                    "<!--\n"
                    "# Hidden\n"
                    "<a name='comment-anchor'></a>\n"
                    "-->\n"
                ),
            }
        )
        self.assertEqual(len(failures), 2)
        self.assertTrue(
            all("local Markdown anchor does not exist" in failure for failure in failures)
        )

    def test_visible_markdown_text_excludes_comments_fences_and_inline_code(self):
        visible = CHECKER.visible_markdown_text(
            "Visible source: https://www.fda.gov/food\n"
            "<!-- hidden source: https://example.com/comment -->\n"
            "```markdown\nhttps://example.com/fence\n```\n"
            "Example only: `https://example.com/code`\n"
        )
        self.assertIn("https://www.fda.gov/food", visible)
        self.assertNotIn("https://example.com/comment", visible)
        self.assertNotIn("https://example.com/fence", visible)
        self.assertNotIn("https://example.com/code", visible)

    def test_inline_comment_marker_does_not_hide_following_heading(self):
        failures = self.validate(
            {
                "README.md": (
                    "Use `<!--` when documenting a comment opener.\n"
                    "# Visible Section\n"
                    "[Visible](#visible-section)\n"
                ),
                "docs/index.md": "[Visible](../README.md#visible-section)\n",
            }
        )
        self.assertEqual(failures, [])

    def test_ignores_custom_anchor_syntax_inside_inline_code(self):
        failures = self.validate(
            {
                "README.md": "[Example](docs/guide.md#example-anchor)\n",
                "docs/guide.md": (
                    "Use `<a name='example-anchor'></a>` as sample syntax.\n"
                ),
            }
        )
        self.assertEqual(len(failures), 1)
        self.assertIn("local Markdown anchor does not exist", failures[0])

    def test_skips_fragments_for_non_markdown_targets(self):
        failures = self.validate(
            {
                "README.md": "![Overview](docs/overview.svg#diagram)\n",
                "docs/overview.svg": "<svg/>\n",
            }
        )
        self.assertEqual(failures, [])

    def test_rejects_missing_local_target(self):
        failures = self.validate(
            {"README.md": "[Guide](docs/missing.md#section)\n"}
        )
        self.assertEqual(len(failures), 1)
        self.assertIn("local link target does not exist", failures[0])
        self.assertNotIn("Markdown anchor", failures[0])

    def test_rejects_repository_escape(self):
        failures = self.validate({"README.md": "[Outside](../outside.md#section)\n"})
        self.assertEqual(len(failures), 1)
        self.assertIn("local link escapes repository", failures[0])
        self.assertNotIn("Markdown anchor", failures[0])

    def test_ignores_links_inside_fenced_examples(self):
        failures = self.validate(
            {"README.md": "```markdown\n[Example](missing.md)\n```\n"}
        )
        self.assertEqual(failures, [])

    def test_mismatched_fence_marker_does_not_close_example(self):
        failures = self.validate(
            {
                "README.md": (
                    "```markdown\n"
                    "~~~\n"
                    "[Example](missing.md)\n"
                    "```\n"
                )
            }
        )
        self.assertEqual(failures, [])

    def test_shorter_matching_fence_does_not_close_example(self):
        failures = self.validate(
            {
                "README.md": (
                    "````markdown\n"
                    "```\n"
                    "[Example](missing.md)\n"
                    "````\n"
                )
            }
        )
        self.assertEqual(failures, [])

    def test_matching_fence_restores_link_scanning_after_mismatch(self):
        failures = self.validate(
            {
                "README.md": (
                    "~~~markdown\n"
                    "```\n"
                    "[Inside example](inside.md)\n"
                    "~~~\n"
                    "[Outside example](outside.md)\n"
                )
            }
        )
        self.assertEqual(len(failures), 1)
        self.assertIn("outside.md", failures[0])

    def test_ignores_link_syntax_inside_inline_code(self):
        failures = self.validate(
            {"README.md": "Use `[Example](missing.md)` as sample syntax.\n"}
        )
        self.assertEqual(failures, [])

    def test_rejects_missing_reference_definition_target(self):
        failures = self.validate(
            {"README.md": "[Guide][guide]\n\n[guide]: docs/missing.md\n"}
        )
        self.assertEqual(len(failures), 1)
        self.assertIn("local link target does not exist", failures[0])

    def test_scans_uppercase_markdown_extensions(self):
        failures = self.validate({"GUIDE.MD": "[Missing](missing.md)\n"})
        self.assertEqual(len(failures), 1)
        self.assertIn("local link target does not exist", failures[0])

    def test_rejects_symlinked_markdown_sources(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            outside = root.parent / f"{root.name}-outside.md"
            outside.write_text("# Outside\n", encoding="utf-8")
            try:
                (root / "README.md").symlink_to(outside)
                failures = CHECKER.validate_repository(root)
            finally:
                outside.unlink(missing_ok=True)

        self.assertEqual(len(failures), 1)
        self.assertIn("Markdown source must be a regular file", failures[0])

    def test_rejects_symlinked_and_non_file_targets(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "README.md").write_text(
                "[Symlink](linked.txt)\n[Directory](docs)\n", encoding="utf-8"
            )
            (root / "actual.txt").write_text("Actual\n", encoding="utf-8")
            (root / "linked.txt").symlink_to("actual.txt")
            (root / "docs").mkdir()
            failures = CHECKER.validate_repository(root)

        self.assertEqual(len(failures), 2)
        self.assertTrue(any("local link target must not be a symlink" in item for item in failures))
        self.assertTrue(any("local link target is not a regular file" in item for item in failures))

    def test_rejects_malformed_or_unsafe_percent_encoding_without_crashing(self):
        failures = self.validate(
            {
                "README.md": (
                    "[Nul](docs/%00.md)\n"
                    "[Malformed](docs/%ZZ.md)\n"
                    "[Invalid UTF-8](docs/%C3%28.md)\n"
                )
            }
        )
        self.assertEqual(len(failures), 3)
        self.assertTrue(all("invalid percent-encoding" in item for item in failures))

    def test_rejects_local_file_urls(self):
        failures = self.validate({"README.md": "[Local file](file:///etc/passwd)\n"})
        self.assertEqual(len(failures), 1)
        self.assertIn("local file URL is not allowed", failures[0])


if __name__ == "__main__":
    unittest.main()
