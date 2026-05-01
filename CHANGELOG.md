# Changelog

This changelog tracks the Rust successor line ("v0.3+") of ChattyFactory.

For the NLnet-submitted Python prototypes, see:

- v0.1 Manual Pipeline: `https://github.com/instance001/ChattyFactory-ManualPipeline-v0.1`
- v0.2 Auto Pipeline: `https://github.com/instance001/Chattyfactory-AutoPipeline-v0.2`

## Unreleased (as of 2026-02-16)

- GUI supports two model roles: Overseer + Builder (can be the same model).
- Added confirmation-time freeze receipts for Anchor + Interpretation (`runtime/plans/<job_id>.anchor_context.md`).
- Added deterministic Project snapshot ("X-ray") artifacts + snapshot gate to block hallucinated paths/commands before execution.
- Added bounded recovery mode when planning fails hard (no questions, 3-8 steps per cycle).
- Added offline manual translation/localization utility workflow for staged `.md`/`.txt` manuals under `output/manuals/source/`.
- Hardened Plan.md lint/validation and deterministic runner behavior (path/argv normalization, stricter action args).
- Added journaling + distilled metrics/failures under `runtime/journal/`.
- Updated operator docs: `README.md`, `USER_MANUAL.md`, `RELIABILITY.md`.

## 2026-02-07

- Established continuity docs: `LINEAGE.md`, `NLNET_CONTINUITY.md`, `GRANT_STATUS.md`, `ROADMAP.md`.
