# Verify kinds (memory jogger)

Every step must include at least one verify.

Common verifies:
- `verify: exists <path>`
- `verify: dir_exists <dir>`
- `verify: contains <path> <needle>`
- `verify: not_contains <path> <needle>`
- `verify: regex <path> <pattern>`

Build/acceptance oriented:
- `verify: output_contains <text>` (aliases: `stdout_contains`)
- `verify: min_files <dir> <min>`
- `verify: glob_count <glob> <min> [max]`
- `verify: command <argv...>` (rare; `run` already creates a command verification)

Notes:
- Prefer verifying generated artifacts (`min_files` / `glob_count`) over checking exact filenames unless the plan created them deterministically.
- Avoid brittle output matching unless the user provided exact expected text.

