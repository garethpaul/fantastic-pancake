---
title: First Pancake Calibration
type: content
status: completed
date: 2026-06-13
---

# First Pancake Calibration

## Summary

Add a short decision sequence that uses one measured test pancake to calibrate
griddle heat and batter consistency before the rest of a batch is cooked.

## Priority

1. Turn the existing first-pancake advice into an actionable sequence.
2. Keep heat corrections separate from batter-consistency corrections.
3. Preserve the content-only, no-scaffold repository boundary.

## Requirements

- R1. The guide must use the existing 1/4 cup medium-pancake portion.
- R2. It must tell the cook to evaluate browning before changing batter.
- R3. It must map premature browning to lower heat and pale cooking to higher
  heat.
- R4. It must map excessive spread to a tablespoon of flour and a persistent
  mound to a tablespoon of milk, with a short wait before reassessment.
- R5. It must require a second test pancake after any adjustment instead of
  changing multiple variables during the main batch.
- R6. The static gate must preserve the heading, correction cues, ordering, and
  completed verification evidence.

## Non-Goals

- Changing the base recipe, yield, batch scaling, or portion sizes.
- Adding time or temperature claims beyond the existing guidance.
- Adding application, dependency, publishing, or generated-site scaffolding.
- Replacing the broader troubleshooting section.

## Implementation Units

### 1. Calibration Content

Files: `pancakes.md`

- Add a concise first-pancake decision sequence after the griddle guidance.
- Keep each correction observable and limited to one variable at a time.

### 2. Baseline Contract

Files: `scripts/check-baseline.sh`

- Require the new heading and exact adjustment cues.
- Verify that browning evaluation precedes consistency correction and that a
  second test follows any adjustment.

### 3. Repository Guidance

Files: `README.md`, `VISION.md`, `CHANGES.md`

- Record the new practical content and completed validation.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the heat correction, remove the consistency correction, and reorder
  the second-test instruction; the static gate must reject each mutation.
- Run shell syntax, `git diff --check`, and intended-file secret scans.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.

## Work Completed

- Added a seven-step first-pancake calibration sequence after the griddle heat
  guidance.
- Kept heat diagnosis ahead of measured flour or milk corrections and required
  a second test before the main batch.
- Extended the content baseline with wrap-stable cue checks, section-scoped
  ordering validation, documentation contracts, and completed-plan evidence.
- Updated README, VISION, and change history for the new method guidance.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed against the
  final implementation.
- `sh -n scripts/check-baseline.sh`, `git diff --check`, the explicit
  no-scaffold check, and the intended-file secret scan passed.
- The heat correction mutation failed with `pancakes.md must keep the ordered
  first-pancake calibration sequence.`
- The consistency correction mutation failed with `First-pancake calibration
  must preserve its fail-clear decision order.`
- The second-test ordering mutation failed with `First-pancake calibration must
  preserve its fail-clear decision order.`
- The hosted pull-request check is not available before push; one bounded
  exact-head snapshot will be recorded in the engineering tracker without
  polling.
