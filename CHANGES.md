# Changes

## 2026-06-26 02:58 PDT - P2 - Match Markdown fence closers

### Summary
Hardened offline Markdown visibility parsing so backtick and tilde fences cannot
close each other and a shorter fence cannot close a longer example block.

### Work completed
- Track the opening fence marker and run length.
- Close examples only with the same marker and at least the opening length.
- Preserve link scanning immediately after the real matching closer.
- Keep HTML-comment and inline-code visibility behavior unchanged.
- Added three temporary-tree regressions and static source contracts.
- Fenced Markdown examples close only with the matching marker and at least the opening fence length.

### Threads
- Started: none.
- Continued: offline Markdown integrity — fenced-example parsing complete.
- Stopped: none.

### Files changed
- `scripts/check-internal-links.py` — adds marker-aware fence state.
- `scripts/test-internal-links.py` — covers mismatched, short, and real closers.
- `scripts/check-baseline.sh` — enforces source, test, plan, and guidance contracts.
- Documentation and plan files — record the offline parsing boundary.

### Validation
- Red-first internal-link tests — both original mismatch cases failed, then all
  24 tests and the maintained repository scan passed after implementation.
- Marker-check and minimum-length removal mutations — both rejected.
- `make lint|test|build|check` — passed under `C` and `C.UTF-8` and from `/tmp`
  through the absolute Makefile path.
- Python compilation, shell syntax, and `git diff --check` — passed.
- Hosted content/CodeQL exact-head checks and review remain the next action.

### Bugs / findings
- P2: blindly toggling on either fence marker could report links inside examples
  or hide links after the intended closing fence.

### Blockers
- None; validation is dependency-free and does not request external URLs.

### Next action
- Open the PR, run hosted exact-head validation and review, then merge.

## 2026-06-25 07:32:32 PDT

- Added a repeatable cooking-station setup covering measured portions,
  uncrowded griddle space, one-way workflow, clean cooked-food utensils, and
  short-term rack holding.
- Cooking-station guidance keeps raw batter tools separate from cooked-pancake utensils.

## 2026-06-19

- Hardened offline Markdown validation against symlinks, non-file targets,
  malformed percent encoding, local file URLs, uppercase extensions, and
  GitHub heading-slug edge cases.
- Clarified that shared kitchens cannot guarantee allergen-free pancakes and
  linked FDA guidance for allergen cross-contact and hot buffet holding.

## 2026-06-16

- Offline verification checks relative Markdown link, image, and heading-fragment targets without requesting external URLs.
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
