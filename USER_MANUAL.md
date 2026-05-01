# ChattyFactory User Manual (Zero-Assumed Knowledge)

This manual assumes you're starting from scratch and want a local AI partner that can help you build working projects in small, verifiable steps.

License note: ChattyFactory is GNU AGPLv3 (see `LICENSE`). This manual is not legal advice.

## 1) What ChattyFactory does (in one paragraph)

You type a plain-English request. ChattyFactory tries to choose the simplest project shape that will satisfy it, prefers a small host-supported build path when one exists, and runs a verified build. After that, you can keep going with plain follow-ups like "add search", "add export", or "add dark mode" against the active project.

## 1.5) What "role atomization" means

This is one of the main reasons ChattyFactory can work with small local models at all.

Instead of saying:
- "here is the whole app, plan it, write it, patch it, verify it, and recover from mistakes"

ChattyFactory splits the work into tiny roles with tight output contracts.

Examples:
- one role chooses the project shape
- one role writes exactly one file
- one role chooses which existing file to patch
- one role describes the patch
- one role writes the patch
- one role suggests how to verify the patch

The host then does the boring reliable bits:
- assembles `Plan.md`
- writes `ProjectSpec.json`
- writes `COCKPIT_PROTOCOL.md`
- runs deterministic checks
- keeps a journal of what fell back or failed

This is the big operating principle:
- small local model
- small scoped job
- deterministic host scaffolding

## 2) Requirements

You need:
- Windows 10/11
- Rust toolchain installed (so `cargo` works)
- A local GGUF model file (stored on your machine)

Notes:
- ChattyFactory is designed for **local** models. No network calls are required.
- In the GUI there are policy toggles (network/delete/external paths). Keep defaults unless you know why.

## 3) Install / run

From a terminal (PowerShell), run **from the ChattyFactory folder**:
```powershell
# Standalone repo example:
cd C:\Users\User\Desktop\chattyfactory
cargo run -p chattyfactory_gui
```

If ChattyFactory is inside the ChattyCog repo (as a module), run:
```powershell
cd C:\Users\User\Desktop\chattycog\chattycog_gui\modules\chattyfactory
cargo run -p chattyfactory_gui
```

Runtime sharing note (module mode):
- If ChattyCog's runtime exists at `chattycog_gui/runtime/windows/`, ChattyFactory auto-detects and uses it.
- To force ChattyFactory's bundled runtime instead: `set CF_RUNTIME_MODE=local`

If you want a faster binary:
```powershell
cargo run -p chattyfactory_gui --release
```

## 4) Add a model

1) Put your `.gguf` file in `models/`.
2) In the app, click **Rescan models**.
3) Select your models in the **Overseer** and **Builder** dropdowns (they can be the same model).

If nothing shows up:
- Confirm the file ends with `.gguf`.
- Confirm it is inside `models/` under the ChattyFactory folder.

## 5) The UI (what you're looking at)

- **Chat panel**: your request + the assistant's questions/outputs (condensed).
  - Think of it as a build console for intent, not a general chat toy.
- **Output explorer**: projects created under the current output root.
- **Active project**: the folder ChattyFactory will patch when you're in "modify an existing project" mode.
- Buttons:
  - **Confirm plan**: keeps a broad `Plan.md` draft for review/editing (no execution).
  - **Confirm & Run**: executes a confirmed plan.
    - If the assistant is waiting for your answer and you want to answer it, type in the chat box and press **Send**.
    - If you want to skip the remaining Q&A and proceed with best-effort defaults, press **Confirm & Run**.
  - **Cancel**: cancels the current job.
  - **Details**: diagnostics (plan lint, journal, metrics, policies, output root).

## 6) The core workflow (recommended)

### Step A: Make a request

Good example:
- "Build a simple invoice dashboard"
- "Build a browser timer app"
- "Make a small inventory tool"
- "Build a python CLI that reads JSON files from input/ and writes a summary report to output/"

Bad example:
- "Make something cool"

### Step B: Blueprint + narrowing

For a clear new-project request, ChattyFactory now tries a direct route first:
- `scratch`
- project blueprint
- atomized project seed if available
- validation
- auto-run

If the request is ambiguous or the direct route cannot produce a safe plan, ChattyFactory can still fall back to the older narrowing / planning conversation.

ChattyFactory tries to choose an anchor and will ask small questions if needed.
While narrowing:
- The anchor should always be concrete (defaults to `scratch` if needed).
- The assistant also produces an **Interpretation** (a short statement of what it thinks you want).
- If the Interpretation changes, the assistant should surface it so you can correct it early.

### Step C: Foundation build or Plan.md

There are now two common cases:

1. **Atomized foundation path**
   - The model gets a tiny role like "write `index.html`" or "write `main.py`".
   - The host assembles the rest of the `Plan.md`, acceptance check, and project contract.
   - If validation passes, ChattyFactory can auto-run it.

