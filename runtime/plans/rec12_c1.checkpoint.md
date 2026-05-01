Title: Recovery: build a file sorting tool
Project: build_a_file_sorting_tool_4
Anchor: scratch

- [ ] Ensure dir input/ | ensure_dir input/ | verify: exists input/
- [ ] Step title | ensure_dir input/ | verify: dir_exists input/
- [ ] Ensure dir output | ensure_dir output | verify: exists output
- [ ] Step title | write_file output/sorted_files.txt | contents: |  | verify: exists .
- [ ] Step title | apply_patch sorted_files.py | patch: | verify: exists .
- [ ] Step title | run py -3 main.py | verify: exists .
