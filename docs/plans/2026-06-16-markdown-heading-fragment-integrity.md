# Markdown Heading Fragment Integrity

## Status: Completed

## Summary

Extend the dependency-free offline Markdown link checker so local links with
fragments fail when the referenced GitHub-style heading or explicit custom
anchor does not exist. Preserve the current filesystem, repository-boundary,
code-span, fence, reference-link, and external-network behavior.

## Problem Frame

The current checker proves that a relative Markdown target file exists but
intentionally ignores its URL fragment. Links such as
`pancakes.md#missing-section` therefore pass even though GitHub renders them as
broken navigation. The repository now has enough maintained Markdown that
heading renames and duplicate-heading reorderings should be caught offline.

## Prioritized Engineering Tasks

1. **P0: Validate local Markdown fragments.** Reject same-document and
   cross-document links whose decoded fragment is absent from the target
   Markdown document.
2. **P1: Match GitHub's documented basic anchor rules.** Cover lowercase
   conversion, space-to-hyphen conversion, punctuation and formatting removal,
   duplicate-anchor numeric suffixes, and explicit HTML custom anchors.
3. **P2 follow-up: Broader Markdown rendering fidelity.** Defer multiline link
   syntax, generated HTML IDs outside explicit anchors, and external URL health
   until a concrete repository failure requires a fuller parser.

## Requirements

- **R1:** Existing relative path validation must continue to reject missing and
  repository-escaping targets before fragment validation.
- **R2:** A fragment on a local Markdown link must resolve against the target
  file's generated heading anchors or explicit `<a name="...">` anchors.
- **R3:** Same-document fragments must be validated against the source document
  instead of being skipped.
- **R4:** Anchor extraction must ignore fenced code and support ATX headings,
  HTML comments, setext headings, inline Markdown formatting removal,
  percent-decoded fragments, and deterministic duplicate suffixes.
- **R5:** Fragments on non-Markdown local targets and absolute external links
  must remain outside the heading-anchor gate.
- **R6:** Focused tests, the baseline contract, maintained guidance, and this
  plan must make anchor-validation regressions mutation-sensitive.

## Key Technical Decisions

- **Use a dependency-free document index:** the repository intentionally has no
  package scaffold, and the existing checker already owns offline Markdown
  structure validation.
- **Implement GitHub's documented basic heading rules, not a general renderer:**
  this covers the repository's maintained Markdown without introducing a
  dependency or claiming complete CommonMark rendering fidelity.
- **Index each Markdown target once per validation run:** cross-document links
  should reuse extracted anchors rather than reparsing the same file for every
  link.
- **Validate explicit custom anchors separately from generated headings:**
  custom anchors participate in navigation but do not alter duplicate-heading
  numbering.

## Scope Boundaries

### In Scope

- Local inline and reference links with same-file or cross-file fragments.
- ATX and setext heading anchors, duplicate suffixes, inline formatting, custom
  anchors, and percent-decoded fragments.
- Focused temporary-tree tests, baseline mutation contracts, and synchronized
  repository guidance.

### Deferred to Follow-Up Work

- External URL availability, browser rendering, multiline Markdown links,
  arbitrary raw-HTML element IDs, generated SVG changes, recipe wording, and
  food-safety guidance.

## Implementation Units

### U1. Build the Markdown anchor index

**Goal:** Derive the navigable anchors for each maintained Markdown document.

**Requirements:** R2, R4

**Dependencies:** None

**Files:**

- `scripts/check-internal-links.py`
- `scripts/test-internal-links.py`

**Approach:** Add small parsing helpers that reuse the existing fence and
inline-code boundaries, extract ATX and setext heading text, normalize it using
GitHub's documented basic rules, assign stable duplicate suffixes in document
order, and collect explicit custom anchor names without affecting heading
numbering. Cache the resulting anchor set by resolved Markdown path.

**Execution note:** Start with failing focused tests for normalization,
duplicates, setext headings, fenced examples, and custom anchors before changing
the checker.

**Patterns to follow:** Existing dependency-free temporary-tree tests and
line-oriented fence suppression in `scripts/check-internal-links.py`.

**Test scenarios:**

- A heading `## Basic Pancake Method` produces `basic-pancake-method`.
- Inline emphasis and punctuation are removed while Unicode letters remain.
- Repeated identical headings produce the base anchor, then `-1`, then `-2`.
- A natural heading ending in `-1` cannot collide with a suffix already assigned
  to an earlier duplicate; every generated anchor remains unique in document
  order.
