# Python Verification Preflight

## Status: In Progress

## Context

The content baseline embeds Python checks for source provenance and batch-table
structure, but the documented prerequisites list only Git. The checker invokes
`python3` directly, so a workstation without that command receives a generic
shell failure and cannot select another compatible Python 3 interpreter.

## Prioritized Engineering Tasks

1. Make the baseline's Python 3 dependency explicit, configurable, and
   fail-fast with an actionable diagnostic.
2. Refresh `docs/readme-overview.svg`, whose generated labels predate the
   maintained Make and hosted verification surfaces.
3. Evaluate an offline link-integrity contract for maintained internal links
   without turning external network availability into a content-gate failure.

This plan implements item 1 because it affects every verification run and can
be proven entirely from repository-local behavior.

## Objectives

- Define one Make-level Python command with a `python3` default.
- Pass the selected command into the baseline checker without weakening root
  path protection.
- Fail before embedded Python checks when the command is absent or is not
  Python 3.
- Document GNU Make, a POSIX shell, and Python 3 as baseline prerequisites,
  including the supported command override.
- Add static and behavioral contracts that reject missing preflight logic,
  ignored overrides, and incomplete completion evidence.

## Scope

- Update `Makefile`, `scripts/check-baseline.sh`, `README.md`, `AGENTS.md`,
  `VISION.md`, and `CHANGES.md`.
- Extend the maintained baseline and this plan's completion evidence.
- Do not change `pancakes.md`, food-safety guidance, sources, dependencies,
  hosted permissions, or repository publishing posture.

## Verification

- Run POSIX shell syntax validation.
- Run all four Make aliases from the repository root with the default Python.
- Run `make check` from an external directory using the absolute Makefile path.
- Run the gate through an explicit compatible Python command override.
- Prove missing and non-Python-3 commands fail with the intended diagnostic.
- Reject isolated mutations covering command propagation, preflight behavior,
  documentation, and completed-plan evidence.
- Audit exact paths, generated artifacts, credential-like values, dependency
  drift, conflict markers, file modes, and whitespace.

## Runtime Boundary

Verification is offline and content-only. No recipe execution, food-service
environment, browser, external source refresh, or network-dependent validation
is performed or claimed.
