# Grant / Deliverables Status (continuity mapping)

This repo is the Rust successor implementation (v0.3+) of the ChattyFactory concept submitted to NLnet as two Python prototypes:

- Manual Pipeline v0.1: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- Auto Pipeline v0.2: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

## Status (as of 2026-02-16)

- Proposal submitted to NLnet on 2025-11-30; review status unknown.
- v0.3+ successor implementation is active: offline deterministic core + GUI orchestration + two-model roles.
- Current focus: build efficiency + reliability for small/local models (iterative patching, verifiable steps).
  - Added deterministic project snapshot ("X-ray") + snapshot gate to reduce hallucinated paths/commands.
  - Added offline manual translation/localization utility workflow for staged manuals.

Goal (unchanged): plain English -> strict/auditable plan -> deterministic execution -> verifiable outputs (offline, model-agnostic, reproducible).

## Deliverables mapping

### Manual Pipeline v1.0

- Prototype baseline: v0.1 repo (manual pipeline scripts + documentation).
- Successor path (this repo): strict `Plan.md`, plan linting, confirmation-time freeze, deterministic work orders, and verifiable execution.

### Auto Pipeline v1.2

- Prototype baseline: v0.2 repo (automated pipeline scripts + orchestration).
- Successor path (this repo): generalizes "cleanup/binning/build" as an anchor/patch transformation over arbitrary existing folders, with bounded recovery when planning fails.

### Documentation & curriculum

- Current: `README.md`, `USER_MANUAL.md`, `RELIABILITY.md`, and continuity docs (`LINEAGE.md`, `NLNET_CONTINUITY.md`).
- Planned: short curriculum-style exercises aligned with the manual/prototype lineage and the v0.3 UI (see `ROADMAP.md`).

### Testing suite

- Current: fast offline unit tests exist in the deterministic core (run with `cargo test`).
- Planned: expand coverage around plan parsing/lint, compilation, runner verification, and regression fixtures (see `ROADMAP.md`).

### Governance + long-term stewardship

- Current: AGPLv3 licensing posture maintained across iterations.
- Planned: contribution and release process, and "stable vs experimental" policy (see `ROADMAP.md`).

## Related supporting prototype (not a dependency)

The Overseer/Builder orchestration in v0.3 was informed by experiments in:

- `https://github.com/instance001/dual-ai-cognition-spine-prototype`

This is a supporting R&D repo and is not required to build or run ChattyFactory.
