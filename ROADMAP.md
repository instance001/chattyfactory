# ChattyFactory Roadmap (v0.3 Rust line)

This repository is a maintained successor to the NLnet-submitted Python prototypes:

- Manual Pipeline v0.1: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- Auto Pipeline v0.2: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

## Guiding principle

Plain English → strict/auditable plan → deterministic execution → verifiable outputs (offline, model-agnostic, reproducible).

## Near-term (stabilize v0.3)

- Tighten plan lint + error UX (make “why invalid” obvious and fixable)
- Expand deterministic verification steps and receipts (more “prove it worked”)
- Improve templates/anchors and patch workflows for existing folders (“chaos → clean” as an anchor/patch transformation)
- Increase automated coverage for plan parsing, compilation, and runner behavior (keep tests fast and offline)

## Next major step (dual-role orchestration)

Formalize the split already present in the project’s lineage (Foreman/Worker) as:

- **Overseer**: interpretation, constraints, plan quality, verification loop
- **Builder**: small concrete patches and step execution under strict rules

This is intended to reduce “all-hats” strain on small local models and reduce jank.

Related R&D prototype (informing this orchestration): `https://github.com/instance001/dual-ai-cognition-spine-prototype`

## Documentation & curriculum

- Maintain `USER_MANUAL.md` and `RELIABILITY.md` as the practical operator docs
- Add short “teaching slices” (exercises) that use the manual/prototype lineage and the v0.3 UI

## Governance & stewardship

- Define contribution rules and release process (issues, PRs, reviews)
- Clarify long-term maintenance posture (what is stable vs experimental)

