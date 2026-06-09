# No-Scaffold Contract

date: 2026-06-09
status: completed

## Context

Fantastic Pancake is maintained as a content-only repository. The existing
baseline verifies required documents and useful pancake sections, but it does
not fail if an app manifest, dependency lockfile, or source scaffold appears
without a publishing decision.

## Completed Scope

- Added static checks that reject common dependency manifests, lockfiles, source
  directories, and generated dependency directories.
- Kept the allowed surface limited to Markdown content, docs, scripts, and the
  existing `Makefile` check entry point.
- Documented the no-scaffold guardrail in README, VISION, and CHANGES.

## Verification

- `make check`
- `git diff --check`

## Follow-Ups

- If this repository becomes a static site or app, replace this guardrail with a
  plan that names the chosen toolchain and verification command.
