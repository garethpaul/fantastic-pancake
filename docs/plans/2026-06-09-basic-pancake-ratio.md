# Basic Pancake Ratio

date: 2026-06-09
status: completed

## Context

`pancakes.md` had a useful method section and troubleshooting guidance, but it
did not give readers a concrete starting formula. A content-only repo should
remain small, but the core pancake note is more useful when it includes a
simple ratio that can be scaled.

## Completed Scope

- Added a `Basic Pancake Ratio` section to `pancakes.md`.
- Included starting quantities for flour, leavening, sugar, salt, milk, egg,
  and fat.
- Added short adjustment notes for thinner or thicker pancakes and group-scale
  cooking.
- Extended `scripts/check-baseline.sh` so the heading, representative
  quantities, scaling note, and completed plan are required.
- Updated README, VISION, and CHANGES so the content contract matches the
  document.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
