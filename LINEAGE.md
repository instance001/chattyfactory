# ChattyFactory Lineage (v0.1 → v0.2 → v0.3)

ChattyFactory has one consistent goal across iterations:

Plain-English intent → strict/auditable plan → deterministic execution → verifiable outputs (offline, model-agnostic, reproducible).

This repository is the **v0.3 Rust successor implementation**. The earlier Python prototypes remain available as stable references:

- v0.1 Manual Pipeline (prototype, education/reference):
  `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- v0.2 Auto Pipeline (prototype, throughput/reference):
  `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

## What stayed the same (invariants)

- Offline-first and local-first operation (no required cloud services)
- Deterministic, traceable workflow (plans + logs/receipts; reproducible runs)
- Model-agnostic approach (works with small/local models when prompts + constraints are respected)
- Human control remains possible (review/confirm, bounded recovery, manual override paths)

## What changed (and why)

### v0.1 (Manual Pipeline, Python)

Focus: explicitly manual, step-by-step “factory” for transparency, education, and auditability.

### v0.2 (Auto Pipeline, Python)

Focus: higher-throughput automation over the same conceptual pipeline; “folder chaos” → bins → builds → briefs/tasks.

### v0.3 (Rust, this repo)

Focus: hardening the core primitives for long-term stewardship:

- strict plan format and linting
- compile plan → deterministic work order
- execute steps with verification and receipts
- clearer separation of responsibilities (core vs UI/orchestration)

## Where did “bins” go?

In the v0.1/v0.2 prototypes, “bins” were an explicit pipeline stage to split a chaos folder into organized sub-piles before building.

In v0.3, the same outcome is achieved more generally by treating any existing folder as an **anchor** and applying a strict, auditable **patch plan** to transform it in-place (or into a clean output). Binning is no longer a special-case stage—it’s one of the supported transformations over real project folders.

## Role separation (continuity, not a pivot)

The prototypes used a natural division of labor (e.g., Foreman/Worker). v0.3 formalizes this as a **dual-role system** (in progress):

- Overseer (Foreman-like): interpretation, constraints, plan quality, verification loop
- Builder (Worker-like): small, concrete patches and step execution under strict rules

This reduces “all-hats” burden on small local models and improves traceability.

## Related R&D prototype

The planned Overseer/Builder split is informed by experiments captured in:

- `https://github.com/instance001/dual-ai-cognition-spine-prototype`

This is a supporting prototype repo (not a required dependency of ChattyFactory).

## How to read versioning

- v0.1 / v0.2 repos: historical prototypes submitted to NLnet (Nov intake)
- v0.3 (this repo): successor implementation; midway evolution toward the same goal
