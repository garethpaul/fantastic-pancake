# Python Verification Preflight

## Status: Completed

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

## Work Completed

- Added a Make-level `PYTHON` command with a `python3` default and quoted
  propagation into the content checker.
- Added missing-command and major-version preflights before any embedded Python
  validation, with actionable diagnostics for each failure mode.
- Routed all seven embedded Python checks through the preflighted interpreter.
- Documented the GNU Make, POSIX shell, and Python 3 prerequisites and the
  explicit compatible Python command override.
- Added mutation-sensitive baseline contracts for command propagation,
  executable preflight behavior, embedded-call ownership, documentation, and
  this completed evidence record.

## Verification Completed

- POSIX shell syntax validation passed.
- All four Make aliases passed from the repository root with Python 3.12.8.
- `make check` passed from the repository root and external working directory.
- The explicit compatible Python command override passed using the resolved
  Python 3 executable path.
- The missing-command and non-Python-3 preflights failed early with their
  intended actionable diagnostics.
- Nine isolated hostile mutations were rejected for the Make default,
  propagation, command lookup, major-version comparison, embedded-call
  routing, diagnostic, prerequisite guidance, plan status, and override
  evidence contracts.
- Exact diff, generated-artifact, credential-like value, dependency drift,
  conflict-marker, file-mode, and whitespace audits passed.
- No recipe execution, food-service environment, browser, external source
  refresh, or network-dependent validation was performed or claimed.
