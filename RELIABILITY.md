# Reliability Notes

This document explains how ChattyFactory stays deterministic, where it can fail, and how to operate it for the best odds of success with small/local models.

## What "reliable" means here

ChattyFactory aims for:
- deterministic execution (the runner does exactly what the plan says),
- verifiable progress (each step has explicit checks),
- auditable artifacts (plans, receipts, work orders, logs).

It does **not** guarantee:
- that a given model can always write a valid Plan.md on the first try,
- that the first interpretation of a request is correct,
- that complex projects will succeed in a single run.

The current reliability strategy is not "make one model hold the whole app in its head." It is "atomize the job until a small local model can succeed at the next concrete piece."

## The reliability stack

### 0) Two-model separation (Overseer + Builder)

ChattyFactory can use two local models with distinct roles (they can also be the same model):
- **Overseer**: stays in chat/logs mode; restates the request as a concrete *Interpretation* and helps keep the job on track.
- **Builder**: produces strict `Plan.md` step lines (and bounded recovery patch steps).

This separation is intentional:
- The chat is the interface to produce an order; the **order** (Plan.md) is what gets executed.
- The runner never "continues the conversation" during execution; it only executes the compiled work order deterministically.

### 1) Project blueprint + easiest-path routing

For clear fresh-build requests, ChattyFactory first asks for a tiny `PROJECT_BLUEPRINT`:
- language
- project kind
- entrypoint
- short reason

Then the host can normalize that blueprint toward the easiest local path when the user has not explicitly locked the stack:
- generic GUI often pools to static web
- browser-natural tools often pool to static web
- explicit Python/Rust/Node requests are preserved

This matters because choosing a good project shape is often the difference between "small model succeeds" and "small model drowns."

### 2) Atomized build families before broad Plan.md

Whenever possible, ChattyFactory prefers a host-supported atomized family over asking for a full broad plan.

Current families:
- Python CLI
- Python tkinter dashboard
- Static web (`index.html`)
- Rust CLI
- Node/JavaScript CLI

The model writes one concrete source file. The host then assembles:
- the strict `Plan.md`
- acceptance command/check
- `ProjectSpec.json`
- verification steps

Only if no matching family exists, or the family fails to accept, does ChattyFactory fall back to broad `Plan.md` drafting.

### 2.5) Role atomization (the real local-model trick)

The important reliability move is not just "have atomized families".
It is that ChattyFactory keeps carving work into roles that ask for one narrow thing at a time.

Current roles and why they exist:
- `PROJECT_BLUEPRINT`
  - choose shape, not implementation
  - reduces early stack confusion
- `CODE_FILE`
  - write one complete file only
  - keeps generation local and inspectable
- `PATCH_TARGET`
  - choose one existing file from a bounded list
  - prevents target hallucination
- `PATCH_INTENT`
  - describe the patch before writing it
  - separates "what to do" from "how to write it"
- `PATCH_FILE`
  - write one diff hunk only when diff mode is still useful
- `PATCH_ACCEPTANCE`
  - tie "now add Y" to a concrete definition of done
- `RECOVERY`
  - output only bounded step lines, no wandering
- `BUILD_REPAIR`
  - fix one failed run step, not the whole project in the abstract
- `RECOVERY_DONE`
  - answer only `DONE` or `MORE`
- `CLARIFY`
  - ask one question or produce BuildSpec, nothing broader
- `BUILD_SPEC`
  - write requirements/spec text only

This is the reliability idea in one sentence:
- make the model do the smallest still-useful cognitive job,
- let the host own structure, receipts, and verification.

### 3) Strict Plan.md format

Plans still need to be strict so they can be compiled and executed deterministically:
- headers: `Title`, `Project`, `Anchor` (and optionally `Interpretation`)
- 3-8 checklist steps
- each step contains:
  - one supported action
  - at least one `verify:` check

Supported actions:
- `ensure_dir`
- `write_file`
- `apply_patch`
- `run`

Important note:
- host-generated `write_file` steps can now use `contents_b64:` instead of raw `contents:`
- this avoids breaking on normal source characters that collide with plan separators
- old `contents:` still works

If the model invents actions like `modify_file`, the plan will fail validation.

### 4) Freeze checkpoint (prevents drift)

