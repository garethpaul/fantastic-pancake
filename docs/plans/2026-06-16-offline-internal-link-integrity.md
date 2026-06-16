# Offline Internal Link Integrity

## Status: Completed

## Context

The content baseline requires maintained files but does not validate relative
Markdown link and image destinations. A rename or typo can therefore leave the
README overview image or a cross-document reference broken while `make check`
still passes. External source availability must remain outside the offline
gate.

## Objectives

- Validate local Markdown link and image targets across maintained Markdown.
- Reject missing targets and repository-escaping relative paths.
- Skip absolute web, mail, telephone, and same-document fragment links without
  performing network requests.
- Keep verification location-independent and routed through the preflighted
  Python 3 command.
- Add mutation-sensitive checker, guidance, and completed-plan contracts.

## Scope

- Add a dependency-free Python link-target validator under `scripts/`.
- Invoke it from `scripts/check-baseline.sh` and require its static contracts.
- Document the offline link-integrity boundary in `README.md`, `SECURITY.md`,
  `VISION.md`, and `CHANGES.md`.

## Verification

- Python syntax and focused link checker
- Repository-root and external-directory `make check`
- Isolated mutations for a missing image target, repository escape, checker
  invocation, external-link skipping, guidance, and completed-plan evidence
- `git diff --check`
- Exact-path, generated-artifact, sensitive-value, conflict-marker, and
  file-mode audits

## Verification Completed

- `python3 scripts/test-internal-links.py` passed four focused temporary-tree
  regressions.
- `python3 scripts/check-internal-links.py .` passed all maintained Markdown
  references without performing a network request.
- Six isolated internal-link mutations were rejected: a missing image target,
  repository escape, removed external-scheme skip, removed checker invocation,
  missing guidance, and reopened plan status each failed the gate.
- `make check` passed from the repository root and external working directory
  with the preflighted Python 3 command.
- No external URL request, browser rendering, recipe execution, or food-safety
  wording change was performed.

## Risks

- Markdown destination parsing must not turn external availability into a
  build dependency.
- URL fragments and query strings must not be treated as filesystem path text.
- No recipe execution, browser rendering, or external URL request will be
  performed.
- This PR is stacked on PR #12 and must retain base-first merge ordering.

## Out Of Scope

- External link health, heading-anchor validation, generated SVG refreshes,
  recipe wording, food-safety guidance, and dependency additions.
