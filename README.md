# ChattyFactory

ChattyFactory is a local-first project factory for small GGUF models. The goal is simple: plain-language request in, working local project out, then one plain-language patch request at a time until the user is happy.

It is designed to work with small/local LLMs by:
- pooling unspecific requests onto the easiest build path likely to succeed locally,
- splitting work into tiny roles instead of asking one model call to hold the whole project,
- using host-assembled, verifiable project seeds before broad `Plan.md` drafting when possible,
- treating follow-up requests as bounded patches to the active project,
- journaling fallback gaps so the next missing atomized family is obvious.

License: **GNU AGPLv3** (see `LICENSE`).

## ChattyCog module (plug-in) notes

This folder is also packaged as a ChattyCog module (it contains `manifest.json`).

- In ChattyCog: **Modules -> Rescan modules -> Open: ChattyFactory**
- Use the module tab for short "department status" notes.
- When you switch away from the tab, ChattyCog logs your rundown into cold memory.

## Quick start (Windows)

Prereqs:
- Rust toolchain (stable) installed (`rustc`, `cargo`).
- A local GGUF model file (place it under `models/`).

Runtime note (when used as a ChattyCog module):
- If ChattyCog's runtime exists at `chattycog_gui/runtime/windows/`, ChattyFactory auto-detects and uses it.
- To force the bundled runtime instead: set `CF_RUNTIME_MODE=local`.

Run:
```powershell
# If you are inside the ChattyCog repo:
cd chattycog_gui\modules\chattyfactory

# (If you have ChattyFactory as a standalone repo elsewhere, cd into that folder instead.)
cargo run -p chattyfactory_gui
```

In the app:
1) Pick an **Overseer** model and a **Builder** model (they can be the same), or click "Rescan models".
   - Overseer: clarifies + restates what you're trying to build (Interpretation).
   - Builder: writes strict `Plan.md` steps (and bounded recovery patch steps).
2) Type a request.
   Best current shape for local models:
   - "build me a simple inventory dashboard"
   - "build a browser timer app"
   - "make a small invoice tool"
3) For clear new-project requests, ChattyFactory now prefers a direct path:
   - `scratch`
   - `PROJECT_BLUEPRINT`
   - atomized project seed if available
   - auto-run after validation gates
4) For follow-up requests, select an output project and ask for the next change:
   - "add CSV export"
   - "add dark mode"
   - "add filtering"
5) Use **Confirm plan** when you want to inspect/edit a broad `Plan.md` draft. Host-assembled direct plans can auto-run without an extra confirm click.

Outputs land under:
- `output/` (your built projects)
- `runtime/` (plans, work orders, logs, journals)
- `bookshelf/` (reference material + past good/bad plans/builds)

## What is an anchor?

An anchor is an existing output project directory (or a scratch starting point) that the plan will *transform*.
Anchors are starting points, not end states.

Default posture:
- Prefer the easiest local path unless the user explicitly asks for a stack.
- Generic GUI / browser-natural / interactive tool requests tend to pool to static web.
- Prefer bounded patches and one supporting file over broad rewrites.

Current atomized fresh-build families:
- Python CLI
- Python tkinter dashboard
- Static web (`index.html`)
- Rust CLI
- Node/JavaScript CLI

## Role atomization

ChattyFactory does not ask a small local model to hold an entire project in one call unless it has to.
Instead, it breaks building and patching into narrow roles with tiny contracts, then lets the host assemble and verify the result.

That is the core local-GGUF strategy:
- one small job per model call,
- deterministic host assembly where possible,
- concrete acceptance after each meaningful change.

Current atomized roles at a glance:
- `PROJECT_BLUEPRINT`: choose the simplest project shape (`html`, `python`, `rust`, `node`, `cli`, `web`, `gui`, entrypoint).
- `CODE_FILE`: write one complete file only, raw source only.
- `PATCH_TARGET`: choose one existing file to patch from a candidate list.
- `PATCH_INTENT`: describe the patch in a tiny structured form.
- `PATCH_FILE`: write one unified diff hunk for one file when hunk mode is still appropriate.
- `PATCH_ACCEPTANCE`: describe how to verify the requested patch landed.
- `RECOVERY`: emit only bounded step lines when planning/execution needs a repair cycle.
- `BUILD_REPAIR`: produce repair-only steps for a specific failed run step.
- `RECOVERY_DONE`: answer only `DONE` or `MORE` after a repair cycle.
- `CLARIFY`: ask one useful question or produce a BuildSpec when clarification is still needed.
- `BUILD_SPEC`: write a technical BuildSpec for human/model handoff, not implementation code.

