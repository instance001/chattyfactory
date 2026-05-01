# ChattyFactory - Handshake

## Module identity (required)

- **module_id**: `chattyfactory`
- **display_name**: `ChattyFactory`

## What this module is for (required)

ChattyFactory turns a plain-English request into a strict, auditable `Plan.md`, compiles that plan into a deterministic work order, and runs it with verification.

This module is **standalone** (its own Rust workspace + GUI) and is packaged as a ChattyCog module so your lab can:
- keep short "department status" notes in the module tab,
- debrief progress into cold memory when you switch tabs,
- coordinate across other modules via the orchestrator.

## Inputs this module expects (required)

- A plain-English build request ("what you want built").
- An **anchor** selection (existing project folder or a scratch starting point).
- (Optional) Constraints: language choice, time/budget, risk posture, verification expectations.
- (Optional) Files you want it to read (place under the module's allowed roots; see below).

## Outputs this module produces (required)

- `runtime/`:
  - `plans/` (frozen anchor + interpretation, snapshots)
  - `runs/` (run receipts, step artifacts, checks)
  - logs/journals used for audit + debugging
- `output/`:
  - generated or modified projects (the "product" output root)
- `bookshelf/`:
  - reference cards + saved good/bad plans/builds

## Operating rules / preferences (optional)

- Work style: small verifiable steps, strict plan format.
- Preferred languages: Python by default unless specified otherwise.
- Filesystem safety: restrict actions to allowed roots:
  - `output/`, `runtime/`, `config/`, `bookshelf/`

## Suspend rundown template (required)

When you leave this module tab, paste a short rundown into "Module state notes" first:

> **Status:** Planning / Confirmed / Running / Completed / Repair loop.
> **What changed:** Plan or interpretation updated; anchor selected/changed; run receipts created.
> **Open questions:** Any missing requirements or failing verify checks.
> **Next action:** Confirm plan, run, or apply next repair patch.
> **Artifacts:** `runtime/plans/<job_id>.*`, `runtime/runs/<wo_id>/...`, `output/<project>/...`

