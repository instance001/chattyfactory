# NLnet Continuity Note (ChattyFactory v0.3)

This document explains how the current Rust implementation (v0.3) is a direct progression from the NLnet-submitted prototypes (v0.1 manual + v0.2 auto), not a different project.

Submitted prototype repos:

- Manual Pipeline v0.1: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- Auto Pipeline v0.2: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

## 1) What the Project Does (one sentence)

ChattyFactory converts plain-English intent and/or chaotic project folders into clean, reproducible software outputs via a strict plan format compiled into deterministic, verifiable execution—fully offline and compatible with small local models.

## 2) Why it Matters

Modern AI tooling often depends on cloud APIs, high compute, opaque workflows, and non-reproducible results. ChattyFactory targets local sovereignty and reproducible, auditable workflows suitable for education, NGOs, community labs, and FOSS maintenance in low-resource environments.

## 3) Key Innovations (how v0.3 advances them)

### A) Dual-pipeline architecture (manual + auto)

- v0.1/v0.2 demonstrated manual and automated pipeline shapes in Python prototypes.
- v0.3 hardens the underlying primitives (strict planning, compilation to work orders, deterministic execution, verification) so both “manual” and “auto” experiences can share a reliable core.

### B) Works entirely offline

v0.3 remains offline-first by design; models are local and artifacts are stored locally.

### C) Model-agnostic & future-proof

v0.3 keeps the interface “model as a component” rather than a dependency on any single provider.

### D) Deterministic & traceable

v0.3 strengthens determinism via a strict `Plan.md` format, plan linting, compilation to a deterministic work order, and logged verification steps/receipts.

## 4) Practical Use Cases

- Students and educators (software literacy, reproducible builds, structured workflows)
- NGOs and low-resource environments (offline capability, low compute posture)
- FOSS maintainers (auditable automation, deterministic execution, reproducible results)
- Community labs and digital literacy groups (transparent, teachable pipelines)

## 5) Deliverables (prototype → successor mapping)

Prototype deliverables referenced in the original framing:

- Manual Pipeline (v0.1): delivered as the v0.1 repo (reference prototype)
- Auto Pipeline (v0.2): delivered as the v0.2 repo (reference prototype)

Successor implementation deliverables in v0.3 (this repo):

- a maintained, deterministic core suitable for long-term stewardship
- documentation that bridges v0.1/v0.2 concepts into the v0.3 architecture
- ongoing evolution toward a dual-role local-model workflow:
  - Overseer (planning/verification) + Builder (patch execution)

Note: v0.3 is explicitly a midway evolution, not an endpoint.

Related R&D prototype (informing the upcoming dual-role orchestration): `https://github.com/instance001/dual-ai-cognition-spine-prototype` (supporting prototype repo; not a required dependency of ChattyFactory).

Grant/deliverables mapping for v0.3: `GRANT_STATUS.md`.

## 6) Ethics & Safety

- Offline-first and clarity-first design
- Deterministic execution with explicit verification steps
- Transparent artifacts (plans, receipts/logs)
- Licensing posture aligned with the prototypes (AGPLv3)

## 7) Public Benefit

- Lowers barriers to software literacy and structured project work
- Strengthens local/sovereign AI usage patterns
- Improves reproducibility and auditability in the digital commons

## 8) Why this is a natural progression (summary)

v0.1/v0.2 proved the workflow. v0.3 rebuilds the same workflow’s core mechanics in Rust to improve determinism, safety boundaries, auditability, and maintainability—while preserving the original mission and extending it with clearer role separation for small local models.
