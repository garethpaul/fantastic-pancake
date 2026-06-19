---
title: Canonical FDA Allergen Source
type: security
date: 2026-06-14
status: completed
execution: code
---

# Canonical FDA Allergen Source

## Summary

Replace the redirected FDA food-allergy citation with its current canonical
HTTPS location and make the content baseline reject restoration of the retired
path.

## Problem Frame

The substitution guidance links to an official FDA page through an obsolete
path that now redirects to a different canonical location. Redirects can hide
source drift and make future content review less reliable even when the target
guidance remains authoritative.

## Requirements

- **R1.** `pancakes.md` must cite the current canonical FDA food-allergy URL.
- **R2.** The content baseline must require the canonical URL and reject the
  retired redirecting path.
- **R3.** Existing allergen, cross-contact, and substitution guidance must
  remain unchanged in meaning.
- **R4.** The completed plan and change record must capture the source review
  and its verification evidence.

## Key Technical Decisions

- **Pin the canonical HTTPS page:** the FDA page remains the authoritative
  source, so only its redirecting path changes.
- **Use positive and negative static contracts:** requiring the canonical URL
  alone would not prevent both URLs from coexisting after a future edit.
- **Keep network access outside `make check`:** hosted and local verification
  stays deterministic while source freshness remains an explicit maintenance
  review responsibility.

## Assumptions

- The FDA canonical path observed on 2026-06-14 is the maintained replacement
  for the retired citation path.
- No prose change is needed because the source still supports label review and
  cross-contact guidance.

## Scope Boundaries

- Do not revise recipe ratios, substitution recommendations, or event-serving
  guidance.
- Do not add a general-purpose network link checker to the deterministic gate.
- Do not introduce an application, package dependency, or publishing scaffold.

## Implementation Units

### U1. Canonicalize the FDA citation

**Goal:** Point substitution guidance directly at the maintained FDA page.

**Requirements:** R1, R3

**Dependencies:** None

**Files:** `pancakes.md`, `CHANGES.md`

**Approach:** Replace only the obsolete FDA path and record the source
maintenance change without altering the surrounding safety claims.

**Test scenarios:**

- The canonical FDA URL appears once in the substitution source list.
- The retired FDA URL no longer appears in tracked content.
- Existing allergen and cross-contact sentences remain present.

**Verification:** Exact diff review shows a source-only content change plus its
change-log entry.

### U2. Enforce canonical source provenance

**Goal:** Make future source drift fail the existing content baseline.

**Requirements:** R2, R4

**Dependencies:** U1

**Files:** `scripts/check-baseline.sh`,
`docs/plans/2026-06-14-002-security-canonical-fda-allergen-source-plan.md`

**Approach:** Require the canonical URL in the substitution contract, reject
the retired path anywhere in tracked Markdown content, and require completed
plan verification evidence.

**Test scenarios:**

- The unchanged repository passes `make check` from the repository root and an
  external working directory.
- Replacing the canonical URL with the retired path fails the baseline.
- Adding the retired path beside the canonical URL fails the baseline.
- Reopening the completed plan or removing its verification evidence fails the
  baseline.

**Verification:** Focused static checks, the full content gate, and isolated
hostile mutations all reject weakened source provenance.

## Risks And Dependencies

- The FDA may move the page again; future source review must update the content,
  contract, and evidence together.
- A deterministic static gate proves repository provenance, not live network
  availability.

## Sources And Research

- FDA, "Food Allergies," current canonical page observed 2026-06-14:
  https://www.fda.gov/food/nutrition-food-labeling-and-critical-foods/food-allergies
- The prior FDA food-labeling path redirected to the canonical page during the
  same review and is intentionally omitted from tracked Markdown content.

## Verification

- The canonical FDA page and its current label and cross-contact guidance were
  reviewed on 2026-06-14 before implementation.
- `make check` passed from the repository root and an external working
  directory through the absolute Makefile path.
- Four isolated hostile mutations were rejected for canonical-link removal,
  retired-link coexistence, plan reopening, and source-review evidence removal.
- Shell syntax, all four Make gates, exact diff review, and final artifact and
  secret audits passed before delivery.
