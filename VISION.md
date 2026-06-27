## Fantastic Pancake Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)
Offline verification checks relative Markdown link, image, and heading-fragment targets without requesting external URLs.
Fenced Markdown examples close only with the matching marker and at least the opening fence length.
Raw HTML link and image destinations remain under the offline integrity gate.

Fantastic Pancake is a lightweight repository about pancakes. It currently
contains a simple `pancakes.md` outline covering a basic method, pancake types,
basic ratio, batch scaling, portioning, batter consistency, station setup, tips,
troubleshooting, traditions, mix-ins, toppings, and creative ideas.

The goal is to keep the repository as a small, readable content project rather
than adding unnecessary application scaffolding.

The current focus is:

Priority:

- Preserve the pancake content outline
- Keep edits plain Markdown and easy to review
- Avoid generated filler that does not improve the document
- Make future scope clear before adding code or site tooling

Current baseline:

- `scripts/check-baseline.sh` and `make check` verify the content-only
  repository shape.
- The content gate requires GNU Make, a POSIX shell, and Python 3. Its
  interpreter command is explicit and fails fast when missing or incompatible.
- The baseline rejects dependency manifests, lockfiles, source scaffolds, and
  generated dependency directories unless a new plan changes the repository
  scope.
- `pancakes.md` uses clean Markdown headings and enough specific bullets to
  avoid placeholder-only sections.
- Basic ratio notes provide a practical starting formula before variations.
- A batch scaling table keeps 8-, 16-, and 32-pancake quantities aligned with
  the basic ratio and recommends freshly mixed bowls for the largest service.
- Portioning and batch-size notes keep scoop sizes, spacing, and dry-mix prep
  practical for small or larger breakfasts.
- Batter consistency and resting notes describe texture cues, small
  adjustments, and avoiding overmixing after the batter rests.
- Cooking-station guidance keeps raw batter tools separate from cooked-pancake utensils.
- Griddle heat and doneness notes cover preheating, browning, flipping, and
  avoiding pressed pancakes.
- First-pancake calibration separates heat corrections from measured flour or
  milk adjustments before the main batch.
- Ingredient substitution notes distinguish milk, egg, flour, and fat behavior
  from allergen safety and require an about-8-pancake test batch before scaling.
- Troubleshooting notes cover common batch problems without adding app
  scaffolding.
- Mix-ins and toppings notes describe when to fold, sprinkle, dry, organize,
  and label additions without changing the content-only scope.
- Food-safety notes cite FoodSafety.gov before making storage or serving
  recommendations.
- The offline baseline structurally validates source URLs for HTTPS, absent
  credentials and ports, exact reviewed hosts, and continued host coverage.
- Batch storage and reheating guidance includes concrete holding, cooling,
  reheating, and leftover-use thresholds.
- README and VISION document the no-scaffold boundary until there is a concrete
  publishing need.
- Event-serving notes keep allergen labels, separate utensils, and
  allergen-free claims tied to official source guidance.
- `make lint`, `make test`, and `make build` run the same content baseline
  while no narrower gates are installed.
- GitHub Actions runs the local content baseline for pushes and pull requests
  without persisting checkout credentials.

Next priorities:

- Expand `pancakes.md` with concise, useful sections
- Keep README and VISION aligned with any new content sections
- Decide whether this remains notes-only or becomes a small static page
- Add sources or attribution for factual culinary claims when needed
- Keep allergen and food-safety guidance reviewed when expanding event content
- Keep batch storage guidance concise and source-backed
- Keep portioning guidance practical and tied to the basic ratio
- Keep batch scaling quantities aligned with the basic ratio and stated yield
- Keep batter texture notes practical and tied to the basic method
- Keep cooking-station setup ordered from raw batter to griddle to finished tray
- Keep first-pancake calibration ordered and limited to one variable per test
- Keep substitution guidance source-backed and separate recipe adaptation from
  allergen-free claims
- Keep mix-ins and topping guidance practical and tied to event-serving labels

Contribution rules:

- One PR = one focused content or documentation change.
- Keep copy original and specific.
- Avoid large generated rewrites without review.
- Do not add a build system until there is a real publishing need.
- Keep hosted checks aligned with `make check` without adding app tooling.

## Security And Responsible Use

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Recipes, food handling, or event information should be accurate and practical.
If future content includes safety-sensitive cooking guidance, include clear
temperatures, storage guidance, or sourcing as appropriate.

## What We Will Not Merge (For Now)

- App scaffolding without a publishing goal
- Unsourced bulk content dumps
- Generated images or assets without purpose and provenance
- Recipe or food-safety claims that are vague or misleading

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
