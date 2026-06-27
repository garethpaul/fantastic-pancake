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
CALIBRATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-first-pancake-calibration.md"
SUBSTITUTION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-pancake-substitution-guidance.md"
SOURCE_PROVENANCE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-source-provenance-boundary.md"
LOCATION_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-location-independent-make.md"
MAKE_ROOT_PROTECTION_PLAN="$ROOT_DIR/docs/plans/2026-06-14-make-root-override-protection.md"
CANONICAL_ALLERGEN_SOURCE_PLAN="$ROOT_DIR/docs/plans/2026-06-14-002-security-canonical-fda-allergen-source-plan.md"
PYTHON_PREFLIGHT_PLAN="$ROOT_DIR/docs/plans/2026-06-16-python-verification-preflight.md"
INTERNAL_LINK_PLAN="$ROOT_DIR/docs/plans/2026-06-16-offline-internal-link-integrity.md"
HEADING_FRAGMENT_PLAN="$ROOT_DIR/docs/plans/2026-06-16-markdown-heading-fragment-integrity.md"
COOKING_STATION_PLAN="$ROOT_DIR/docs/plans/2026-06-25-pancake-cooking-station.md"
MATCHED_FENCE_PLAN="$ROOT_DIR/docs/plans/2026-06-26-matched-markdown-fences.md"
RAW_HTML_LINK_PLAN="$ROOT_DIR/docs/plans/2026-06-27-raw-html-link-integrity.md"
INTERNAL_LINK_CHECKER="$ROOT_DIR/scripts/check-internal-links.py"
INTERNAL_LINK_TEST="$ROOT_DIR/scripts/test-internal-links.py"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
PYTHON=${PYTHON:-python3}

if ! command -v "$PYTHON" >/dev/null 2>&1; then
  printf '%s\n' "Python 3 command not found: $PYTHON (set PYTHON to a Python 3 executable)." >&2
  exit 1
fi

python_major=$("$PYTHON" -c 'import sys; sys.stdout.write(str(sys.version_info[0]))' 2>/dev/null || true)
if [ "$python_major" != "3" ]; then
  printf '%s\n' "Verification requires Python 3: $PYTHON" >&2
  exit 1
fi

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
  "docs/plans/2026-06-13-first-pancake-calibration.md" \
  "docs/plans/2026-06-13-pancake-substitution-guidance.md" \
  "docs/plans/2026-06-13-source-provenance-boundary.md" \
  "docs/plans/2026-06-13-location-independent-make.md" \
  "docs/plans/2026-06-14-make-root-override-protection.md" \
  "docs/plans/2026-06-14-002-security-canonical-fda-allergen-source-plan.md" \
  "docs/plans/2026-06-16-python-verification-preflight.md" \
  "docs/plans/2026-06-16-offline-internal-link-integrity.md" \
  "docs/plans/2026-06-16-markdown-heading-fragment-integrity.md" \
  "docs/plans/2026-06-25-pancake-cooking-station.md" \
  "docs/plans/2026-06-26-matched-markdown-fences.md" \
  "docs/plans/2026-06-27-raw-html-link-integrity.md" \
  "docs/plans/2026-06-09-no-scaffold-contract.md" \
  "docs/plans/2026-06-10-hosted-content-checks.md" \
  "scripts/check-internal-links.py" \
  "scripts/test-internal-links.py"; do
  require_file "$path"
done

"$PYTHON" "$INTERNAL_LINK_TEST"
"$PYTHON" "$INTERNAL_LINK_CHECKER" "$ROOT_DIR"

VISIBLE_PANCAKES=$(mktemp "${TMPDIR:-/tmp}/fantastic-pancake-visible.XXXXXX")
trap 'rm -f "$VISIBLE_PANCAKES"' EXIT HUP INT TERM
"$PYTHON" - "$INTERNAL_LINK_CHECKER" "$ROOT_DIR/pancakes.md" "$VISIBLE_PANCAKES" <<'PY'
import importlib.util
import sys
from pathlib import Path

checker_path = Path(sys.argv[1])
spec = importlib.util.spec_from_file_location("check_internal_links", checker_path)
if spec is None or spec.loader is None:
    raise SystemExit("Unable to load Markdown visibility helper.")
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)