2. **Broad Plan.md path**
   - If there is no fitting atomized family yet, ChattyFactory asks the model for a full strict `Plan.md`.
   - This path is still supported, but it is no longer the preferred front door for clear new builds.

### Step C.25: The main atomized roles

These are the small jobs the model can be asked to do:

- `PROJECT_BLUEPRINT`
  - picks language, kind, and entrypoint
  - example: `html / web / index.html`

- `CODE_FILE`
  - writes one complete file only
  - no prose, no markdown, no plan syntax

- `PATCH_TARGET`
  - picks one patch target from a candidate list

- `PATCH_INTENT`
  - says what kind of patch this is
  - whether a supporting file is needed
  - gives a short summary

- `PATCH_FILE`
  - writes one unified diff hunk when diff mode is still the right tool

- `PATCH_ACCEPTANCE`
  - suggests how to verify the requested change actually landed

- `RECOVERY` / `BUILD_REPAIR`
  - produce bounded repair-only steps when a plan or run step fails

- `BUILD_SPEC`
  - writes a technical spec for handoff/reference
  - it does not write the product itself

When the request matches a strong host family, the model does not need to do all of these. Often it only needs to do one:
- write `index.html`
- write `main.py`
- rewrite `index.html`
- choose a patch target

### Step C.5: Project snapshot (X-ray) (ground truth for patching)

Before compile/run (and during bounded repair loops), ChattyFactory generates a deterministic "Project snapshot" of the
selected anchor (scratch or active project). This snapshot is used as a *ground truth* reference so small models do not
invent file paths (for example, writing `src/main.rs` in a Python project).

Snapshot files (per job):
- `runtime/plans/<job_id>.project_snapshot.md`
- `runtime/plans/<job_id>.project_snapshot.json`

### Step D: Confirm or auto-run

When you click **Confirm plan** or **Confirm & Run**, ChattyFactory:
- freezes `Anchor:` + `Interpretation:` for this job (receipts),
- copies them into the working `Plan.md`,
- enforces: do not change `Anchor:` / `Interpretation:`; only change steps.

For host-assembled direct foundation builds, ChattyFactory can skip the extra confirm click and auto-run after validation gates. Broad `Plan.md` drafts still stop for review.

Receipt files:
- `runtime/plans/<job_id>.anchor_context.md` (frozen on confirm)
- `runtime/plans/<job_id>.scratch.md` (conversation + receipts)

### Step E: Run (deterministic execution)

When you click **Confirm & Run**, ChattyFactory compiles the plan and runs it with verification.

Your project output is created under:
- `output/<Project>/`

Each successful project also gets a `ProjectSpec.json` contract file. That is what later patch requests use to stay grounded.

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
- (Removed) Scaffold instantiation is not supported.
- `ensure_dir <rel_path>`
- `write_file <rel_path> | contents: ...`
- `write_file <rel_path> | contents_b64: ...`
- `apply_patch <rel_path> | patch: ...`
- `run <command...>`

Common verifications:
- `verify: exists <path>`
- `verify: dir_exists <path>`
- `verify: contains <path> <needle>`
- `verify: command <argv...>` (rare; `run` already creates a command check)
- `verify: output_contains <needle>` (best on `run` steps)

Important rules:
- Paths are **relative** to the project root (do not prefix with the project folder name).
- `contents_b64:` is now preferred for host-generated file payloads because it avoids breaking normal code on the plan separator character.
- Plans are checked against the Project snapshot (X-ray):
  - `apply_patch` / `run` / `verify:` should reference paths that exist in the snapshot,
    or paths that are created earlier in the plan (e.g. `ensure_dir` before `write_file`).
- Create required folders/files before patching them.
- Every step needs at least one `verify:`.
- Do not invent actions like `modify_file` or `edit_file`.

Tool-like references live in `bookshelf/references/` and are also injected into "Bookshelf hints".

## 8) Tips: how to talk to the LLM (to get reliable results)

### Reality check (what ChattyFactory is and is not)
ChattyFactory is a "foundation first, then patch in reality" builder.

Expect:
- A minimal working foundation first.
- Then one moving part at a time.
- Small verified runs rather than a giant miracle prompt.

Do NOT expect:
- A fully polished product in one pass.
- Perfect "read your mind" behavior from a small local model.
- Unlimited tools/actions (the build runner only supports a small set of deterministic actions).

### Think in "one moving part at a time"
The fastest way to get reliable results is to ask for the next smallest change that:
1) can be done in a few steps, and
2) has an obvious verification check.

Good sequence:
1) "Build a simple GUI dashboard."
2) "Now add search."
3) "Now add CSV export."
4) "Now add a settings panel."

