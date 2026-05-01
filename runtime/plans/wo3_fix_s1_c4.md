Title: Build repair: step 1 (Check project contract | ensure_dir . | verify: contains ProjectSpec.json chattyfactory.project_spec.v1)
Project: new_project_Lets_build_a_basic_gui_dashboard_in_python
Anchor: new_project_lets_build_a_basic_gui_dashboard_in_python
Interpretation: Patch active project `new_project_Lets_build_a_basic_gui_dashboard_in_python` according to the user request while preserving existing acceptance behavior.

- [ ] Fix syntax error in main.py | apply_patch main.py | patch: @@ -34,1 +34,2 @@\ndef load_metrics(path: str):\n    with open(path, 'r') as file: | verify: exists .
- [ ] Ensure necessary imports are present | write_file main.py | contents: from typing import List\nfrom dataclasses import dataclass\nimport json\nimport statistics\nimport sys\ntkinter as tk\nfrom pathlib import Path\nfrom tkinter import ttk, messagebox | verify: exists .
- [ ] Add missing return statement in load_metrics | apply_patch main.py | patch: @@ -40,1 +40,2 @@\n        metrics = json.load(file)\n    return [Metric(**metric) for metric in metrics] | verify: exists .
- [ ] Add error handling for invalid JSON format | apply_patch main.py | patch: @@ -39,0 +39,5 @@\n    try:\n        with open(path, 'r') as file:\n            metrics = json.load(file)\n    except json.JSONDecodeError as e:\n        print(f"Invalid JSON format: {e}")\n        return [] | verify: exists .
- [ ] Add error handling for file not found | apply_patch main.py | patch: @@ -38,0 +45 @@\n    try:\n        with open(path, 'r') as file:\n            metrics = json.load(file)\n    except FileNotFoundError as e:\n        print(f"File not found: {e}")\n        return [] | verify: exists .
- [ ] Define NoMetricsError exception | write_file main.py | contents: class NoMetricsError(Exception):\n    pass | verify: exists .
