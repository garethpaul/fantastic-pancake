---
title: Location-Independent Content Verification
type: reliability
date: 2026-06-13
status: planned
execution: code
---

# Location-Independent Content Verification

## Summary

Resolve the content checker from the loaded Makefile so the full repository
baseline works when Make is invoked outside the checkout.

## Requirements

- R1. Derive the repository root from `MAKEFILE_LIST`.
- R2. Invoke `scripts/check-baseline.sh` through its repository-rooted path.
- R3. Add a static contract that rejects caller-directory-relative checker
  invocation.
- R4. Preserve all recipe, food-safety, allergen, source-provenance, workflow,
  and no-scaffold contracts.
- R5. Record actual root and external-directory verification before completion.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` at repository
  root.
- Run the full gate from `/tmp` through the absolute Makefile path.
- Reject isolated hostile root-derivation, checker-path, documentation, plan
  status, and verification-evidence mutations.
- Run shell syntax, `git diff --check`, exact-path review, secret scanning, and
  generated-artifact inspection.

## Non-Goals

- Changing recipe content, safety guidance, citations, or publishing scope.
- Adding dependencies, application scaffolding, or network validation.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and verification.
