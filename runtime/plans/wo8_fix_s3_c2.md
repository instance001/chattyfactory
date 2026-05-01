Title: Build repair: step 3 (Write project contract)
Project: lets_patch_the_gpu_monitor_to_track_real_gpu_telemetry
Anchor: scratch
Interpretation: let's patch the gpu monitor to track real gpu telemetry.

- [ ] Remove invalid characters from main.py | apply_patch main.py | patch: @@ -4,7 +4 @@ | verify: exists .
- [ ] Write project contract | write_file ProjectSpec.json | contents: {"spec_id":"chattyfactory.project_spec.v1","project_name":"lets_patch_the_gpu_monitor_to_track_real_gpu_telemetry","summary":"let's patch the gpu monitor to track real gpu telemetry.","language":"python","entrypoints":["main.py"],"expected_files":["main.py","ProjectSpec.json"],"default_commands":["py -3 main.py --self-test"],"acceptance_commands":["py -3 main.py --self-test"],"acceptance_checks":[{"command":"py -3 main.py --self-test","expect_output_contains":"CF_OK"}],"key_files":[{"path":"main.py","role":"entrypoint"},{"path":"ProjectSpec.json","role":"project contract"}],"current_features":["let's patch the gpu monitor to track real gpu telemetry."],"invariants":["Keep the acceptance command passing after every patch."],"last_request":"let's patch the gpu monitor to track real gpu telemetry.","last_work_order_id":"","updated_at":""} | verify: exists path ProjectSpec.json
- [ ] Ensure main.py is executable | ensure_dir . | verify: exists path main.py
- [ ] Run project self-test | run py -3 main.py --self-test | verify: exists path main.py