source = Path(sys.argv[2]).read_text(encoding="utf-8")
Path(sys.argv[3]).write_text(checker.visible_markdown_text(source), encoding="utf-8")
PY

if [ "$(grep -Fxc '"$PYTHON" "$INTERNAL_LINK_TEST"' "$ROOT_DIR/scripts/check-baseline.sh")" -ne 1 ] ||
  [ "$(grep -Fxc '"$PYTHON" "$INTERNAL_LINK_CHECKER" "$ROOT_DIR"' "$ROOT_DIR/scripts/check-baseline.sh")" -ne 1 ] ||
  ! grep -Fq 'def validate_repository(root: Path) -> list[str]:' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'local link escapes repository' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'local link target does not exist' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'def markdown_anchors(content: str) -> set[str]:' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'def visible_markdown_text(content: str) -> str:' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'FENCE_PATTERN = re.compile' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'fence[0] == fence_marker' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'len(fence) >= fence_length' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'local Markdown anchor does not exist' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'local link target must not be a symlink' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'local link target is not a regular file' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'invalid percent-encoding in local link' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'local file URL is not allowed' "$INTERNAL_LINK_CHECKER" ||
  ! grep -Fq 'test_rejects_missing_local_target' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_repository_escape' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_ignores_links_inside_fenced_examples' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_mismatched_fence_marker_does_not_close_example' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_shorter_matching_fence_does_not_close_example' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_matching_fence_restores_link_scanning_after_mismatch' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_ignores_link_syntax_inside_inline_code' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_generates_unique_github_style_heading_anchors' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_missing_same_and_cross_document_anchors' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_ignores_heading_syntax_inside_fenced_examples' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_ignores_links_and_anchors_inside_html_comments' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_inline_comment_marker_does_not_hide_following_heading' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_ignores_custom_anchor_syntax_inside_inline_code' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_missing_reference_definition_target' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_matches_github_slugger_for_literal_underscores_and_symbols' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_visible_markdown_text_excludes_comments_fences_and_inline_code' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_scans_uppercase_markdown_extensions' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_symlinked_markdown_sources' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_symlinked_and_non_file_targets' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_malformed_or_unsafe_percent_encoding_without_crashing' "$INTERNAL_LINK_TEST" ||
  ! grep -Fq 'test_rejects_local_file_urls' "$INTERNAL_LINK_TEST"; then
  printf '%s\n' "Offline internal-link verification contracts are incomplete." >&2
  exit 1
fi

for raw_html_contract in \
  'class HTMLDestinationParser(HTMLParser):' \
  'def html_destinations(content: str):' \
  'test_rejects_missing_raw_html_link_and_image_targets' \
  'test_accepts_valid_and_external_raw_html_destinations'; do
  if ! grep -Fq "$raw_html_contract" "$INTERNAL_LINK_CHECKER" "$INTERNAL_LINK_TEST"; then
    printf '%s\n' "Raw HTML link verification contract is missing: $raw_html_contract" >&2
    exit 1
  fi
done

if ! grep -Fq 'Status: Completed' "$RAW_HTML_LINK_PLAN" || \
  ! grep -Fq 'make check' "$RAW_HTML_LINK_PLAN"; then
  printf '%s\n' "Raw HTML link integrity plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq 'Status: Completed' "$MATCHED_FENCE_PLAN" || \
  ! grep -Fq 'make check' "$MATCHED_FENCE_PLAN"; then
  printf '%s\n' "Matched Markdown fence plan must record completed verification." >&2
  exit 1
fi

matched_fence_guidance='Fenced Markdown examples close only with the matching marker and at least the opening fence length.'
for matched_fence_doc in "$ROOT_DIR/AGENTS.md" "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md"; do
  if ! grep -Fq "$matched_fence_guidance" "$matched_fence_doc"; then
    printf '%s\n' "$matched_fence_doc must document matched Markdown fence handling." >&2
    exit 1
  fi
done

if ! grep -Fq 'override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq 'PYTHON ?= python3' "$ROOT_DIR/Makefile" ||
  ! grep -Fq 'PYTHON="$(PYTHON)" "$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must protect and resolve the checker from the loaded Makefile." >&2
  exit 1
