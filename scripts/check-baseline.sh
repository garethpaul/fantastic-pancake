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
PORTION_PLAN="$ROOT_DIR/docs/plans/2026-06-09-pancake-portioning-batch-size.md"
MIX_INS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-pancake-mix-ins-toppings.md"
RAW_BATTER_PLAN="$ROOT_DIR/docs/plans/2026-06-10-raw-batter-safety.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-hosted-content-checks.md"
BATCH_SCALING_PLAN="$ROOT_DIR/docs/plans/2026-06-12-pancake-batch-scaling-table.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".github/workflows/check.yml" \
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
  "docs/plans/2026-06-09-pancake-mix-ins-toppings.md" \
  "docs/plans/2026-06-09-pancake-portioning-batch-size.md" \
  "docs/plans/2026-06-09-pancake-storage-reheating.md" \
  "docs/plans/2026-06-09-pancake-troubleshooting-section.md" \
  "docs/plans/2026-06-10-raw-batter-safety.md" \
  "docs/plans/2026-06-12-pancake-batch-scaling-table.md" \
  "docs/plans/2026-06-09-no-scaffold-contract.md" \
  "docs/plans/2026-06-10-hosted-content-checks.md"; do
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
  ! grep -Fq "no-scaffold" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Mix-ins and toppings" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the content-only baseline and verification command." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "content-only" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "pancakes.md" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "dependency manifests" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Mix-ins and toppings" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current content baseline." >&2
  exit 1
fi

if ! grep -Fq "lint: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "test: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "build: check" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose lint, test, and build gates." >&2
  exit 1
fi

if ! grep -Fq "workflow_dispatch:" "$CI_WORKFLOW" ||
  ! grep -Fq "cancel-in-progress: true" "$CI_WORKFLOW" ||
  ! grep -Fq "runs-on: ubuntu-24.04" "$CI_WORKFLOW" ||
  ! grep -Fq "timeout-minutes: 5" "$CI_WORKFLOW" ||
  ! grep -Fq "run: make check" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must keep the bounded, least-privilege content check contract." >&2
  exit 1
fi

if [ "$(grep -Ec '^[[:space:]]+(-[[:space:]]+)?uses: actions/checkout@' "$CI_WORKFLOW")" -ne 1 ]; then
  printf '%s\n' "GitHub Actions must contain exactly one checkout step." >&2
  exit 1
fi

if ! awk '
  function finish_step() {
    if (checkout) {
      checkout_count++
      if (persist_credentials) {
        secure_checkout_count++
      }
    }
    checkout = 0
    with_block = 0
    persist_credentials = 0
  }

  /^      - / {
    finish_step()
  }

  /^        uses: actions\/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10([[:space:]]+#.*)?$/ {
    checkout = 1
  }

  /^      - uses: actions\/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10([[:space:]]+#.*)?$/ {
    checkout = 1
  }

  checkout && /^        with:$/ {
    with_block = 1
  }

  checkout && with_block && /^          persist-credentials: false$/ {
    persist_credentials = 1
  }

  END {
    finish_step()
    exit !(checkout_count == 1 && secure_checkout_count == 1)
  }
' "$CI_WORKFLOW"; then
  printf '%s\n' "The pinned checkout step must disable persisted credentials." >&2
  exit 1
fi

if ! awk '
  /^permissions:$/ {
    permissions_count++
    in_permissions = 1
    next
  }

  in_permissions && /^[^[:space:]]/ {
    in_permissions = 0
  }

  in_permissions && /^  contents: read$/ {
    contents_read++
    next
  }

  in_permissions && /^  [[:alnum:]_-]+:/ {
    unexpected_permission++
  }

  END {
    exit !(permissions_count == 1 && contents_read == 1 && unexpected_permission == 0)
  }
' "$CI_WORKFLOW" ||
  grep -Eq '^[[:space:]]+permissions:' "$CI_WORKFLOW" ||
  grep -Eq '^[[:space:]]*permissions:[[:space:]]*write-all([[:space:]]*(#.*)?)?$' "$CI_WORKFLOW" ||
  grep -Eq '^[[:space:]]+[[:alnum:]_-]+:[[:space:]]*write([[:space:]]*(#.*)?)?$' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must grant only top-level read access to repository contents." >&2
  exit 1
