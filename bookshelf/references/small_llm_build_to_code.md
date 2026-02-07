# Small Local LLM: Build-To-Code Playbook (Patch-First)

This is a compact reference for small local/open models. Goal: produce deterministic, verifiable changes by **patching an existing shape** (template/anchor) instead of generating a whole project from scratch.

## Default posture
- Anchors are **starting points**; the output is always a **transformation plan** from the anchor to the requested result.
- Prefer **minimal diffs** over rewrites.
- Prefer **existing anchor templates**; if unsure, ask one clarifying question.
- Never invent file paths; use `Project:` as the root and keep paths relative.
- Always include at least one verification check per step (exists/contains/command).

## Anchor selection (quick heuristic)
- If the request mentions "GUI", "window", "egui", "buttons", "layout" -> `egui_app`
- If the request mentions "CLI", "terminal", "args", "stdout", "subcommand" -> `rust_cli`
- If ambiguous, ask: "Do you want a GUI app (egui) or a CLI tool?"

## Plan shape (Plan.md)
Headers:
- `Title:` human title
- `Project:` short safe name (letters/numbers/underscores)
- `Anchor:` one of shortlist ids

Steps:
- One step per line: `- [ ] <title> | <action> <args> | verify: <check> ...`
- Actions should be small + deterministic. Prefer: `ensure_dir`, `write_file`, `apply_patch`, `run`.
- Verification examples:
  - `verify: exists <path>`
  - `verify: contains <path> <needle>`
  - `verify: command cargo test`

## Patch-first workflow
1) Ensure dirs exist (project root, src, assets if needed)
2) Patch the smallest file that proves the feature (often `src/main.rs`)
3) Add a single verification artifact (a string in stdout, a UI label, a test)
4) Build/test (`cargo check` / `cargo test`) as a final step

## Common failure modes (avoid)
- Placeholder tokens: `REL_PATH`, `<Step 1 title>`, `<anchor-id>` leaking into Plan.md.
- Multiple unrelated goals in one step.
- Missing verify directives (plan validation will fail later).
- Changing the anchor id after selection (must match shortlist).

## Good "hello world" targets
- CLI: print a unique string; verify `contains` in `src/main.rs`; run `cargo test` or `cargo check`.
- egui: show a label with a unique string; verify `contains` in `src/main.rs`; run `cargo check`.
