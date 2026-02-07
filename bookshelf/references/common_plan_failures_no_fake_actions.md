# Common Plan.md Failures (and Fixes)

## TL;DR
- If the plan fails, fix ONE step per revision (don’t rewrite everything).
- Never invent actions like `modify_file` / `verify` (action).
- Don’t prefix paths with the project folder name.
- Ensure at least 3 steps and at most 8.

## Common failures
- Missing headers: must have `Title:`, `Project:`, `Anchor:`.
- Steps missing `verify:`.
- Placeholder tokens leaking: `REL_PATH`, `<title>`, `<project>`, etc.
- Wrong action: use `apply_patch` instead of made-up edit actions.

## Fix pattern
- Add a missing verify: `| verify: exists <path>`
- Replace invented action with `apply_patch <path> | patch: ...`