fi

python_preflight=$(sed -n '/^PYTHON=${PYTHON:-python3}$/,/^require_file()/p' "$ROOT_DIR/scripts/check-baseline.sh")
for python_preflight_contract in \
  'PYTHON=${PYTHON:-python3}' \
  'command -v "$PYTHON"' \
  'sys.stdout.write(str(sys.version_info[0]))' \
  'if [ "$python_major" != "3" ]; then' \
  'Python 3 command not found:' \
  'Verification requires Python 3:'; do
  if ! printf '%s\n' "$python_preflight" | grep -Fq "$python_preflight_contract"; then
    printf '%s\n' "Python verification preflight contract is missing: $python_preflight_contract" >&2
    exit 1
  fi
done

if [ "$(grep -Ec '^"\$PYTHON" - ' "$ROOT_DIR/scripts/check-baseline.sh")" -ne 8 ] ||
  grep -Eq '^python3 - ' "$ROOT_DIR/scripts/check-baseline.sh"; then
  printf '%s\n' "Every embedded Python check must use the preflighted interpreter command." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "from /tmp" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "absolute Makefile path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Made content verification independent" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Location-independent Make plan and guidance must record completed external verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MAKE_ROOT_PROTECTION_PLAN" ||
  ! grep -Fq 'make ROOT=/tmp check' "$MAKE_ROOT_PROTECTION_PLAN" ||
  ! grep -Fq "four Make gates" "$MAKE_ROOT_PROTECTION_PLAN" ||
  ! grep -Fq "external working directory" "$MAKE_ROOT_PROTECTION_PLAN"; then
  printf '%s\n' "Make root protection plan must record completed hostile-override and external verification." >&2
  exit 1
fi

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
  ! grep -Fq "Mix-ins and toppings" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Ingredient substitutions" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document the content-only baseline and verification command." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "content-only" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "pancakes.md" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "dependency manifests" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Mix-ins and toppings" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Ingredient substitution notes" "$ROOT_DIR/VISION.md"; then
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
  "## Ingredient Substitutions" \
  "## Batch Scaling Table" \
  "## Portioning and Batch Size" \
  "## Batter Consistency and Resting" \
  "## Cooking Station Setup" \
  "## Types of Pancakes" \
  "## Pancake Tips" \
  "## Griddle Heat and Doneness" \
  "## First Pancake Calibration" \
  "## Troubleshooting Pancakes" \
  "## Mix-Ins and Toppings" \
  "## Pancake-Related Events and Traditions" \
  "## Allergen and Event Serving Notes" \
  "## Batch Storage and Reheating" \
  "## Creative Pancake Ideas" \
  "## Source and Safety Notes"; do
  if ! grep -Fq "$heading" "$VISIBLE_PANCAKES"; then
    printf '%s\n' "Missing pancake content heading: $heading" >&2
    exit 1
  fi
done

for station_contract in \
  "Set out the batter, 1/4 cup measure, thin spatula, light grease, and landing tray" \
  "leave at least 1 inch between pancakes" \
  "raw batter to griddle to finished tray" \
  "Keep one clean utensil for moving cooked pancakes" \
  "wire rack set over a sheet pan"; do
  if ! grep -Fq "$station_contract" "$VISIBLE_PANCAKES"; then
    printf '%s\n' "pancakes.md must keep practical cooking-station setup: $station_contract" >&2
    exit 1
  fi
done

station_guidance="Cooking-station guidance keeps raw batter tools separate from cooked-pancake utensils."
for station_document in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "$station_guidance" "$ROOT_DIR/$station_document"; then
    printf '%s\n' "$station_document must document the cooking-station utensil boundary." >&2
    exit 1
  fi
done
for station_plan_contract in \
  'Status: Completed' \
  'make check' \
  'external-directory' \
  'hostile cooking-station mutations were rejected' \
  'No kitchen or live cooking test was performed'; do
  if ! grep -Fq "$station_plan_contract" "$COOKING_STATION_PLAN"; then
    printf '%s\n' "Cooking-station plan must preserve completion evidence: $station_plan_contract" >&2
    exit 1
  fi
