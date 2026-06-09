## Fantastic Pancake Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Fantastic Pancake is a lightweight repository about pancakes. It currently
contains a simple `pancakes.md` outline covering a basic method, pancake types,
tips, traditions, and creative ideas.

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
- The baseline rejects dependency manifests, lockfiles, source scaffolds, and
  generated dependency directories unless a new plan changes the repository
  scope.
- `pancakes.md` uses clean Markdown headings and enough specific bullets to
  avoid placeholder-only sections.
- Food-safety notes cite FoodSafety.gov before making storage or serving
  recommendations.
- README and VISION document the no-scaffold boundary until there is a concrete
  publishing need.
- Event-serving notes keep allergen labels, separate utensils, and
  allergen-free claims tied to official source guidance.

Next priorities:

- Expand `pancakes.md` with concise, useful sections
- Keep README and VISION aligned with any new content sections
- Decide whether this remains notes-only or becomes a small static page
- Add sources or attribution for factual culinary claims when needed
- Keep allergen and food-safety guidance reviewed when expanding event content

Contribution rules:

- One PR = one focused content or documentation change.
- Keep copy original and specific.
- Avoid large generated rewrites without review.
- Do not add a build system until there is a real publishing need.

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