At confirm time, ChattyFactory freezes:
- a concrete `Anchor:`
- the assistant's `Interpretation:` of the user's request

Those are stored in:
- `runtime/plans/<job_id>.anchor_context.md`

Then, before compile/run, the working `Plan.md` is forced back to match the frozen anchor+interpretation.
This prevents late-stage "melting" (changing what the job is).

Freeze is only supposed to happen when the user explicitly presses **Confirm plan** / **Confirm & Run**.

#### Interpretation quality gate (before freezing)

If the Interpretation is too vague (or looks like prompt-echo / garbage):
- **Confirm plan (review)** may ask one clarifying question and keep the receipts unlocked until the goal sentence is usable.
- **Confirm & Run** will not get stuck in Q&A: it freezes a deterministic fallback Interpretation (the original request) and proceeds.

This prevents locking unusable receipts like "and", while still letting the operator force forward progress.

#### Deterministic acceptance checks (definition of done)

At confirm time, ChattyFactory may append a final "Acceptance" run+verify step (when there is room in the step limit).
This creates a clear definition-of-done and gives Recovery/auto-repair a stable test target.

### 5) Project snapshot (X-ray) + snapshot gate (prevents hallucinated paths)

Before compile/run (and during bounded repair loops), ChattyFactory generates a deterministic "Project snapshot" of the
selected anchor (scratch or active project). The snapshot is used in prompts as a read-only grounding block, and it is
also used as a hard gate before execution.

Snapshot artifacts (per job):
- `runtime/plans/<job_id>.project_snapshot.md` (human readable)
- `runtime/plans/<job_id>.project_snapshot.json` (machine readable)

What the snapshot is used for:
- Prevent "path hallucinations" like writing `src/main.rs` in a Python project (or using `/tmp/...`, `C:/...`, etc).
- No scaffold step exists; plans must create everything via `ensure_dir`, `write_file`, and `apply_patch`.
- Gate `apply_patch` / `run` / `verify:` so they only reference paths that:
  - exist in the snapshot, or
  - are created earlier in the plan (e.g. `ensure_dir` -> `write_file`).

This is one of the biggest reliability wins for small/local models: it turns "guess the project" into "edit known files".

### 6) Project contract for patching

After successful runs, ChattyFactory writes `output/<project>/ProjectSpec.json`.

That contract stores:
- language
- entrypoints
- expected files
- acceptance commands/checks
- key files
- current request summary

Patch requests use that contract to stay grounded, especially when a small model is only being asked to choose one target file or write one patch hunk.

### 7) Atomized patch flow

Patching is also split into small roles:
- classify request as patch/new build
- choose target file
- describe patch intent
- optionally choose one supporting file
- prefer whole-file rewrite for small common files
- write one diff hunk only when hunk mode is still appropriate
- add patch-specific acceptance
- run saved project acceptance

This is a major reliability improvement over asking a small model to directly "edit the project" in one shot.

There is also a foundation-repair gate now:
- if the active project entrypoint is already broken,
- ChattyFactory repairs the foundation first,
- then resumes normal feature patching.

### 8) Bookshelf "tool manuals"

The bookshelf is the local reference library. It contains:
- references (`bookshelf/references/`) such as step syntax cookbooks and patch examples
- recorded good/bad plans and builds

During narrowing/planning, "Bookshelf hints" are injected into the prompt.

Keep references short and example-heavy. Prefer "how to do X with these actions" over prose.

### 8.5) Cockpit protocol as orientation scaffolding

Successful projects now get:
- `ProjectSpec.json`
- `COCKPIT_PROTOCOL.md`

`ProjectSpec.json` is the machine contract.
`COCKPIT_PROTOCOL.md` is the orientation layer.

This matters for non-chat-window tools because small models often need a plain statement of:
- where they are
- what this workspace is
- what role they are in
- what done looks like

That is not prompt fluff.
It is workspace scaffolding.

### 9) Bounded repair and stepwise planning

When Plan.md is invalid, ChattyFactory:
- attempts bounded repairs
- then falls back to stepwise planning to reduce LLM burden

### 10) Recovery mode (bounded safety net)

