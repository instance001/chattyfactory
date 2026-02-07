# ChattyFactory

ChattyFactory is a local-first project factory that turns plain-English requests into a strict, auditable `Plan.md`, compiles that plan into a deterministic work order, and runs it step-by-step with verification.

Designed for small/local LLMs by:
- selecting a concrete starting point (“anchor” template or an existing folder),
- freezing anchor + interpretation at confirm time,
- forcing work into small, verifiable steps,
- falling back to bounded recovery when planning fails.

License: **GNU AGPLv3** (see `LICENSE`).

## Lineage (NLnet prototypes → Rust successor)

This Rust implementation is the successor to the NLnet-submitted Python prototypes:

- v0.1 Manual Pipeline: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- v0.2 Auto Pipeline: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

v0.3 keeps the same goal (plain English → strict plan → deterministic execution → verifiable outputs) while hardening determinism/auditability and evolving toward a dual-role local-model workflow (Overseer/Builder ≈ Foreman/Worker). See `LINEAGE.md` and `NLNET_CONTINUITY.md`.

Related R&D prototype (informing the upcoming dual-role orchestration): `https://github.com/instance001/dual-ai-cognition-spine-prototype`.

Grant-safe quick links: `GRANT_STATUS.md`, `ROADMAP.md`, `CHANGELOG.md`.

## Grant scope note

This Rust successor implementation (v0.3+) was developed after the NLnet November intake submission. It continues the same project goal and hardens the same pipeline primitives demonstrated in the submitted prototypes:

- v0.1 Manual Pipeline: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- v0.2 Auto Pipeline: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

See `NLNET_CONTINUITY.md` and `GRANT_STATUS.md`.

## Quick start (Windows)

Prereqs:
- Rust toolchain (stable) installed (`rustc`, `cargo`).
- A local GGUF model file (place it under `models/`).
- A local `llama.cpp` backend binary (`llama-cli`) installed under `runtime/bin/<platform>/` (see `runtime/bin/README.md`).

Run:
```powershell
cd C:\Users\User\Desktop\chattyfactory
cargo run -p chattyfactory_gui
```

In the app:
1) Pick a model from the dropdown (or click “Rescan models”).
2) Type a request (example: “build a simple hello world cli in python”).
3) Answer narrowing/planning questions (if asked).
4) Click **Confirm plan** (review) or **Confirm & Run** (execute).

Outputs land under:
- `output/` (your built projects)
- `runtime/` (plans, work orders, logs, journals)
- `bookshelf/` (reference material + past good/bad plans/builds)

## What is an anchor?

An anchor is a starting template or an existing output/project directory that the plan will *transform*.
Anchors are starting points, not end states.

Default posture:
- Prefer **Python** unless you explicitly ask for another language or the request clearly implies otherwise.
- Prefer patching in small, verifiable steps over generating large files.

## Repo layout

- `chattyfactory_core/` deterministic compiler + runner (no interactive behavior)
- `chattyfactory_gui/` GUI orchestration + prompting + safety scaffolding
- `templates/` anchor templates
- `bookshelf/` reference cards + recorded good/bad plans/builds + index
- `models/` local GGUF models (not checked in)
- `output/` generated projects (runtime output root)
- `runtime/` plans, receipts, logs, journals, work orders

## Key concepts

- **Plan.md**: Markdown source-of-truth plan format (strict headers + checklist step lines).
- **Freeze checkpoint**: On confirm, the chosen `Anchor:` and `Interpretation:` are frozen in `runtime/plans/<job_id>.anchor_context.md` and enforced in the working `Plan.md`.
- **Deterministic runner**: Executes compiled work orders and verifies outcomes.
- **Recovery mode**: Bounded, no-questions fallback that emits 3–8 patch steps per cycle.

## Troubleshooting (fast)

- If you see “Plan invalid”: open Details → “Plan lint” and fix missing headers, missing verify, or unknown actions.
- If the model invents actions like `modify_file`: use `apply_patch` instead (see `bookshelf/references/`).
- If you see “backend binary not found”: install `llama-cli` under `runtime/bin/<platform>/` (Windows helper: `scripts/fetch_llama_cpp_windows.ps1`).
- If output looks truncated in chat: open Details → Journal / Scratch for full text.

For full documentation, see `USER_MANUAL.md` and `RELIABILITY.md`.
