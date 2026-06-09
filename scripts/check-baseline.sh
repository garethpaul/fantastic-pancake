#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fantastic-pancake-content-baseline.md"

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
  "docs/plans/2026-06-08-fantastic-pancake-content-baseline.md"; do
  require_file "$path"
done

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "pancakes.md" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/readme-overview.svg" "$ROOT_DIR/README.md" ||
  ! grep -Fq "content-only" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the content-only baseline and verification command." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "content-only" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "pancakes.md" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current content baseline." >&2
  exit 1
fi

for heading in \
  "# Pancakes" \
  "## Basic Pancake Method" \
  "## Types of Pancakes" \
  "## Pancake Tips" \
  "## Pancake-Related Events and Traditions" \
  "## Creative Pancake Ideas" \
  "## Source and Safety Notes"; do
  if ! grep -Fq "$heading" "$ROOT_DIR/pancakes.md"; then
    printf '%s\n' "Missing pancake content heading: $heading" >&2
    exit 1
  fi
done

bullet_count=$(grep -c '^- ' "$ROOT_DIR/pancakes.md")
if [ "$bullet_count" -lt 12 ]; then
  printf '%s\n' "pancakes.md must keep enough specific content bullets." >&2
  exit 1
fi

if grep -Eq '^(---|### \*\*)' "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md should use clean Markdown headings, not placeholder separators." >&2
  exit 1
fi

if ! grep -Fq "FoodSafety.gov" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "https://www.foodsafety.gov/blog/leftovers-gift-keeps-giving" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "2 hours" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep source-backed food-safety guidance." >&2
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

printf '%s\n' "fantastic-pancake content baseline checks passed."
