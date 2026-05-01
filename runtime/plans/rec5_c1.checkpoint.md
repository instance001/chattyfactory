Title: Recovery: build a file sorter tool
Project: build_a_file_sorter_tool
Anchor: scratch

- [ ] Ensure dir output/ | ensure_dir output/ | verify: exists output/
- [ ] Step 1 | ensure_dir output/ | verify: dir_exists output/
- [ ] Ensure dir input | ensure_dir input | verify: exists input
- [ ] Step 2 | write_file input/file_list.txt | contents: <text | file_list> | verify: exists input/file_list.txt
- [ ] Step 3 | apply_patch ./patch/fix_sort_order.py | patch: <unified diff hunk> | verify: exists .
