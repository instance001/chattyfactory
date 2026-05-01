# Project snapshot (X-ray)

Label: new_project_lets_build_a_basic_gui_dashboard_in_python
OS: windows
Root: C:\Users\User\Desktop\chatty-modules\chattyfactory-module\output\new_project_Lets_build_a_basic_gui_dashboard_in_python
Created: unix:1776987980

## Build facts (deterministic)
language: python
build_system: python
entrypoints: main.py
run_hints: py -3 main.py

## File tree (depth-limited)
BuildSpec.md (3.9 KB)
ProjectSpec.json (823 B)
main.py (667 B)

## Hot words (cheap semantics)
- main (occ=10) in BuildSpec.md, ProjectSpec.json
- argparse (occ=1) in main.py
- def main (occ=1) in BuildSpec.md

## Key excerpts (targeted)

--- FILE: ProjectSpec.json (823 bytes) ---
{
  "spec_id": "chattyfactory.project_spec.v1",
  "project_name": "new_project_Lets_build_a_basic_gui_dashboard_in_python",
  "summary": "let's fix this basic gui dashboard in python",
  "language": "python",
  "entrypoints": [
    "main.py"
  ],
  "expected_files": [
    "main.py",
    "ProjectSpec.json"
  ],
  "default_commands": [
    "py -3 main.py --self-test"
  ],
  "acceptance_commands": [
    "py -3 main.py --self-test"
  ],
  "acceptance_checks": [
    {
      "command": "py -3 main.py --self-test",
      "expect_output_contains": "CF_OK"
    }
  ],
  "key_files": [],
  "current_features": [],
  "invariants": [
    "Keep the acceptance command passing after every patch."
  ],
  "last_request": "let's fix this basic gui dashboard in python",
  "last_work_order_id": "",
  "updated_at": "unix:1776985210"
}
--- END FILE ---

--- FILE: main.py (667 bytes) ---
import argparse
import json
import statistics
import sys
import tkinter as tk
from dataclasses import dataclass
from pathlib import Path
from tkinter import ttk, messagebox


@dataclass
class Metric:
    name: str
    value: float
    target: float

    @property
    def status(self) -> str:
        if self.value >= self.target:
            return "on track"
        if self.value >= self.target * 0.8:
            return "watch"
        return "behind"


DEFAULT_METRICS = [
    Metric("Revenue", 128.0, 120.0),
    Metric("Active users", 934.0, 1000.0),
    Metric("Conversion", 7.4, 6.5),
    Metric("Support tickets", 18.0, 12.0),
]


def load_metrics(path: str
--- END FILE ---

