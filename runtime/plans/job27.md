Title: let's patch this python gui dashboard so it works.
Project: new_project_Lets_build_a_basic_gui_dashboard_in_python
Anchor: new_project_lets_build_a_basic_gui_dashboard_in_python
Interpretation: Patch active project `new_project_Lets_build_a_basic_gui_dashboard_in_python` according to the user request while preserving the project contract.

- [ ] Check project contract | ensure_dir . | verify: contains ProjectSpec.json chattyfactory.project_spec.v1
- [ ] Fix syntax error in `load_metrics` function | apply_patch main.py | patch: \ndef load_metrics(path: str) -> list[Metric]:\n    with open(path, 'r') as file:\n        data = json.load(file)\n    return [Metric(**item) for item in data]\n | verify: contains main.py def load_metrics
- [ ] Run saved acceptance | run py -3 main.py --self-test | verify: stdout_contains CF_OK