# Changes

## 2026-06-16

- The content gate requires GNU Make, a POSIX shell, and Python 3. Added an
  explicit interpreter override and actionable missing or incompatible runtime
  diagnostics.

## 2026-06-14

- Replaced a redirected FDA food-allergy citation with its canonical HTTPS
  location and made the content gate reject the retired path.

## 2026-06-13

- Made content verification independent of the caller's working directory by
  resolving the baseline checker from the loaded Makefile.
- Added structural source provenance checks for HTTPS, userinfo, ports,
  approved hosts, and continued representation of every reviewed source host.
- Added source-backed ingredient substitution guidance with test-batch,
  ingredient-function, label-review, and cross-contact boundaries.
- Extended the content baseline to preserve the substitution safety contract
  and completed verification evidence.
- Added a first-pancake calibration sequence that separates heat corrections
  from tablespoon-by-tablespoon batter adjustments.
- Extended the content baseline to preserve the calibration order and completed
  verification evidence.

## 2026-06-12

- Added an 8-, 16-, and 32-pancake scaling table tied to the basic ratio and
  practical fresh-bowl guidance for the largest batch.
- Extended the content baseline to preserve the scaled quantities and plan.

## 2026-06-10

- Added FDA- and CDC-backed raw batter handling and cleanup guidance.
- Added a pinned, least-privilege GitHub Actions workflow that runs the content
  and no-scaffold baseline for pushes and pull requests without persisting
  checkout credentials.
- Extended the checker and documentation to keep hosted verification required.

## 2026-06-09

- Added mix-ins and toppings guidance for folding, sprinkling, fruit prep,
  topping-bar organization, and allergen labeling.
- Added pancake portioning and batch-size notes with scoop sizes, spacing, and
  dry-mix prep guidance.
- Added batter consistency and resting notes with tablespoon-by-tablespoon
  texture adjustments and a baseline guard.
- Added griddle heat and doneness notes for preheating, flipping, and avoiding
  pressed pancakes, plus `make lint`/`make test`/`make build` baseline aliases.
- Added a basic pancake ratio section with starting quantities and scaling notes.
- Added a practical troubleshooting section for flat, tough, pale, burnt,
  gummy, and uneven pancakes.
- Extended the content baseline and plan docs to guard the new section.
- Added source-backed allergen and event-serving notes for pancake bars, plus a
  baseline guard for labels, separate utensils, and allergen-free claims.
- Added batch storage and reheating notes with concrete holding and leftover
  thresholds.

## 2026-06-08

- Added a no-scaffold check so app manifests, dependency lockfiles, and source
  directories require an explicit publishing plan before landing.
- Added a basic pancake method section to make the content outline more useful.
- Replaced placeholder pancake headings with concise content covering types,
  tips, traditions, and creative ideas.
- Added `make check` and `scripts/check-baseline.sh` to verify the content-only
  repository baseline.
- Documented the maintenance plan in `docs/plans/`.
- Added source-backed food-safety notes for future recipe or serving guidance.
