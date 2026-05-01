# Anchor narrowing

Request: build a file sorting tool. input folder for files to be added for sorting. output folder for sorted bins. sort files based on type.

- ANCHOR: scratch
- INTERPRETATION: Create a file sorting tool that accepts an input folder and outputs sorted bins based on file type.

- MODEL_TEXT: You are ChattyFactory anchor selector.
- exactly ONE anchor id from the shortlist (single line), OR
- exactly ONE concise clarifying question.
Do NOT output a plan.
Do NOT output the literal text "...your response...".
scratch
- SELECTED: scratch

- MODEL_TEXT:
What specific steps should be included in the file sorting tool implementation?


---
FREEZE_CHECKPOINT
anchor: scratch
interpretation: build a file sorting tool. input folder for files to be added for sorting. output folder for sorted bins. sort files based on type.
locked: yes
phase: confirm_pressed
---


---
LOCKED: confirm_pressed

