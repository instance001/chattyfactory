Title: Build repair: step 1 (Check project contract | ensure_dir . | verify: contains ProjectSpec.json chattyfactory.project_spec.v1)
Project: new_project_Lets_build_a_basic_gui_dashboard_in_python
Anchor: new_project_lets_build_a_basic_gui_dashboard_in_python
Interpretation: Patch active project `new_project_Lets_build_a_basic_gui_dashboard_in_python` according to the user request while preserving existing acceptance behavior.

- [ ] Fix syntax error in main.py | apply_patch main.py | patch: @@ -34,1 +34,1 @@\ndef load_metrics(path: str\n+def load_metrics(path: str) -> List[Metric]: | verify: exists path
- [ ] Ensure necessary imports are present | write_file main.py | contents: from typing import List\nfrom dataclasses import dataclass\n\n@dataclass\nclass Metric:\n    name: str\n    current_value: float\n    previous_value: float\n\n# Existing code...\ndef load_metrics(path: str) -> List[Metric]: | verify: exists path
- [ ] Add missing return statement in load_metrics | apply_patch main.py | patch: @@ -36,0 +37,1 @@\n+    with open(path, 'r') as file:\n+        data = json.load(file)\n+    return [Metric(**item) for item in data] | verify: exists path
- [ ] Ensure json module is imported | write_file main.py | contents: import json\n\n# Existing code... | verify: exists path
- [ ] Add error handling for file not found | apply_patch main.py | patch: @@ -36,0 +37,4 @@\n+    try:\n+        with open(path, 'r') as file:\n+            data = json.load(file)\n+    except FileNotFoundError as e:\n+        print(f"Error: {e}")\n+        return [] | verify: exists path
- [ ] Add error handling for invalid JSON format | apply_patch main.py | patch: @@ -41,0 +47,4 @@\n+    except json.JSONDecodeError as e:\n+        print(f"Error: {e}")\n+        return [] | verify: exists path
