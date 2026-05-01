# ChattyFactory Roadmap (Rust line v0.3+)

This repository is a maintained successor to the NLnet-submitted Python prototypes:

- Manual Pipeline v0.1: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- Auto Pipeline v0.2: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

## Guiding principle

Plain English -> strict/auditable plan (Plan.md) -> deterministic execution -> verifiable outputs (offline, model-agnostic, reproducible).

## Near-term (stabilize v0.3 and improve build efficiency)

- Make small/local models succeed more often:
  - reduce Plan.md invalid rate (better lint messages, smaller prompts, tighter state gating)
  - expand bookshelf reference cards ("tool manuals" + minimal examples)
- Ground patching with deterministic native data:
  - project snapshot ("X-ray") artifacts for anchors and active projects
  - snapshot gate to block hallucinated paths/commands before execution
- Harden OS-aware execution (Windows + POSIX):
  - avoid absolute paths and POSIX-only conventions in plans (e.g. `/tmp`, `/src/...`)
  - improve command/path normalization and errors when salvage is not possible
- Improve "patch an existing folder" workflows:
  - active-project selection and reset
  - clearer defaults for output root (`output/`) vs workspace paths
- Expand non-build utility workflows (offline):
  - manual translation/localization for staged `.md`/`.txt` manuals under `output/manuals/source/`
- Expand deterministic verification and receipts (more "prove it worked")
- Increase automated coverage for plan parsing, compilation, and runner behavior (keep tests fast and offline)

## Implemented milestone: dual-role orchestration (Overseer + Builder)

The prototype lineage already had a natural split (Foreman/Worker). v0.3 formalizes it in the GUI as:

- **Overseer**: interpretation, clarifying questions, constraints, plan quality, verification loop
- **Builder**: strict Plan.md step lines (and bounded recovery patch steps)

This reduces "all-hats" strain on small local models and reduces prompt bleed.

Related R&D prototype (informing this orchestration): `https://github.com/instance001/dual-ai-cognition-spine-prototype`

## Documentation & curriculum

- Maintain `USER_MANUAL.md` and `RELIABILITY.md` as the practical operator docs
- Add short teaching slices (exercises) that use the manual/prototype lineage and the v0.3 UI

## Governance & stewardship

- Define contribution rules and release process (issues, PRs, reviews)
- Clarify long-term maintenance posture (what is stable vs experimental)
