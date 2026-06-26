# fantastic-pancake

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/fantastic-pancake` is a public sample, documentation, or utility project. a repo about pancakes

This is maintained as a content-only pancake notes repository. It should stay
small until there is a concrete publishing need for a site, app, or data
pipeline.

## Repository Contents

- `SECURITY.md` - security reporting and disclosure guidance
- `CHANGES.md` - concise history of repository maintenance changes
- `Makefile` - local check entry point
- `VISION.md` - project direction and maintenance guardrails
- `docs/readme-overview.svg` - README overview image
- `pancakes.md` - pancake method, basic ratio, portioning, batter texture, cooking-station setup, tips, troubleshooting, mix-ins, toppings, and content outline
- `docs/plans/` - completed maintenance plans for content and baseline changes

Additional scan context:

- Source directories: no top-level source directories detected
- Dependency and build manifests: none detected
- Entry points or build surfaces: none detected
- Test-looking files: `scripts/check-baseline.sh`

## Getting Started

### Prerequisites

- Git
- GNU Make
- A POSIX shell
- Python 3

### Setup

```bash
git clone https://github.com/garethpaul/fantastic-pancake.git
cd fantastic-pancake
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Read `pancakes.md`.
- Keep future edits plain Markdown unless a publishing workflow becomes necessary.

## Testing and Verification

Run the content baseline:

```bash
make check
```

The content gate requires GNU Make, a POSIX shell, and Python 3. It uses the
`python3` command by default; set `PYTHON=/path/to/python3` on the Make command
line when a compatible interpreter has a different name or location.

Use the absolute Makefile path to run the same gate from another working
directory. Verification resolves the checker relative to the loaded Makefile
rather than the caller's directory.

The baseline verifies that the repository remains content-only, README/VISION
stay linked to `pancakes.md`, the overview image targets this repo, and the
pancake document keeps real sections instead of placeholder separators. It also
keeps a practical basic pancake ratio, griddle heat and doneness notes,
practical portioning and batch-size notes, practical batter consistency and
resting notes, troubleshooting notes, food-safety notes tied to an official
FoodSafety.gov source, and enforces a no-scaffold contract so app manifests,
dependency lockfiles, source directories, and generated dependency directories
do not appear without a new plan. Event serving notes must keep source-backed
allergen guidance, separate utensil language, and avoid unsupported
allergen-free claims. Ingredient substitutions must preserve function and
test-batch cautions, current label review, cross-contact controls, and official
or reviewed sources. Mix-ins and toppings notes must keep practical texture,
fruit, and labeling guidance. Batch notes must keep specific holding, storage,
and reheating thresholds.
Guide citations are limited to credential-free HTTPS URLs on approved official
government and university-extension hosts; this offline check does not claim
that remote pages are currently reachable.

The `make lint`, `make test`, and `make build` aliases run the same content
baseline while this repository has no narrower installed gates.
GitHub Actions runs `make check` for pushes and pull requests with read-only
repository permissions and does not persist checkout credentials.
Offline verification checks relative Markdown link, image, and heading-fragment targets without requesting external URLs.
Fenced Markdown examples close only with the matching marker and at least the opening fence length.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.

## Security and Privacy Notes

- The scan did not identify production authentication, payment, or secret-management code. Treat future additions in those areas as security-sensitive.
- Food-safety guidance should cite official sources and avoid vague storage or
  serving claims.
- Allergen guidance should stay tied to official sources and should not promise
  allergen-free preparation without controlled ingredients and surfaces.

## Maintenance Notes

- Run `make check` before pushing content or documentation changes.
- Keep the no-scaffold contract in place until there is a concrete publishing
  plan for an app or static site.
- Keep the allergen event-serving notes source-backed when expanding pancake
  bars or community breakfast guidance.
- Keep batch storage and reheating guidance tied to official food-safety
  sources when expanding event or leftover content.
- Keep portioning and batch-size notes practical when expanding group cooking
  guidance.
- Keep the batch scaling table aligned with the basic ratio and 1/4 cup yield.
- Keep griddle heat and doneness notes practical when expanding method content.
- Keep first-pancake calibration tied to the 1/4 cup portion and one-variable
  adjustments.
- Keep substitution guidance tied to the about-8-pancake test batch and
  separate recipe adaptation from allergen-safety claims.
- Keep batter texture and resting notes concise when expanding method content.
- Cooking-station guidance keeps raw batter tools separate from cooked-pancake utensils.
- Keep the cooking-station sequence tied to measured portions, uncrowded
  griddle space, and separate cooked-food utensils.
- Keep mix-ins and topping notes practical, clearly labeled, and tied to the
  allergen event-serving guidance.
- Keep `.github/workflows/check.yml` aligned with the local content baseline.
- See `docs/plans/2026-06-10-hosted-content-checks.md` for the hosted content
  verification baseline.
- See `docs/plans/2026-06-13-first-pancake-calibration.md` for the test-pancake
  decision sequence.
- See `docs/plans/2026-06-13-pancake-substitution-guidance.md` for substitution
  and allergy-safety boundaries.
- See `docs/plans/2026-06-25-pancake-cooking-station.md` for the repeatable
  raw-to-cooked batch workflow.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