done

bullet_count=$(grep -c '^- ' "$VISIBLE_PANCAKES")
if [ "$bullet_count" -lt 20 ]; then
  printf '%s\n' "pancakes.md must keep enough specific content bullets." >&2
  exit 1
fi

"$PYTHON" - "$VISIBLE_PANCAKES" <<'PY'
import re
import sys
from pathlib import Path
from urllib.parse import urlsplit

content = Path(sys.argv[1]).read_text(encoding="utf-8")
urls = re.findall(r"[A-Za-z][A-Za-z0-9+.-]*://[^\s<>)\]]+", content)
approved_hosts = {
    "extension.umn.edu",
    "www.cdc.gov",
    "www.fda.gov",
    "www.foodsafety.gov",
}

if not urls:
    raise SystemExit("pancakes.md must retain reviewed external sources.")

observed_hosts = set()
for value in urls:
    try:
        parsed = urlsplit(value)
        port = parsed.port
    except ValueError as error:
        raise SystemExit(f"Invalid source URL authority: {value}") from error

    host = parsed.hostname
    if (
        parsed.scheme != "https"
        or not host
        or parsed.username is not None
        or parsed.password is not None
        or port is not None
        or parsed.netloc.lower() != host
        or host not in approved_hosts
    ):
        raise SystemExit(f"Unapproved source URL: {value}")
    observed_hosts.add(host)

if observed_hosts != approved_hosts:
    missing = ", ".join(sorted(approved_hosts - observed_hosts))
    raise SystemExit(f"pancakes.md must retain every reviewed source host: {missing}")
PY

"$PYTHON" - "$VISIBLE_PANCAKES" <<'PY'
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

if grep -Eq '^(---|### \*\*)' "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md should use clean Markdown headings, not placeholder separators." >&2
  exit 1
fi

if ! grep -Fq "1 cup flour" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "2 teaspoons baking" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "1 egg" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Scale dry and wet ingredients together" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep a practical basic pancake ratio." >&2
  exit 1
fi

"$PYTHON" - "$VISIBLE_PANCAKES" "$ROOT_DIR" <<'PY'
import re
import sys
from pathlib import Path

content = Path(sys.argv[1]).read_text()
root = Path(sys.argv[2])
section = content.split("## Ingredient Substitutions\n", 1)[-1].split(
    "## Batch Scaling Table", 1
)[0]
normalized = re.sub(r"\s+", " ", section).strip()
required = (
    "Substitutions can change flavor, color, texture, or volume.",
    "Test the about-8-pancake ratio before scaling",
    "same amount of an unsweetened replacement",
    "reassess the rested batter",
    "Eggs add moisture, binding, and lift",
    "no single egg replacement reproduces every function",
    "one-to-one replacement for all-purpose flour",
    "Do not assume a single alternative flour will work cup for cup.",
    "2 tablespoons of neutral oil instead of melted butter",
    "A substitution does not prove a batch is allergen-free.",
    "Check current ingredient and advisory labels every time",
    "control cross-contact from prep surfaces, utensils, and equipment",
    "https://extension.umn.edu/family-news/egg-substitutions-baking",
    "https://www.fda.gov/food/nutrition-food-labeling-and-critical-foods/food-allergies",
)

if any(fragment not in normalized for fragment in required):
    raise SystemExit(
        "pancakes.md must keep source-backed, function-aware substitution guidance."
    )

retired_url = "https://www.fda.gov/food/food-labeling-nutrition/food-allergies"
retired_matches = [
    str(path.relative_to(root))
    for path in root.rglob("*.md")
    if retired_url in path.read_text()
]
if retired_matches:
    raise SystemExit(
        "Retired FDA food-allergy URL remains in: " + ", ".join(retired_matches)
    )
PY

if ! grep -Fq "1/4 cup scoop" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "2 tablespoons of batter" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "1/3 cup" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "2 inches between pours" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "premeasure dry ingredients" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep practical portioning and batch-size notes." >&2
  exit 1
fi