### Write requests as constraints (inputs/outputs), not vibes
Prefer:
- "Build X. Must do Y. Must not do Z. Done when I can run A and see B."

Example:
- "Build a python CLI. When I run `python main.py`, it prints `Hello, world!`. No GUI."

### Use this simple request pattern
Copy/paste and fill the blanks:
```text
Goal: <what you want to build>
Platform: Windows
Language: Python (unless needed otherwise)
Must do:
- <one or two concrete behaviors>
Must not do:
- <one constraint, if any>
Done when:
- <exact command> prints/creates <exact output/file>
```

### Confirm the Interpretation early (this prevents drift)
ChattyFactory will often show:
- "Do you mean: <Interpretation>?"

Answer with one of:
- "Yes, exactly."
- "No. I mean: <your corrected 1-sentence interpretation>."

If you see an Interpretation that is too vague (or nonsense like "and"), immediately correct it.

### If the assistant asks a question, answer with a direct choice
Small models do better with crisp options than with essays.

Example:
- Q: "Should this be Python or Rust?"
- A: "Python."

Example:
- Q: "Any extra features?"
- A: "No extras beyond the must-have behavior."

### Be explicit when you want to patch an existing project
If you want changes to an existing project, say so clearly:
- "Patch the active project to add X."
- "Now add search to this app."
- "Add dark mode to the current project."

This reduces the chance the model starts a new project instead of modifying the current one.

### Avoid common failure triggers (especially for small models)
- Prefer small "tool", "app", or "dashboard" requests with one clear purpose.
- If you want CLI specifically, say "CLI", "script", or "command line".
- Avoid mixing multiple unrelated goals in one request.
- Avoid pasting huge code blobs into chat; do small patches and point at file names.
- Avoid absolute paths (Plan steps must use relative paths only).

### If the model gets stuck, use deterministic escape hatches
You have two "always works" options:
- Open **Details**, edit `Plan.md` yourself (keep it strict), then click **Confirm & Run**.
- Click **Confirm & Run** and let bounded **Recovery mode** attempt patch steps (no questions).

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
- Click a folder name in Output explorer to set it active; future requests can patch it.
- Click "Clear project" to reset to no active project.
  - If Active is `(none)`, ChattyFactory assumes you want a NEW project in the output folder.

Patch flow is intentionally small-scope:
- choose target file
- describe patch intent
- optionally add one supporting file
- prefer whole-file rewrite for small common files
- use diff hunk mode only when needed
- run patch-specific acceptance
- run saved project acceptance

That is how ChattyFactory keeps small local models productive on follow-up requests.

Guidelines:
- Say explicitly: "Patch the active project to add X" (so the model doesn't start a new one).
- Keep changes small and verifiable.
- If the active project is broken, ChattyFactory now tries to repair the foundation first instead of layering new changes on top of a broken entrypoint.

## 11) Translating manuals (localization)

ChattyFactory can translate plain-text manuals (Markdown `.md` and `.txt`) into another language using your local models.
This is a text-translation utility workflow: it writes new files; it does not build or run code.

Setup:
- Put the manual files you want to translate in: `output/manuals/source/`
  - ChattyFactory creates this folder automatically the first time you run a manual-translation job.

In the chat:
- Example: "translate manuals to Spanish"
- Example: "transcribe manuals to French"
- If you type the request in a non-English language, ChattyFactory will default to that language.
  If you type in English, explicitly state the target language.

Then:
- Click **Confirm & Run** to start translation.

Output:
- Translations are written to: `output/manuals/<lang_code>/` (example: `output/manuals/es/`)
- Subfolders and file names from `output/manuals/source/` are preserved.

Limitations:
- Translation quality depends on the local model you picked.
- Very large manuals may need smaller chunks (split the file or translate one file at a time).
- Code fences and inline code should be preserved, but always spot-check important instructions.

## 12) Where to find logs and receipts

- Work orders: `runtime/work_orders/`
- Plans: `runtime/plans/`
- Run logs: `runtime/runs/`
- Journals: `runtime/journal/`
- Bookshelf: `bookshelf/` (good/bad plans/builds + references)

Open **Details** -> Journal / Diagnostics for quick access.

## 13) Common problems

### "Plan invalid"
Fixes:
- Ensure Title/Project/Anchor headers exist.
- Ensure 3-8 steps exist.
- Ensure every step has a `verify:`.
- Remove invented actions (use `apply_patch`).

### "GUI detected" when you wanted CLI
Say:
- "CLI, no GUI" or "terminal-only"
and/or:
- "python (recommended)".

### "Context overflow"
Keep requests shorter and do smaller runs. Avoid pasting long code blobs into chat; patch gradually.

### Final note
This is not a chatbot window.
It's a drive-through window for building and patching software.

Be clear about the order.
Confirm it.
Get the output.
Circle back to patch.
