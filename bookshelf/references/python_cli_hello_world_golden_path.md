# Python CLI Hello-World Golden Path

## TL;DR
- Anchor: python_cli
- Change `main.py` to print `hello world` (or `hello <name>`).
- Verify with `contains` + a `command` run.

## Example Plan.md (shape)
Title: hello world cli
Project: hello_world_cli
Anchor: python_cli
Interpretation: print("hello world") to stdout

- [ ] Scaffold project | instantiate_template python_cli . | verify: dir_exists .
- [ ] Patch main | apply_patch main.py | patch: @@
-print("hello")
+print("hello world")
 | verify: contains main.py hello world
- [ ] Run | run python main.py | verify: command python main.py | output_contains: hello world
