---
title: Pancake Portioning And Batch Size
date: 2026-06-09
status: completed
execution: content
---

## Context

The pancake notes had a basic ratio and batch storage guidance, but they did
not explain how to portion batter consistently or prepare repeat batches for a
larger breakfast.

## Goals

- Add practical scoop sizes for medium, silver-dollar, and larger pancakes.
- Keep spacing and doneness guidance tied to the existing griddle notes.
- Add a simple dry-mix prep cue for larger breakfasts without adding tooling.
- Preserve the content-only repository boundary.

## Implementation

- Added `## Portioning and Batch Size` to `pancakes.md`.
- Documented 1/4 cup, 2 tablespoon, and 1/3 cup portion sizes.
- Added spacing, consistent scoop, and dry-ingredient premeasure notes.
- Extended README, VISION, CHANGES, and `scripts/check-baseline.sh`.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
