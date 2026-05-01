# Distilled failure patterns (recent)

- (2x) step_failed: py_compile failed for main.py: File "main.py", line 34
    def load_metrics(path: str
                    ^
SyntaxError: '(' was never closed
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Create a directory for the project files | action args: mkdir -p /path/to/project/build_a_file_sorting_tool_6')
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Step 1 | Create a new directory named 'scratch' |')
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Step 2 | Create a directory named 'src' for source code | action args: create_directory_scr_src_for_source_code')
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Step 1 | Create a new Python project directory named `file_sorter` | action: mkdir file_sorter')
- (1x) plan_validation_error: step line missing action segment (expected '| action ... |'): '- [ ] Create a directory for the project'
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Create an empty directory named "scratch" | action args: mkdir scratch')
- (1x) step_failed: py_compile failed for main.py: File "main.py", line 4
    \u2584\u2584 \u2584\u2584
    ^
SyntaxError: invalid character '\u2584' (U+2584)
- (1x) step_failed: verify command output missing usage: (stdout=C:\Users\User\Desktop\chatty-modules\chattyfactory-module\runtime\runs\wo7\step_5\verify_0_stdout.log, stderr=C:\Users\User\Desktop\chatty-modules\chattyfactory-module\runtime\runs\wo7\step_5\verify_0_stderr.log)
- (1x) plan_validation_error: step line missing action segment (expected '| action ... |'): '- [ ] Create a directory for the project and its subdirectories.'
- (1x) plan_validation_error: step line missing action segment (expected '| action ... |'): '- [ ] Install Python and pip if not already installed.'
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Implement file sorting logic | action args: ["scratch", "build_a_file_sorter", "sort_logic"]')
- (1x) plan_validation_error: each step must include at least one verify: clause (line: '- [ ] Initialize project | action: mkdir -p $scratch/build_a_file_sorting_tool_3 && cd $scratch/build_a_file_sorting_tool_3 && npm init --yes')
- (1x) plan_validation_error: step line missing action segment (expected '| action ... |'): '- [ ] Create directory for the tool: `mkdir -p $scratch/tool`'
