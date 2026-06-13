---
title: Pancake Substitution Guidance
type: content
status: completed
date: 2026-06-13
---

# Pancake Substitution Guidance

## Summary

Add concise substitution guidance for the base pancake ratio that explains
which ingredient function may change, requires a small test batch, and keeps
recipe adaptation separate from allergen-safety claims.

## Priority

1. Help cooks adapt the existing recipe without promising identical results.
2. Keep egg, milk, flour, and fat substitutions tied to observable batter and
   pancake behavior.
3. Preserve official label and cross-contact guidance for allergy-sensitive
   preparation.
4. Preserve the content-only, no-scaffold repository boundary.

## Requirements

- R1. The guide must state that substitutions can change flavor, color,
  texture, or volume and recommend testing the 8-pancake ratio before scaling.
- R2. Milk guidance must use an unsweetened replacement and direct cooks to
  reassess batter thickness after the existing rest.
- R3. Egg guidance must explain that eggs contribute moisture, binding, and
  lift and that no single replacement reproduces every function.
- R4. Flour guidance must avoid presenting an arbitrary single gluten-free
  flour as a cup-for-cup replacement and must require a blend intended for
  one-to-one baking use.
- R5. Fat guidance must keep the existing neutral-oil option and identify
  butter-related flavor or browning as a possible difference.
- R6. Allergy guidance must require current label review and cross-contact
  controls and must prohibit treating a substitution alone as proof that a
  batch is allergen-free.
- R7. The content must cite current FDA food-allergy guidance and reviewed
  university extension guidance for egg replacements.
- R8. The static gate must preserve the heading, functional cautions, source
  links, test-batch boundary, allergy boundary, and completed verification
  evidence.

## Non-Goals

- Guaranteeing identical flavor, browning, texture, rise, or yield after a
  substitution.
- Providing individualized medical, allergy-treatment, or dietary advice.
- Replacing tested recipes for highly constrained diets.
- Changing the base recipe, batch scaling table, or event-serving thresholds.
- Adding application, dependency, publishing, or generated-site scaffolding.

## Implementation Units

### 1. Substitution Content

Files: `pancakes.md`

- Add a concise section after the base ratio and before batch scaling.
- Cover milk, egg, flour, and fat without presenting the options as equivalent.
- Require a small test batch before group-scale preparation.

### 2. Source And Safety Boundary

Files: `pancakes.md`

- Cite FDA food-allergy label and cross-contact guidance.
- Cite University of Minnesota Extension guidance on the different functions
  eggs serve and the limits of a universal replacement.
- Connect the new section to the existing allergen and event-serving notes.

### 3. Baseline Contract

Files: `scripts/check-baseline.sh`

- Require the new plan and section heading.
- Preserve the substitution cautions, source links, test-batch boundary, and
  allergen-safety boundary with wrap-stable checks.

### 4. Repository Guidance

Files: `README.md`, `VISION.md`, `CHANGES.md`

- Record the new practical content and completed validation.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the egg-function caution, replace the flour boundary with a generic
  cup-for-cup claim, remove the allergen boundary, and remove a source link;
  the static gate must reject each mutation.
- Run shell syntax, `git diff --check`, explicit no-scaffold verification, and
  intended-file secret scans.
- Take bounded exact-head pull-request, workflow, and code-scanning snapshots
  after push; do not start a watch loop.

## Work Completed

- Added function-aware milk, egg, flour, and fat substitution guidance after
  the base ratio.
- Required an about-8-pancake test before scaling and kept consistency changes
  tied to the existing batter rest.
- Added reviewed University of Minnesota Extension egg guidance and current FDA
  label and cross-contact guidance.
- Extended the content baseline with wrap-stable section checks, documentation
  contracts, and completed-plan evidence.
- Updated README, VISION, and change history for the new content boundary.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed against the
  final implementation.
- The egg-function mutation failed with `pancakes.md must keep source-backed,
  function-aware substitution guidance.`
- The flour-boundary mutation failed with the same substitution-contract error.
- The allergen-boundary mutation failed with the same substitution-contract
  error.
- The source-link mutation failed with the same substitution-contract error.
- The hosted pull-request check is not available before the implementation
  push; bounded exact-head evidence will be recorded in the engineering tracker
  without a watch loop.
