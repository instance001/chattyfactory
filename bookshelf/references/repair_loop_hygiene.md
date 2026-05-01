# Repair loop hygiene (memory jogger)

When a step fails, repairs should:
- patch the minimum necessary
- keep paths grounded in the snapshot
- avoid "assistant wrappers" and metadata in code files

Hard no in code files:
- Plan.md headers (`Title:`, `Project:`, `Anchor:`, `Interpretation:`)
- marker tokens (`CF_START` / `CF_END`)
- code fences (```), `<code>` wrappers
- assistant prose ("Sure, here's ...")

If a file begins with wrappers/prose and fails syntax smoke:
- rewrite the whole file via `write_file` (patch hunks often touch 0 lines)