fi

if ! grep -Fq "does not persist checkout credentials" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the credential-free checkout boundary." >&2
  exit 1
fi

if ! grep -Fq "GitHub Actions" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "docs/plans/2026-06-10-hosted-content-checks.md" "$ROOT_DIR/README.md"; then
  printf '%s\n' "Project docs must record the hosted content check baseline." >&2
  exit 1
fi

for heading in \
  "# Pancakes" \
  "## Basic Pancake Method" \
  "## Basic Pancake Ratio" \
  "## Batch Scaling Table" \
  "## Portioning and Batch Size" \
  "## Batter Consistency and Resting" \
  "## Types of Pancakes" \
  "## Pancake Tips" \
  "## Griddle Heat and Doneness" \
  "## Troubleshooting Pancakes" \
  "## Mix-Ins and Toppings" \
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

python3 - "$ROOT_DIR/pancakes.md" <<'PY'
import sys
from pathlib import Path

content = Path(sys.argv[1]).read_text()
lines = content.splitlines()
header = "| Ingredient | About 8 | About 16 | About 32 |"
expected = [
    ["Flour", "1 cup", "2 cups", "4 cups"],
    ["Baking powder", "2 teaspoons", "4 teaspoons", "8 teaspoons"],
    ["Sugar", "1 tablespoon", "2 tablespoons", "4 tablespoons"],
    ["Salt", "1/4 teaspoon", "1/2 teaspoon", "1 teaspoon"],
    ["Milk", "1 cup", "2 cups", "4 cups"],
    ["Eggs", "1", "2", "4"],
    ["Melted butter or neutral oil", "2 tablespoons", "4 tablespoons", "8 tablespoons"],
]

try:
    start = lines.index(header)
except ValueError:
    raise SystemExit("pancakes.md must keep the batch scaling table header.")

rows = []
for line in lines[start + 2 :]:
    if not line.startswith("|"):
        break
    rows.append([cell.strip() for cell in line.strip("|").split("|")])

if rows != expected:
    raise SystemExit("pancakes.md must keep every ratio-aligned batch scaling quantity.")
if "two separate sets of the 16-pancake quantities" not in content:
    raise SystemExit("pancakes.md must keep the fresh-bowl scaling guidance.")
PY

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

if ! grep -Fq "1/4 cup scoop" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "2 tablespoons of batter" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "1/3 cup" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "2 inches between pours" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "premeasure dry ingredients" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep practical portioning and batch-size notes." >&2
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

if ! grep -Fq "Do not taste or serve uncooked pancake batter" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "raw flour and raw eggs" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "warm, soapy water" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "https://www.fda.gov/food/buy-store-serve-safe-food/handling-flour-safely-what-you-need-know" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "https://www.cdc.gov/food-safety/foods/no-raw-dough.html" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep source-backed raw batter safety guidance." >&2
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

if ! grep -Fq "small dry mix-ins" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "heavier or wet mix-ins" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "Pat rinsed berries" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "Organize topping bars" "$ROOT_DIR/pancakes.md" ||
  ! grep -Fq "allergen section's separate-utensil guidance" "$ROOT_DIR/pancakes.md"; then
  printf '%s\n' "pancakes.md must keep practical mix-ins and toppings guidance." >&2
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

if ! grep -Fq "status: completed" "$PORTION_PLAN"; then
  printf '%s\n' "Pancake portioning plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$PORTION_PLAN"; then
  printf '%s\n' "Pancake portioning plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MIX_INS_PLAN"; then
  printf '%s\n' "Pancake mix-ins and toppings plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$RAW_BATTER_PLAN"; then
  printf '%s\n' "Raw batter safety plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$MIX_INS_PLAN"; then
  printf '%s\n' "Pancake mix-ins and toppings plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CI_PLAN" ||
  ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "Hosted content checks plan must be completed and record verification." >&2
  exit 1
fi

python3 - "$BATCH_SCALING_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "all four Make gates",
    "push run `27392180169`",
    "pull-request run `27392182290`",
    "push run `27392192010`",
    "CodeQL run `27402319817`",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "The batch scaling plan must remain completed with actual verification recorded."
    )
PY

printf '%s\n' "fantastic-pancake content baseline checks passed."
