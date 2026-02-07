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

## The reliability stack

### 1) Strict Plan.md format

Plans must be strict so they can be compiled and executed deterministically:
- headers: `Title`, `Project`, `Anchor` (and optionally `Interpretation`)
- 3-8 checklist steps
- each step contains:
  - one supported action
  - at least one `verify:` check

Supported actions:
- `instantiate_template`
- `ensure_dir`
- `write_file`
- `apply_patch`
- `run`

If the model invents actions like `modify_file`, the plan will fail validation.

### 2) Freeze checkpoint (prevents drift)

At confirm time, ChattyFactory freezes:
- a concrete `Anchor:`
- the assistant's `Interpretation:` of the user's request

Those are stored in:
- `runtime/plans/<job_id>.anchor_context.md`

Then, before compile/run, the working `Plan.md` is forced back to match the frozen anchor+interpretation.
This prevents late-stage "melting" (changing what the job is).

### 3) Bookshelf "tool manuals"

The bookshelf is the local reference library. It contains:
- references (`bookshelf/references/`) such as step syntax cookbooks and patch examples
- recorded good/bad plans and builds

During narrowing/planning, "Bookshelf hints" are injected into the prompt.

Keep references short and example-heavy. Prefer "how to do X with these actions" over prose.

### 4) Bounded repair and stepwise planning

When Plan.md is invalid, ChattyFactory:
- attempts bounded repairs
- then falls back to stepwise planning to reduce LLM burden

### 5) Recovery mode (bounded safety net)

If planning fails hard (plan invalid after retries, stepwise yields no valid steps, etc.), ChattyFactory enters Recovery mode:
- no questions
- no narration
- emits only 3-8 step lines per cycle
- runs bounded cycles and stops

Recovery mode is intentionally limited: it is a safety net, not a new planner.

## Operator guidelines (how to maximize success)

- Prefer Python unless you need Rust/GUI.
- Ask for the smallest working end-to-end proof first:
  - "prints hello world"
  - then "add name arg"
  - then "add config file"
- Keep requests short. Avoid pasting big code dumps.
- Confirm the assistant's interpretation early:
  - "Yes, that's correct" / "No, here's the corrected interpretation"
- If you get stuck in Q&A loops:
  - edit the plan manually in Details
  - or use Confirm & Run to trigger bounded recovery behavior

## Common failure modes (and why they happen)

- **Echoed prompts / missing markers**: some backends echo the whole prompt; extraction/normalization tries to remove it but can still fail.
- **Invented actions**: the model uses a tool name it "wishes" existed; strict validation blocks it.
- **Path mistakes**: models often prefix paths with the project folder; runner expects paths relative to project root.
- **Verification missing**: models forget `verify:`; plan validation blocks it.
- **Context overflow**: local models have small context windows; keep prompts compact.

## Where to debug

- `runtime/plans/`:
  - `<job>.md` (plan)
  - `<job>.scratch.md` (narrowing/planning receipts)
  - `<job>.anchor_context.md` (frozen anchor+interpretation at confirm)
- `runtime/work_orders/` (compiled JSON)
- `runtime/runs/<wo_id>/` (execution logs)
- `runtime/journal/` (jsonl + distilled metrics/failures)

## Reporting / improving reliability

When you find a new failure pattern:
1) capture the smallest reproduction request,
2) inspect the journal + scratch,
3) add a short bookshelf reference card showing:
   - the bad pattern
   - the correct step syntax
   - a minimal example plan

The goal is to make success increasingly model-agnostic via local bootstrap.
