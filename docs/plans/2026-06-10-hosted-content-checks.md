# Hosted Content Checks

status: completed

## Context

The repository documented `make check` as its content and no-scaffold
contract, but only local contributors ran that command. Pull requests and
default-branch pushes had no hosted verification.

## Changes

- Added a least-privilege GitHub Actions workflow for pushes, pull requests,
  and manual runs.
- Pinned the checkout action by commit, disabled persisted checkout credentials,
  and bounded runs with cancellation and a five-minute timeout.
- Extended the local baseline and project documentation to keep hosted checks
  part of the repository contract.

## Verification

- `make check`
- Workflow YAML parse
- Hosted Ubuntu GitHub Actions run
