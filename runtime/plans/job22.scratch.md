# Anchor narrowing

Request: build a file sorter tool

- ANCHOR: scratch
- INTERPRETATION: Anchor  (current): build_a_file_sorter_tool

- MODEL_TEXT: You are ChattyFactory anchor selector.
- exactly ONE anchor id from the shortlist (single line), OR
- exactly ONE concise clarifying question.
Do NOT output a plan.
Do NOT output the literal text "...your response...".
USE ... (truncated)
scratch
<|im_end|>
def test_anchor_narrowing():
    assert process_message("""
<|im_start|>user
You are ChattyFactory anchor selector.
- exactly ONE anchor id from the shortlist  (single line), OR
- exactly ONE concise clarifying question.
Do NOT output a plan.
Do NOT output the literal text "...your response...".
- SELECTED: scratch

- MODEL_TEXT:
Title: Build File Sorter Tool Plan
Project: scratch
Anchor: scratch
- [ ] Setup Environment | ensure_dir build_a_file_sorter_tool | verify: dir_exists build_a_file_sorter_tool
- [ ] Create main.py | write_file main.py | contents: # Your code here...
- [ ] Implement File Sorting Logic | apply_patch main.py | patch: diff --git a/main.py b/main.py ... (unified diff hunk)
- [ ] Test File Sorter Tool | run py -3 main.py | verify: stdout_contains "Files sorted successfully"
Title: <short>
Project: <name>
Anchor: <anchor_id>
- [ ] <step title> | <action ...> | verify: <kind> <args...>

! Plan invalid: placeholder token '<step' found in plan line '- [ ] <step title> | <action ...> | verify: <kind> <args...>'
- MODEL_TEXT_REPAIR_1:
Title:
Project: <n>
Anchor: <a>
- [ ] <s> <| a...> | verify: <k> <args...>

- MODEL_TEXT_REPAIR_2:
Title:
Project: <p>
Anchor: <a>
- [ ] <s> <| a...> | verify: <k> <args...>

- MODEL_TEXT_REPAIR_3:
Title:
Project: <p>
Anchor: <a>
- [ ] <s> <| a...> | verify: <k> <args...>

! Plan repair failed: Plan invalid after repair attempts
! Falling back to stepwise planning: Plan invalid after repair attempts

---
FREEZE_CHECKPOINT
anchor: scratch
interpretation: build a file sorter tool
locked: yes
phase: confirm_pressed
---


---
LOCKED: confirm_pressed

