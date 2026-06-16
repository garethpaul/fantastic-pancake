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

    def test_rejects_missing_local_target(self):
        failures = self.validate({"README.md": "![Overview](docs/missing.svg)\n"})
        self.assertEqual(len(failures), 1)
        self.assertIn("local link target does not exist", failures[0])

    def test_rejects_repository_escape(self):
        failures = self.validate({"README.md": "[Outside](../outside.md)\n"})
        self.assertEqual(len(failures), 1)
        self.assertIn("local link escapes repository", failures[0])

    def test_ignores_links_inside_fenced_examples(self):
        failures = self.validate(
            {"README.md": "```markdown\n[Example](missing.md)\n```\n"}
        )
        self.assertEqual(failures, [])

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


if __name__ == "__main__":
    unittest.main()