Host-owned deterministic pieces:
- `ProjectSpec.json`: machine contract for later patching
- `COCKPIT_PROTOCOL.md`: orientation layer for humans/models entering the workspace
- acceptance commands/checks
- exoskeleton compatibility wrappers (`ChattyCog`, `ChattyEdu`) when selected
- `contents_b64:` plan payloads so normal code is not broken by plan separators

## Repo layout

- `chattyfactory_core/` deterministic compiler + runner (no interactive behavior)
- `chattyfactory_gui/` GUI orchestration + LLM prompting + safety scaffolding
- `bookshelf/` reference cards + recorded good/bad plans/builds + index
- `models/` local GGUF models (not checked in)
- `output/` generated projects (runtime output root)
- `runtime/` plans, receipts, logs, journals, work orders

## Key concepts

- **Plan.md**: Markdown source-of-truth plan format (strict headers + checklist step lines).
- **Project blueprint**: a tiny model call that picks the simplest project shape likely to satisfy the request (`python`, `html`, `rust`, `node`, `cli`, `web`, `gui`, etc.).
- **Atomized family**: a bounded host-supported build path where the model writes one concrete file and the host assembles the rest of the plan deterministically.
- **Role atomization**: splitting the build/patch process into tiny model roles like blueprint, code writer, patch target picker, patch intent, and bounded repair.
- **Overseer vs Builder**: the chat interface is for producing an order (Plan.md), not the product itself.
- **Freeze checkpoint**: On confirm, the chosen `Anchor:` and `Interpretation:` are frozen in
  `runtime/plans/<job_id>.anchor_context.md` and enforced in the working `Plan.md`.
- **Project snapshot (X-ray)**: a deterministic, depth-limited scan of the selected anchor
  (or active project) used to ground planning and prevent hallucinated paths. Written to:
  - `runtime/plans/<job_id>.project_snapshot.md`
  - `runtime/plans/<job_id>.project_snapshot.json`
- **Snapshot gate**: before compile/run (and during repair loops), Plan.md is checked so file paths
  referenced by `write_file` / `apply_patch` / `run` / `verify:` are either:
  - present in the project snapshot, or
  - created earlier in the plan (e.g. `ensure_dir` before `write_file`).
- **Deterministic runner**: Executes compiled work orders and verifies outcomes.
- **Recovery mode**: Bounded, no-questions fallback that emits 3-8 patch steps per cycle.
- **Project contract**: `output/<project>/ProjectSpec.json` stores entrypoints, acceptance commands, key files, and current request context so later patch requests stay grounded.
- **Cockpit protocol**: `output/<project>/COCKPIT_PROTOCOL.md` gives a generic orientation layer for humans/models entering the built workspace.
- **Journal gap tracking**: `runtime/journal/distilled_metrics.*` shows broad fallback counts and the top atomized gaps still causing entropy.

## Troubleshooting (fast)

- If you see "Plan invalid": open Details -> "Plan lint" and fix missing headers, missing verify, or unknown actions.
- If the model invents actions like `modify_file`: use `apply_patch` instead (see `bookshelf/references/`).
- If you see "Plan invalid (snapshot gate)": the plan referenced paths/commands that are not grounded in the
  project snapshot (common causes: `/src/...`, absolute paths like `C:/...`, or patching a file before it exists).
- If the assistant is asking a question (Status says "awaiting your answer") and you want to answer it, type an answer and press **Send**.
- If you want to skip the remaining Q&A and proceed with best-effort defaults, press **Confirm & Run** (it freezes and runs instead of continuing the conversation).
- If output looks truncated in chat: open Details -> Journal / Scratch for full text.
- For manual translation/localization: put `.md`/`.txt` files in `output/manuals/source/` (auto-created on first translation run) and ask "translate manuals to Spanish".

For full documentation, see `USER_MANUAL.md` and `RELIABILITY.md`.
