# Unified diff hunks (memory jogger)

Use unified diff **hunks** (not full file dumps) for `apply_patch`.

Shape:
- `@@ -old_start,old_len +new_start,new_len @@`
- then lines:
  - context starts with space
  - deletions start with `-`
  - additions start with `+`

Constraints:
- Patch only files that exist (or were created earlier in the plan).
- Keep hunks minimal and local to the change.
- Avoid patching multiple unrelated sections in one step.

