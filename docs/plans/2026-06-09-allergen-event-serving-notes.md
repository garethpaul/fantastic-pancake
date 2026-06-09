# Allergen Event Serving Notes

date: 2026-06-09
status: completed

## Context

`pancakes.md` already mentions pancake bars and common allergen labels, but the
baseline only protected the general food-safety leftovers source. Event-serving
content should keep allergen guidance source-backed and specific because vague
claims can be unsafe for readers planning a group breakfast.

## Completed Scope

- Added an allergen and event-serving section to `pancakes.md`.
- Linked the allergen note to FoodSafety.gov's FASTER Act summary, including
  sesame in the major-allergen source boundary.
- Added practical serving guidance for labels, separate utensils, and avoiding
  unsupported allergen-free claims.
- Extended `scripts/check-baseline.sh` so the source link, heading, key
  allergen terms, and completed plan are required.
- Updated README, SECURITY, VISION, and CHANGES to describe the new guardrail.

## Verification

- `make check`
- `git diff --check`
