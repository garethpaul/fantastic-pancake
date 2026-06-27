# Validate raw HTML link targets offline

Status: Completed

## Problem

The content checker supported raw HTML custom anchors but validated only
Markdown link syntax. Local destinations in `<a href>` and `<img src>` tags
could therefore point to missing, escaping, symlinked, or invalid fragment
targets without failing `make check`.

## Fix

- Parse visible raw HTML with Python's standard-library `HTMLParser`.
- Extract multiline anchor `href` and image `src` attributes with source lines.
- Reuse the existing offline path, percent-decoding, symlink, file, and Markdown
  fragment validation boundary.
- Continue skipping external URLs, fenced examples, comments, and inline code.

## Test First

Multiline raw HTML fixtures for a missing guide and image produced zero
failures before implementation instead of the expected two.

## Verification

- Run the focused and complete internal-link test suite.
- Run `make check` from the checkout and an external working directory.
- Run Python compilation, shell syntax checks, and `git diff --check`.
- Require hosted content and CodeQL checks on the exact PR head.
