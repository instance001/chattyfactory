Title: Recovery: build a python based file sorter. sort files via file type. input folder for files that need sorted to go into, output folder for sorted bins to appear
Project: build_a_python_based_file_sorter_sort_files_via_file_type_input_folder_f
Anchor: scratch

- [ ] [ ] Step 1 | ensure_dir input |  | verify: exists .
- [ ] [ ] Step 2 | write_file input/file_types.txt | contents: "image/jpeg\nvideo/mp4\napplication/pdf" | verify: exists file_types.txt
- [ ] [ ] Step 3 | apply_patch output_folder_structure.py | patch: | verify: exists .
- [ ] [ ] Step 4 | ensure_dir output | verify: exists .
- [ ] [ ] Step 5 | write_file output/folder_type_map.txt | contents: "JPEG/jpeg\nMP4/video1.mp4\nPDF/file2.pdf" | verify: exists folder_type_map.txt
