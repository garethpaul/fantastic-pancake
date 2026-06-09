#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fantastic-pancake-content-baseline.md"
NO_SCAFFOLD_PLAN="$ROOT_DIR/docs/plans/2026-06-09-no-scaffold-contract.md"
ALLERGEN_PLAN="$ROOT_DIR/docs/plans/2026-06-09-allergen-event-serving-notes.md"
TROUBLESHOOTING_PLAN="$ROOT_DIR/docs/plans/2026-06-09-pancake-troubleshooting-section.md"
RATIO_PLAN="$ROOT_DIR/docs/plans/2026-06-09-basic-pancake-ratio.md"
STORAGE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-pancake-storage-reheating.md"
GRIDDLE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-griddle-heat-doneness.md"
BATTER_PLAN="$ROOT_DIR/docs/plans/2026-06-09-batter-consistency-resting.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "docs/readme-overview.svg" \
  "pancakes.md" \
  "docs/plans/2026-06-08-fantastic-pancake-content-baseline.md" \
  "docs/plans/2026-06-09-allergen-event-serving-notes.md" \
  "docs/plans/2026-06-09-batter-consistency-resting.md" \
  "docs/plans/2026-06-09-basic-pancake-ratio.md" \
  "docs/plans/2026-06-09-griddle-heat-doneness.md" \
  "docs/plans/2026-06-09-pancake-storage-reheating.md" \
  "docs/plans/2026-06-09-pancake-troubleshooting-section.md" \
  "docs/plans/2026-06-09-no-scaffold-contract.md"; do
  require_file "$path"
done

for path in \
  "Cargo.toml" \
  "Gemfile" \
  "go.mod" \
  "package.json" \
  "package-lock.json" \
  "pnpm-lock.yaml" \
  "pyproject.toml" \
  "requirements.txt" \
  "yarn.lock"; do
  if [ -e "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Unexpected app or dependency manifest: $path" >&2
    exit 1
  fi
done

for path in \
  "app" \
  "node_modules" \
  "src" \
  "vendor"; do
  if [ -d "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Unexpected app or dependency directory: $path" >&2
    exit 1
  fi
done

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "pancakes.md" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/readme-overview.svg" "$ROOT_DIR/README.md" ||
  ! grep -Fq "content-only" "$ROOT_DIR/README.md" ||
  ! grep -Fq "no-scaffold" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the content-only baseline and verification command." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "content-only" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "pancakes.md" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "dependency manifests" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current content baseline." >&2
  exit 1
fi

if ! grep -Fq "lint: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "test: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "build: check" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose lint, test, and build gates." >&2
  exit 1
fi

for heading in \
  "# Pancakes" \
  "## Basic Pancake Method" \
  "## Basic Pancake Ratio" \
  "## Batter Consistency and Resting" \
  "## Types of Pancakes" \
  "## Pancake Tips" \
  "## Griddle Heat and Doneness" \
  "## Troubleshooting Pancakes" \
  "## Pancake-Related Events and Traditions" \
  "## Allergen and Event Serving Notes" \
  "## Batch Storage and Reheating" \
  "## Creative Pancake Ideas" \
  "## Source and Safety Notes"; do
  if ! grep -Fq "$heading" "$ROOT_DIR/pancakes.md"; then
    printf '%s\n' "Missing pancake content heading: $heading" >&2
    exit 1
  fi
done

bullet_count=$(grep -c '^- ' "$ROOT_DIR/pancakes.md")
if [ "$bullet_count" -lt 20 ]; then
  printf '%s\n' "pancakes.md must keep enough specific content bullets." >&2
  exit 1
fi

if grep -Eq '^(---|### \*\*)' "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md should use clean Markdown headings, not placeholder separators." >&2
  exit 1
fi

if ! grep -Fq "1 cup flour" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "2 teaspoons baking" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "1 egg" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "Scale dry and wet ingredients together" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep a practical basic pancake ratio." >&2
  exit 1
fi

if ! grep -Fq "pourable but thick" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "milk 1 tablespoon" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "flour 1 tablespoon" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "Small lumps are fine" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "air is not beaten out" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep practical batter consistency and resting notes." >&2
  exit 1
fi

if ! grep -Fq "FoodSafety.gov" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "https://www.foodsafety.gov/blog/leftovers-gift-keeps-giving" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "2 hours" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep source-backed food-safety guidance." >&2
  exit 1
fi

if ! grep -Fq "140 degrees F" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "165 degrees F" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "within 4 days" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "shallow, covered" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep practical storage and reheating guidance for batches." >&2
  exit 1
fi

if ! grep -Fq "https://www.foodsafety.gov/blog/food-allergy-safety-treatment-education-and-research-act-2021" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "separate serving utensils" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "allergen-free" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep source-backed allergen event-serving guidance." >&2
  exit 1
fi

for allergen in milk eggs wheat peanuts "tree nuts" soybeans sesame; do
  if ! grep -Fq "$allergen" "$ROOT_DIR/pancakes.md"; then
    printf '%s\n' "Missing allergen note: $allergen" >&2
    exit 1
  fi
done

if ! grep -Fq "Flat pancakes" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "Tough pancakes" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "Gummy centers" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep practical troubleshooting notes." >&2
  exit 1
fi

if ! grep -Fq "350 to 375 degrees F" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "edges look set" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "avoid pressing" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep practical griddle heat and doneness notes." >&2
  exit 1
fi

if ! grep -Fq "<title id=\"title\">fantastic-pancake project overview</title>" "$ROOT_DIR/docs/readme-overview.svg"; then
  printf '%s\n' "README overview image must describe this repository." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$NO_SCAFFOLD_PLAN"; then
  printf '%s\n' "No-scaffold plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ALLERGEN_PLAN"; then
  printf '%s\n' "Allergen event-serving plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TROUBLESHOOTING_PLAN"; then
  printf '%s\n' "Troubleshooting plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$RATIO_PLAN"; then
  printf '%s\n' "Basic pancake ratio plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$STORAGE_PLAN"; then
  printf '%s\n' "Storage and reheating plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$GRIDDLE_PLAN"; then
  printf '%s\n' "Griddle heat and doneness plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$BATTER_PLAN"; then
  printf '%s\n' "Batter consistency plan must be marked completed." >&2
  exit 1
fi

printf '%s\n' "fantastic-pancake content baseline checks passed."
