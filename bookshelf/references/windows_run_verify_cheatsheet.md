# Windows run/verify Cheatsheet

## TL;DR
- Prefer `run python ...` over shell-specific tricks.
- Keep commands simple; avoid complex quoting when possible.
- Verify execution with `verify: command ... | output_contains: ...`.

## Examples
- Run a script:
  `- [ ] Run | run python main.py | verify: command python main.py | output_contains: hello`

- Run module form (safer when packages exist):
  `- [ ] Run | run python -m mypkg | verify: command python -m mypkg | output_contains: hello`

- Create a venv (only if needed):
  `- [ ] Create venv | run python -m venv .venv | verify: dir_exists .venv`

## Notes
- Use forward slashes in Plan.md paths if you want; runner normalizes.
- Avoid PowerShell-specific syntax in `run` steps (keep it cross-shell).
