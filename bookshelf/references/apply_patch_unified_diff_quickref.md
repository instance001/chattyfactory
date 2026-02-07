# apply_patch Unified Diff Quickref

## TL;DR
- `apply_patch <rel_path>` uses unified diff hunks (the `@@` form).
- Keep patches tiny. Prefer changing one file per step.
- Always add `verify: contains <path> <needle>` for the new text.

## Minimal example
Plan step:
`- [ ] Change greeting | apply_patch main.py | patch: @@
-print("hello")
+print("hello world")
 | verify: contains main.py hello world`

## Multi-line change
`- [ ] Add arg parsing | apply_patch main.py | patch: @@
-import sys
+import sys
+
+def main():
+    name = sys.argv[1] if len(sys.argv) > 1 else "world"
+    print(f"hello {name}")
+
+if __name__ == "__main__":
+    main()
 | verify: contains main.py def main`

## Common mistakes
- Missing `@@` hunk header.
- Using non-unified formats.
- Forgetting `verify:`.
