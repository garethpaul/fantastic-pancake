---
title: Make Root Override Protection
type: reliability
date: 2026-06-14
status: in_progress
execution: code
---

# Make Root Override Protection

## Summary

Keep repository verification anchored to the loaded Makefile even when a caller
supplies a hostile `ROOT` command-line variable.

## Requirements

- R1. Prevent command-line variables from overriding the repository-derived
  Make root.
- R2. Preserve repository-root and external-working-directory verification.
- R3. Add a static contract that rejects an overrideable root assignment.
- R4. Verify the full gate with a hostile `ROOT` value.
- R5. Preserve all existing content, source, safety, workflow, and no-scaffold
  contracts.

## Verification Plan

- Run POSIX shell syntax checks for `scripts/check-baseline.sh`.
- Run `make check`, `make lint`, `make test`, and `make build` at repository
  root.
- Run the full gate from `/tmp` through the absolute Makefile path.
- Run `make ROOT=/tmp check` and confirm the repository checker still runs.
- Reject isolated mutations that restore an overrideable root, remove the
  hostile-override verification record, reopen the plan, or omit the plan from
  the required-file contract.
- Run `git diff --check`, intended-path review, artifact inspection, and a
  changed-line secret scan.

## Verification Completed

Pending implementation and validation.

## Follow-Ups

- Keep future Make targets anchored to the protected repository root.
