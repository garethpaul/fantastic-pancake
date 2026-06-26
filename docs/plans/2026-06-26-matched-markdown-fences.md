# Matched Markdown Fence Closers

Status: Completed

## Context

The offline link checker toggled fenced-example visibility whenever a line
started with at least three backticks or tildes. A tilde fence could therefore
close a backtick block, and three backticks could close a four-backtick block.
That could produce false broken-link findings inside examples or hide real links
after the intended closer.

## Design

- Record the opening marker character and run length.
- Ignore all content until a closing run uses the same marker, is at least as
  long as the opener, and contains no trailing non-whitespace text.
- Preserve CommonMark's allowance for a longer matching closer.
- Keep existing comment, inline-code, heading, custom-anchor, percent-decoding,
  filesystem, and repository-boundary behavior unchanged.

## Test First

Temporary-tree regressions proved that mismatched markers and shorter matching
markers incorrectly exposed example links before implementation. A third case
proves the real matching closer restores scanning for a broken link afterward.

## Verification

- Run `python3 scripts/test-internal-links.py`.
- Run `python3 scripts/check-internal-links.py .`.
- Run canonical `make check` under `C` and `C.UTF-8` and from `/tmp`.
- Reject mutations that restore blind toggling or remove marker/length checks.
- Run Python and shell syntax checks plus `git diff --check`.
- Use hosted content checks and CodeQL as exact-head authority.

## Scope Boundaries

- No recipe, food-safety, allergen, source URL, publication scaffold, dependency,
  or external-network behavior change.
- The checker remains a focused offline validator rather than a full Markdown
  renderer.

## Verification Completed

- The two red-first mismatch regressions failed before implementation; all 24
  internal-link tests and the maintained repository scan then passed.
- Mutations removing marker equality or minimum closing length were rejected.
- `make lint`, `test`, `build`, and `check` passed under `C` and `C.UTF-8` and
  from an external working directory.
- Python compilation, shell syntax, and `git diff --check` passed.
- Hosted exact-head and review evidence will be recorded in the PR.
