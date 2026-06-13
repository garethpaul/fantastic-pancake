# Source Provenance Boundary

status: completed

## Context

The guide pins several individual safety and substitution links, but the
baseline does not structurally reject newly added cleartext, credential-bearing,
or unreviewed external sources. Source provenance should fail closed as the
guide evolves.

## Requirements

- R1. Parse every absolute URL in `pancakes.md` with a structured URL parser.
- R2. Require HTTPS, a hostname, no username or password, and no explicit port.
- R3. Permit only the reviewed source hosts already used by the guide:
  `www.cdc.gov`, `www.fda.gov`, `www.foodsafety.gov`, and
  `extension.umn.edu`.
- R4. Require every reviewed host to remain represented so source breadth
  cannot silently collapse while individual phrase checks still pass.
- R5. Preserve all existing recipe, substitution, food-safety, and citation
  content.
- R6. Document the source boundary and add mutation-sensitive completed-plan
  evidence.

## Implementation Units

### U1. Structural URL Contract

**Files:** `scripts/check-baseline.sh`

Use Python's URL parser to extract absolute links from the canonical guide and
validate scheme, authority, userinfo, port, and exact host membership. Keep the
existing link-specific contracts as independent content evidence.

### U2. Guidance And Evidence

**Files:** `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`,
`docs/plans/2026-06-13-source-provenance-boundary.md`

Record the approved source classes without implying that offline checks prove
remote availability or ongoing editorial accuracy.

## Verification Plan

- Run `make lint`, `make test`, `make build`, and `make check`.
- Reject isolated HTTP, userinfo, explicit-port, unapproved-host, missing-host,
  malformed-authority, docs, plan-status, and evidence mutations.
- Run shell syntax, `git diff --check`, exact-path review, generated-artifact
  inspection, and added-line secret scanning.
- Use no network fetch as proof of source availability; hosted checks remain
  the authoritative execution evidence after push.

## Non-Goals

- Fetching remote pages, adding a link-check dependency, or claiming that a URL
  is currently reachable.
- Changing recipe quantities, culinary claims, safety advice, or cited pages.
- Expanding the allowlist beyond the current official government and university
  extension sources.

## Work Completed

- Added structured parsing for every absolute URL in `pancakes.md`.
- Required HTTPS, a hostname, absent userinfo and explicit ports, exact approved
  hosts, and continued representation of every reviewed host.
- Kept all existing exact citation and content checks as independent evidence.
- Documented the offline provenance boundary without claiming remote reachability.

## Verification Completed

- The all four Make gates passed the content baseline, along with shell syntax
  and `git diff --check`.
- Eleven isolated hostile mutations were rejected: HTTP, alternate scheme,
  username, explicit port, empty port delimiter, unapproved host, missing
  reviewed host, malformed authority, missing docs, stale plan status, and
  missing verification evidence.
- Exact intended-path review, generated-artifact inspection, and added-line
  secret-pattern scanning passed.
- No network fetch, remote-page availability claim, credential, or external
  service was used during verification.
