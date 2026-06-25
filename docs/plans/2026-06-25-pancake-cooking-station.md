# Pancake Cooking Station

## Status: Completed

## Problem

The guide explained batter, griddle heat, first-pancake calibration, and batch
holding, but it did not connect those steps into a repeatable physical station.
Readers still had to infer which tools to stage, how much griddle space to
leave, where cooked pancakes should land, and how to keep a cooked-food utensil
away from raw batter surfaces.

## Decision

Add one concise section between batter preparation and pancake types. It stages
the existing 1/4 cup portion, light grease, a thin spatula, and a landing tray;
keeps pancakes uncrowded; establishes a one-way raw-to-cooked workflow; reserves
a clean cooked-food utensil; and uses a rack over a sheet pan for a brief wait.

This preserves the content-only scope and supports the existing raw-batter,
griddle, calibration, holding, and event-serving sections without adding a new
recipe or repeating their detailed instructions.

## Work Completed

- Added `## Cooking Station Setup` with five specific workflow bullets.
- Extended the baseline with heading and content-fragment contracts.
- Updated repository, security, roadmap, contributor, and timestamped change
  guidance.

## Verification

- The pre-change baseline failed on the missing station heading.
- `sh scripts/check-baseline.sh` passed after implementation.
- Repository-root and external-directory `make check` passed.
- Three hostile cooking-station mutations were rejected: removing the clean
  utensil boundary, removing the one-way workflow, and replacing the measured
  1/4 cup station setup.
- Isolated hostile cooking-station mutations were rejected without changing
  recipe ratios, food-safety sources, allergen guidance, or repository shape.
- No kitchen or live cooking test was performed; the change is content and
  offline verification only.

## Scope Boundaries

- No ingredient ratio, cooking temperature, food-storage threshold, allergen
  claim, or external source URL changed.
- No site, application, dependency manifest, or generated scaffold was added.
