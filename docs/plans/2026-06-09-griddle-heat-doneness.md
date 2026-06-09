---
title: Griddle Heat And Doneness Notes
date: 2026-06-09
status: completed
execution: content
---

## Context

The pancake notes include a basic method, ratio, troubleshooting, allergen, and
storage guidance. The cooking method referenced heat and flipping briefly, but
did not give a compact section on griddle setup or doneness cues.

## Goals

- Add practical griddle preheating and adjustment notes.
- Add visual doneness cues for flipping pancakes.
- Preserve the content-only repository boundary.
- Expose `make lint`, `make test`, and `make build` aliases for the static
  content baseline.

## Implementation

- Added `## Griddle Heat and Doneness` to `pancakes.md`.
- Added concise notes for 350 to 375 degrees F electric griddle starts, light
  greasing, first-pancake adjustment, set edges, and avoiding pressed pancakes.
- Extended README, VISION, CHANGES, and the content baseline script.
- Added Makefile aliases for lint, test, and build gates.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
