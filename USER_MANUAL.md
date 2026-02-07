# ChattyFactory User Manual (Zero-Assumed Knowledge)

This manual assumes you're starting from scratch and want a local AI partner that can help you build working projects in small, verifiable steps.

License note: ChattyFactory is GNU AGPLv3 (see `LICENSE`). This manual is not legal advice.

## 1) What ChattyFactory does (in one paragraph)

You type a plain-English request. ChattyFactory picks a starting point ("anchor"), asks a small number of clarifying questions if needed, then writes a strict `Plan.md`. When you confirm, that plan is compiled into a deterministic work order and executed step-by-step with verification checks.

## 2) Requirements

You need:
- Windows 10/11
- Rust toolchain installed (so `cargo` works)
- A local GGUF model file (stored on your machine)
- A local `llama.cpp` backend binary (`llama-cli.exe`) in `runtime/bin/windows/` (see `runtime/bin/windows/README.md`)

Notes:
- ChattyFactory is designed for **local** models. No network calls are required.
- In the GUI there are policy toggles (network/delete/external paths). Keep defaults unless you know why.

## 3) Install / run

From a terminal (PowerShell):
```powershell
cd C:\Users\User\Desktop\chattyfactory
cargo run -p chattyfactory_gui
```

If you want a faster binary:
```powershell
cargo run -p chattyfactory_gui --release
```

## 4) Add a model

1) Put your `.gguf` file in `models/`.
2) In the app, click **Rescan models**.
3) Select your model in the model dropdown.

If nothing shows up:
- Confirm the file ends with `.gguf`.
- Confirm it is inside `models/` under the ChattyFactory folder.

## 5) The UI (what you're looking at)

- **Chat panel**: your request + the assistant's questions/outputs (condensed).
- **Output explorer**: projects created under the current output root.
- **Active project**: the folder ChattyFactory will patch when you're in "modify an existing project" mode.
- Buttons:
  - **Confirm plan**: keeps the plan for review/editing (no execution).
  - **Confirm & Run**: freezes the plan context and executes.
  - **Cancel**: cancels the current job.
  - **Details**: diagnostics (plan lint, journal, metrics, policies, output root).

## 6) The core workflow (recommended)

### Step A: Make a request

Good example:
- "Build a simple hello world CLI in python that prints hello world"

Bad example:
- "Make something cool"

### Step B: Narrowing (anchor + interpretation)

ChattyFactory tries to choose an anchor and will ask small questions if needed.
While narrowing:
- The anchor should always be concrete (defaults to `python_cli` if needed).
- The assistant also produces an **Interpretation** (a short statement of what it thinks you want).
- If the Interpretation changes, the assistant should surface it so you can correct it early.

### Step C: Planning (Plan.md)

The assistant writes a strict `Plan.md` (or step lines) that transforms the anchor into the interpretation.

### Step D: Confirm (Freeze checkpoint)

When you click **Confirm plan** or **Confirm & Run**, ChattyFactory:
- freezes `Anchor:` + `Interpretation:` for this job (receipts),
- copies them into the working `Plan.md`,
- enforces: do not change `Anchor:` / `Interpretation:`; only change steps.

Receipt files:
- `runtime/plans/<job_id>.anchor_context.md` (frozen on confirm)
- `runtime/plans/<job_id>.scratch.md` (conversation + receipts)

### Step E: Run (deterministic execution)

When you click **Confirm & Run**, ChattyFactory compiles the plan and runs it with verification.

Your project output is created under:
- `output/<Project>/`

## 7) Plan.md format (must be strict)

Plan.md is plain text with headers + checklist step lines.

Headers:
- `Title: ...`
- `Project: ...` (folder name under `output/`)
- `Anchor: ...` (must match a shortlist id)
- `Interpretation: ...` (optional; if present, treat as locked)

Each step is one line:
`- [ ] Step title | action args... | verify: ...`

Supported actions:
- `instantiate_template <anchor_id> .`
- `ensure_dir <rel_path>`
- `write_file <rel_path> | contents: ...`
- `apply_patch <rel_path> | patch: ...`
- `run <command...>`

Common verifications:
- `verify: exists <path>`
- `verify: dir_exists <path>`
- `verify: contains <path> <needle>`
- `verify: command <argv...> | output_contains: <needle>`

Important rules:
- Paths are **relative** to the project root (do not prefix with the project folder name).
- Every step needs at least one `verify:`.
- Do not invent actions like `modify_file` or `edit_file`.

Tool-like references live in `bookshelf/references/` and are also injected into "Bookshelf hints".

## 8) Tips: how to talk to the LLM (to get reliable results)

### Write requests as constraints, not vibes
Prefer:
- "Build X, must do Y, must not do Z"

Example:
- "Create a python CLI that prints 'hello world' and supports an optional name arg."

### One main goal per request
If you want multiple features, do them in multiple runs:
1) get a minimal working version,
2) then patch in extras.

### Confirm interpretation early
If the assistant says:
- "Do you mean: <Interpretation>?"

Answer with:
- "Yes, exactly."
or
- "No. I mean: <your corrected interpretation>."

### If the model asks vague questions, answer with a choice
Example:
- Q: "Any extra features?"
- A: "No extras. Just print hello world."

### If the model gets stuck, use deterministic escape hatches
- Edit the `Plan.md` yourself in Details and then Confirm & Run.
- Or click Confirm & Run and let bounded Recovery mode try patch steps.

## 9) Recovery mode (bounded fallback)

Recovery mode triggers only on hard failures (plan invalid / unable to auto-plan).
In recovery mode:
- The model must not ask questions.
- It outputs only step lines (3-8) per cycle.
- The system runs bounded cycles and stops.

Use recovery mode when:
- a small model cannot reliably produce strict Plan.md,
- you want forward progress without more Q&A.

## 10) Using / patching an existing project

There is an "Active project" in the UI:
- If you select a folder in Output explorer and set it active, future requests can patch it.
- Click "Clear project" to reset to no active project.

Guidelines:
- Say explicitly: "Patch the active project to add X" (so the model doesn't start a new one).
- Keep changes small and verifiable.

## 11) Where to find logs and receipts

- Work orders: `runtime/work_orders/`
- Plans: `runtime/plans/`
- Run logs: `runtime/runs/`
- Journals: `runtime/journal/`
- Bookshelf: `bookshelf/` (good/bad plans/builds + references)

Open **Details** -> Journal / Diagnostics for quick access.

## 12) Common problems

### "Plan invalid"
Fixes:
- Ensure Title/Project/Anchor headers exist.
- Ensure 3-8 steps exist.
- Ensure every step has a `verify:`.
- Remove invented actions (use `apply_patch`).

### "Anchor selected deterministically -> egui_app" when you wanted CLI
Say:
- "CLI, no GUI" or "terminal-only"
and/or:
- "python (recommended)".

### "Context overflow"
Keep requests shorter and do smaller runs. Avoid pasting long code blobs into chat; patch gradually.