If planning fails hard (plan invalid after retries, stepwise yields no valid steps, etc.), ChattyFactory enters Recovery mode:
- no questions
- no narration
- emits only 3-8 step lines per cycle
- runs bounded cycles and stops

Recovery mode is intentionally limited: it is a safety net, not a new planner.

### 11) Build-time auto-repair loop (step fails -> fix -> re-check -> continue)

During execution, if a step fails verification/smoke:
- ChattyFactory extracts failure context (logs + relevant file excerpts when possible),
- asks the Builder for 3-8 patch steps to fix the concrete failure,
- applies those steps,
- re-runs the original step's checks and continues if the checks pass.

This reduces brittleness by turning common "one mistake ends the run" failures into bounded, mechanical recovery.

### 12) Deterministic toolchain preflight (fail fast)

Before running a compiled work order, ChattyFactory checks for obvious missing tools required by `run` steps (e.g. `cargo`, `python`/`py`).
If the toolchain is missing, it fails early with an actionable error instead of wasting repair cycles.

## Operator guidelines (how to maximize success)

- Prefer the smallest sane foundation first.
- Ask for one moving part at a time after that:
  - "build a simple timer"
  - then "add presets"
  - then "add export"
- If you do not care about the stack, do not over-specify it. Let ChattyFactory pool toward the easiest local path.
- For GUI requests, say what "works" means if you have a strong expectation.
- Keep requests short. Avoid pasting big code dumps.
- Confirm the assistant's interpretation early:
  - "Yes, that's correct" / "No, here's the corrected interpretation"
- If you get stuck in Q&A loops:
  - edit the plan manually in Details
  - or use Confirm & Run to trigger bounded recovery behavior

## Common failure modes (and why they happen)

- **Echoed prompts / missing markers**: some backends echo the whole prompt; extraction/normalization tries to remove it but can still fail.
- **Runtime chatter contaminates structured output**: local wrappers can leak startup/exit text into file or spec outputs; ChattyFactory now strips common noise and tries to extract the real HTML/spec body, but this remains a class of failure to watch.
- **Invented actions**: the model uses a tool name it "wishes" existed; strict validation blocks it.
- **Path mistakes**: models often emit POSIX-ish or absolute paths (like `/src/main.py`, `/tmp/...`, `C:\...`); plans require project-relative paths. The runner salvages some common leading-slash mistakes, but don't rely on it.
- **Snapshot gate blocks the plan**: if the plan references files/dirs/commands that aren't grounded in the Project snapshot, it is rejected before execution. Fix by:
  - creating required folders/files first,
  - adding `ensure_dir` before `write_file`,
  - avoiding absolute paths / drive letters / `/tmp`,
  - referencing files that actually exist (or creating them earlier in the plan).
- **Missing toolchain**: if `cargo`/`python` is not installed or not on PATH, `run` steps will fail. Toolchain preflight should catch this early, but it can't install tools for you.
- **Verification missing**: models forget `verify:`; plan validation blocks it.
- **Context overflow**: local models have small context windows; keep prompts compact.
- **No atomized family yet**: the request falls through to broad `Plan.md` drafting because ChattyFactory does not yet have a bounded family for that project shape.
- **Atomized family did not accept**: the right family existed, but the model's concrete file output was too weak or malformed to pass the host gate.

## Where to debug

- `runtime/plans/`:
  - `<job>.md` (plan)
  - `<job>.scratch.md` (narrowing/planning receipts)
  - `<job>.anchor_context.md` (frozen anchor+interpretation at confirm)
- `runtime/work_orders/` (compiled JSON)
- `runtime/runs/<wo_id>/` (execution logs)
- `runtime/journal/` (jsonl + distilled metrics/failures)

Pay special attention to:
- `runtime/journal/distilled_metrics.md`
- the GUI **Distilled metrics** panel

Those now show:
- broad fallback count
- top atomized gaps
- top fallback reasons

That turns reliability work into a ranked backlog instead of guesswork.

## Reporting / improving reliability

When you find a new failure pattern:
1) capture the smallest reproduction request,
2) inspect the journal + scratch,
3) add a short bookshelf reference card showing:
   - the bad pattern
   - the correct step syntax
   - a minimal example plan

The goal is to make success increasingly model-agnostic via local bootstrap.
