Title: Recovery: build a file sorting tool.
Project: build_a_file_sorting_tool_3
Anchor: scratch

- [ ] Ensure project dir | ensure_dir . | verify: exists .
- [ ] Step 1 | ensure_dir project_root/build_a_file_sorting_tool_3 | verify: exists project_root/build_a_file_sorting_tool_3
- [ ] Step 2 | apply_patch file_sort.py | patch: --- a/file_sort.py | verify: exists .