- Setext headings are indexed; heading-like text inside a fence is ignored.
- `<a name="serving-note"></a>` resolves without changing duplicate heading
  suffixes.

**Verification:** Focused tests prove the extracted anchor set and ordering for
each scenario without network access.

### U2. Enforce local fragment resolution

**Goal:** Reject broken local Markdown navigation while preserving current path
and external-link behavior.

**Requirements:** R1, R2, R3, R5

**Dependencies:** U1

**Files:**

- `scripts/check-internal-links.py`
- `scripts/test-internal-links.py`

**Approach:** After a local target passes repository-boundary and existence
checks, validate its decoded fragment only when the resolved target is a
Markdown file. Resolve an empty path to the source document, report the source
line and original destination for missing anchors, and leave non-Markdown
fragments and external schemes unchanged.

**Test scenarios:**

- Existing same-document and cross-document heading fragments pass.
- A missing same-document fragment and a missing cross-document fragment each
  produce one anchor-specific failure at the source line.
- A percent-encoded fragment resolves to the generated anchor.
- Query strings do not affect target or fragment resolution.
- An SVG fragment and an HTTPS link remain outside Markdown heading validation.
- Missing and repository-escaping files retain their existing failure messages
  without an additional anchor error.

**Verification:** The focused suite distinguishes file-target failures from
fragment-target failures and preserves all existing regressions.

### U3. Integrate mutation-sensitive evidence and guidance

**Goal:** Make the new boundary durable in the full repository gate.

**Requirements:** R6

**Dependencies:** U1, U2

**Files:**

- `scripts/check-baseline.sh`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `docs/plans/2026-06-16-markdown-heading-fragment-integrity.md`

**Approach:** Extend the static baseline contract with the new anchor failure,
focused test, guidance, and completed-plan evidence. Update maintained guidance
to state that offline verification covers local Markdown heading fragments
without requesting external URLs.

**Test scenarios:**

- Removing heading-fragment validation fails the baseline.
- Removing duplicate-heading coverage, same-document coverage, or the completed
  plan evidence fails the baseline.
- Repository-root and external-directory verification both exercise the same
  checker and tests.

**Verification:** Focused mutations are rejected, all Make targets pass, and
the plan records the exact validation actually completed.

## Risks And Dependencies

- GitHub documents basic anchor-generation rules but its renderer has broader
  Markdown behavior; the implementation must avoid claiming unsupported parser
  fidelity.
- Duplicate suffixes are order-sensitive, so heading extraction must preserve
  document order and ignore fenced examples.
- The checker must not turn external availability into a build dependency.

## Work Completed

- Added a cached, dependency-free anchor index for ATX and setext headings,
  GitHub-style basic slug normalization, deterministic collision suffixes, and
  explicit custom anchors.
- Extended local link validation to check decoded same-document and
  cross-document Markdown fragments only after existing path safety and target
  existence checks pass.
- Added focused coverage for valid and missing fragments, duplicate collisions,
  formatting, setext headings, fenced examples, custom anchors, percent
  decoding, HTML comments and inline-code comment markers, and non-Markdown
  fragment preservation.
- Integrated heading-fragment contracts and synchronized guidance into the
  maintained offline baseline.

## Verification Completed

- `python3 scripts/test-internal-links.py` passed 14 focused temporary-tree regressions.
- `python3 scripts/check-internal-links.py .` passed all maintained Markdown.
- 14 isolated heading-fragment mutations were rejected across fragment gating,
  duplicate allocation, setext parsing, fence suppression, custom anchors,
  inline formatting, percent decoding, HTML-comment suppression, inline-code
  comment markers and custom-anchor examples, checker and test registration,
  maintained guidance, and completed-plan evidence.
- `sh -n scripts/check-baseline.sh` and Python compilation passed.
- `make check`, `make lint`, `make test`, and `make build` passed from the
  repository root, and the absolute Makefile `check` target passed from an
  external working directory.
- Push run `27629257088` and pull-request run `27629271024` passed at
  implementation commit `99e86701f69cfdfbe9c6134d5bcda5767ada2cea`.
- No external URL request, browser rendering, recipe execution, generated SVG
  refresh, or food-safety wording change was performed.

## Sources And Research

- GitHub Docs, "Basic writing and formatting syntax," sections on heading,
  section-link, relative-link, and custom-anchor behavior:
  <https://docs.github.com/en/enterprise-cloud@latest/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax>
- Existing implementation and regressions in `scripts/check-internal-links.py`
  and `scripts/test-internal-links.py`.
- Deferred heading-anchor boundary in
  `docs/plans/2026-06-16-offline-internal-link-integrity.md`.