if ! grep -Fq "pourable but thick" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "milk 1 tablespoon" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "flour 1 tablespoon" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Small lumps are fine" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "air is not beaten out" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep practical batter consistency and resting notes." >&2
  exit 1
fi

if ! grep -Fq "FoodSafety.gov" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "https://www.foodsafety.gov/blog/leftovers-gift-keeps-giving" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "2 hours" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep source-backed food-safety guidance." >&2
  exit 1
fi

if ! grep -Fq "140 degrees F" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "165 degrees F" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "within 4 days" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "shallow, covered" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep practical storage and reheating guidance for batches." >&2
  exit 1
fi

if ! grep -Fq "Do not taste or serve uncooked pancake batter" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "raw flour and raw eggs" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "warm, soapy water" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "https://www.fda.gov/food/buy-store-serve-safe-food/handling-flour-safely-what-you-need-know" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "https://www.cdc.gov/food-safety/foods/no-raw-dough.html" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep source-backed raw batter safety guidance." >&2
  exit 1
fi

if ! grep -Fq "https://www.foodsafety.gov/blog/food-allergy-safety-treatment-education-and-research-act-2021" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "separate serving utensils" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "A shared kitchen cannot guarantee an allergen-free batch" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Ask the guest or event organizer which controls they require" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep source-backed allergen event-serving guidance." >&2
  exit 1
fi

if ! grep -Fq "https://www.fda.gov/food/buy-store-serve-safe-food/serving-safe-buffets" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must cite the FDA source for hot buffet holding." >&2
  exit 1
fi

for allergen in milk eggs wheat peanuts "tree nuts" soybeans sesame; do
  if ! grep -Fq "$allergen" "$VISIBLE_PANCAKES"; then
    printf '%s\n' "Missing allergen note: $allergen" >&2
    exit 1
  fi
done

if ! grep -Fq "Flat pancakes" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Tough pancakes" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Gummy centers" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep practical troubleshooting notes." >&2
  exit 1
fi

if ! grep -Fq "small dry mix-ins" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "heavier or wet mix-ins" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Pat rinsed berries" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Organize topping bars" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "allergen section's separate-utensil guidance" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep practical mix-ins and toppings guidance." >&2
  exit 1
fi

if ! grep -Fq "350 to 375 degrees F" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "edges look set" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "avoid pressing" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep practical griddle heat and doneness notes." >&2
  exit 1
fi

if ! grep -Fq "Pour one 1/4 cup test pancake" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "Judge browning before changing the batter" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "underside browns before bubbles open" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "lower the heat" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "remains pale after bubbles open" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "raise heat" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "flour 1 tablespoon at a time" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "milk 1" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "tablespoon at a time" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "cook a second test pancake" "$VISIBLE_PANCAKES" ||
  ! grep -Fq "change only one variable between tests" "$VISIBLE_PANCAKES"; then
  printf '%s\n' "pancakes.md must keep the ordered first-pancake calibration sequence." >&2
  exit 1
fi

"$PYTHON" - "$VISIBLE_PANCAKES" <<'PY'
import sys
from pathlib import Path

content = Path(sys.argv[1]).read_text()
section = content.split("## First Pancake Calibration\n", 1)[-1].split(
    "## Troubleshooting Pancakes", 1
)[0]
contract = (
    "Pour one 1/4 cup test pancake",
    "Judge browning before changing the batter",
    "underside browns before bubbles open",
    "remains pale after bubbles open",
    "Once the heat is corrected",
    "flour 1 tablespoon at a time",
    "test pancake stays mounded",
    "milk 1\n  tablespoon at a time",
    "After any adjustment, cook a second test pancake",
    "change only one variable between tests",
)
positions = [section.find(fragment) for fragment in contract]
if -1 in positions or positions != sorted(positions) or len(set(positions)) != len(positions):
    raise SystemExit("First-pancake calibration must preserve its fail-clear decision order.")
PY

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

"$PYTHON" - "$BATCH_SCALING_PLAN" <<'PY'
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

"$PYTHON" - "$CALIBRATION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
required = (
    "heat correction mutation failed",
    "consistency correction mutation failed",
    "second-test ordering mutation failed",
    "hosted pull-request check",
)

