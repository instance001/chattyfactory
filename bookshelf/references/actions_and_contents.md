# Actions + contents rules (memory jogger)

Goal: keep steps deterministic and patch-first.

## `ensure_dir <rel_path>`
- Use before writing files into new folders.
- Prefer minimal directory creation; respect snapshot.

## `write_file <rel_path> | contents: ...`
- `contents:` must be the **entire** file (no TODOs, no placeholders).
- In prompt-encoded text, newlines must be `\\n`.
- Do not include Plan.md headers, code fences, or assistant prose inside `contents:`.

## `apply_patch <rel_path> | patch: ...`
- Target must already exist (and be in snapshot) unless created earlier via `write_file`.
- Patch is a unified diff hunk. Keep it small.
- If a patch touches 0 lines, regenerate a better hunk or rewrite the file.

## `run <command...>`
- Must be a real command (no absolute paths).
- Prefer commands that produce observable behavior for acceptance.

## Anti-stub rule
- Avoid "demo" or wrapper output in code files (no `Title:`, no ``` fences, no "Sure, ...").

