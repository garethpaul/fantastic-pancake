# AGENTS.md

## Repository purpose

`garethpaul/fantastic-pancake` is a content-only collection of practical
pancake notes covering preparation, troubleshooting, serving, allergens, and
food safety. It intentionally has no application or dependency scaffold.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- The content gate requires GNU Make, a POSIX shell, and Python 3. Override the
  interpreter command with `make PYTHON=/path/to/python3 check` when needed.
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Follow the existing file layout and naming used by the checked-in sample.

## Testing guidance

- No dedicated test files were detected; treat `make check` as the minimum baseline.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.
- The scan did not identify production authentication, payment, or secret-management code. Treat future additions in those areas as security-sensitive.
- Food-safety guidance should cite official sources and avoid vague storage or serving claims.
- Allergen guidance should stay tied to official sources and should not promise allergen-free preparation without controlled ingredients and surfaces.
- Raw flour, eggs, and batter must be described as potentially unsafe to taste before cooking; cleanup guidance should remain tied to FDA and CDC sources.
- Preserve concrete time and temperature thresholds for storage, event holding, and reheating, and update their official sources when guidance changes.
- Run `make check` before pushing content or documentation changes.
- Keep the no-scaffold contract in place until there is a concrete publishing plan for an app or static site.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
