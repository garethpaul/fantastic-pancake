---
title: Pancake Batch Scaling Table
date: 2026-06-12
status: completed
execution: content
---

## Context

The guide gives a dependable ratio for about eight medium pancakes and tells
readers to scale wet and dry ingredients together. It does not show the actual
quantities for larger breakfasts, so readers must repeat the arithmetic while
working and can easily scale salt or leavening inconsistently.

## Goals

- Add a compact table for batches of about 8, 16, and 32 medium pancakes.
- Keep every quantity mathematically aligned with the existing basic ratio.
- Recommend preparing the largest service as smaller freshly mixed bowls so
  batter does not wait unnecessarily while pancakes cook.
- Preserve the content-only repository boundary and existing safety guidance.

## Implementation

- Add `## Batch Scaling Table` next to the basic ratio in `pancakes.md`.
- List flour, baking powder, sugar, salt, milk, eggs, and melted butter or oil
  for one, two, and four times the base recipe.
- Clarify that the yield assumes the existing 1/4 cup portion and that actual
  yield varies with adjustment and scoop size.
- Update README, VISION, and CHANGES to record the new content contract.
- Extend `scripts/check-baseline.sh` to require the plan, heading, batch sizes,
  representative scaled quantities, and fresh-bowl guidance.

## Verification

- `sh -n scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
