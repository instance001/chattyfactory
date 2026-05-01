Title: build a python based file sorter. sort files via file type. input folder for files that need sorted to go into, output folder for sorted bins to appear
Project: build_a_python_based_file_sorter_sort_files_via_file_type_input_folder_f
Anchor: scratch

- [ ] Step title | action args... | verify: exists path
- [ ] Step 1 | action args="import os, sys" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"
- [ ] Step 2 | action args="from pathlib import Path" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"
- [ ] Step 3 | action args="def sort_files(file_type):" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"
- [ ] Step 4 | action args="if file_type == 'image':" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"
- [ ] Step 5 | action args="" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"
- [ ] Step 6 | action args="else:" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"
- [ ] Step 7 | action args="" | verify: exists path="/tmp/scratch/build_a_python_based_file_sorter.py"