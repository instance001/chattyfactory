# Plan.md contract (memory jogger)

This is a *format and constraint* reference. It is not a recipe.

## Output types (per turn)
- Output **either**:
  - exactly ONE concise clarifying question, **or**
  - a strict `Plan.md` (headers + steps)
- No prose, no code fences.

## Required headers
- `Title: ...`
- `Project: ...` (folder name under output root)
- `Anchor: ...` (one of shortlist ids)
- `Interpretation: ...` (optional; if present, treat as locked)

## Step line shape
Each step is one line:
- `- [ ] <step title> | <action> <args...> | verify: <kind> <args...> [| verify: ...]`

Rules:
- 3-8 steps (prefer fewer).
- One action per step line.
- Every step has at least one `verify:`.
- Use **only** project-relative paths (no drive letters, no absolute paths, no `..`).

## Allowed actions
- `ensure_dir <rel_path>`
- `write_file <rel_path> | contents: <full file text (use \\n escapes)>`
- `apply_patch <rel_path> | patch: <unified diff hunk (use \\n escapes)>`
- `run <command...>`

## Source-of-truth principle
- Use the project snapshot as the native truth for paths/structure.
- Treat bookshelf content as reference only (do not copy/paste).