if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit(
        "The first-pancake calibration plan must record completed status and actual verification."
    )
PY

"$PYTHON" - "$SUBSTITUTION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
required = (
    "egg-function mutation failed",
    "flour-boundary mutation failed",
    "allergen-boundary mutation failed",
    "source-link mutation failed",
    "hosted pull-request check",
)

if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit(
        "The substitution plan must record completed status and actual verification."
    )
PY

if ! grep -Fq "status: completed" "$SOURCE_PROVENANCE_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$SOURCE_PROVENANCE_PLAN" ||
  ! grep -Fq "No network fetch" "$SOURCE_PROVENANCE_PLAN" ||
  ! grep -Fq "all four Make gates" "$SOURCE_PROVENANCE_PLAN"; then
  printf '%s\n' "Source provenance plan must record completed local verification." >&2
  exit 1
fi

if ! grep -Fq "credential-free HTTPS URLs on approved official" "$ROOT_DIR/README.md" ||
  ! grep -Fq "HTTPS URLs from the reviewed source hosts" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "structurally validates source URLs" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Added structural source provenance checks" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must preserve the source provenance boundary." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CANONICAL_ALLERGEN_SOURCE_PLAN" ||
  ! grep -Fq "repository root" "$CANONICAL_ALLERGEN_SOURCE_PLAN" ||
  ! grep -Fq "external working directory" "$CANONICAL_ALLERGEN_SOURCE_PLAN" ||
  ! grep -Fq "isolated hostile mutations" "$CANONICAL_ALLERGEN_SOURCE_PLAN" ||
  ! grep -Fq "canonical FDA page" "$CANONICAL_ALLERGEN_SOURCE_PLAN"; then
  printf '%s\n' "Canonical FDA allergen source plan must record completed verification." >&2
  exit 1
fi

for python_preflight_doc in README.md AGENTS.md VISION.md CHANGES.md; do
  if ! grep -Fq "The content gate requires GNU Make, a POSIX shell, and Python 3." "$ROOT_DIR/$python_preflight_doc"; then
    printf '%s\n' "$python_preflight_doc must document the Python verification prerequisite." >&2
    exit 1
  fi
done

for python_preflight_plan_contract in \
  "## Status: Completed" \
  "repository root and external working directory" \
  "explicit compatible Python command override" \
  "missing-command and non-Python-3 preflights" \
  "hostile mutations were rejected"; do
  if ! grep -Fq "$python_preflight_plan_contract" "$PYTHON_PREFLIGHT_PLAN"; then
    printf '%s\n' "Python verification preflight plan must record completed evidence: $python_preflight_plan_contract" >&2
    exit 1
  fi
done

internal_link_guidance='Offline verification checks relative Markdown link, image, and heading-fragment targets without requesting external URLs.'
for internal_link_doc in README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "$internal_link_guidance" "$ROOT_DIR/$internal_link_doc"; then
    printf '%s\n' "$internal_link_doc must document offline internal-link verification." >&2
    exit 1
  fi
done

for internal_link_plan_contract in \
  "## Status: Completed" \
  "repository root and external working directory" \
  "isolated internal-link mutations were rejected" \
  "No external URL request"; do
  if ! grep -Fq "$internal_link_plan_contract" "$INTERNAL_LINK_PLAN"; then
    printf '%s\n' "Offline internal-link plan must record completed evidence: $internal_link_plan_contract" >&2
    exit 1
  fi
done

for heading_fragment_plan_contract in \
  "## Status: Completed" \
  "## Verification Completed" \
  "14 focused temporary-tree regressions" \
  "14 isolated heading-fragment mutations were rejected" \
  'Push run `27629257088`' \
  'pull-request run `27629271024`' \
  '`99e86701f69cfdfbe9c6134d5bcda5767ada2cea`' \
  "No external URL request"; do
  if ! grep -Fq "$heading_fragment_plan_contract" "$HEADING_FRAGMENT_PLAN"; then
    printf '%s\n' "Heading-fragment plan must record completed evidence: $heading_fragment_plan_contract" >&2
    exit 1
  fi
done

printf '%s\n' "fantastic-pancake content baseline checks passed."
