# Plan.md Action Cookbook (Small-Model Friendly)

## TL;DR
- Output TEXT ONLY. No JSON. No code fences.
- Keep 3-6 steps (max 8). One action per step.
- Supported actions: instantiate_template, ensure_dir, write_file, apply_patch, run.
- Every step MUST include at least one `verify:`.
- Paths are RELATIVE to the project root (no absolute paths; no project folder prefix).

## Step line format
`- [ ] <title> | <action> <args...> | verify: <check> [<more checks>]`

## Supported actions (examples)
- Instantiate template (when Anchor is a template):
  `- [ ] Scaffold from anchor | instantiate_template python_cli . | verify: dir_exists .`
- Ensure directory:
  `- [ ] Make src | ensure_dir src | verify: dir_exists src`
- Write file (must include contents:):
  `- [ ] Write main | write_file main.py | contents: print("hello")
 | verify: contains main.py hello`
- Apply patch (must include patch: unified diff):
  `- [ ] Patch main | apply_patch main.py | patch: @@
- old
+ new
 | verify: contains main.py new`
- Run command:
  `- [ ] Run app | run python main.py | verify: command python main.py | output_contains: hello`

## Verify checks (common)
- `verify: exists <path>`
- `verify: dir_exists <path>`
- `verify: contains <path> <needle>`
- `verify: command <argv...> | output_contains: <needle>`

## Don’ts
- Do NOT use unknown actions like `modify_file`, `edit_file`, `verify` (as an action).
- Do NOT use placeholder tokens like `REL_PATH` or `<anchor-id>`.
