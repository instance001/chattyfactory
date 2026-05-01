Title: let's make the gpu monitor track real telemetry.
Project: lets_make_the_gpu_monitor_track_real_telemetry
Anchor: scratch

- [ ] Create project directory | mkdir . | verify: exists .
- [ ] Initialize version control | git init . | verify: exists .git
- [ ] Add README file | echo "# GPU Monitor" > README.md | verify: exists README.md
- [ ] Install necessary dependencies | pip install pynvml | verify: exists requirements.txt
- [ ] Create main script file | touch gpu_monitor.py | verify: exists gpu_monitor.py
- [ ] Implement telemetry tracking in script | echo "import pynvml\npynvml.nvmlInit()\nhandle = pynvml.nvmlDeviceGetHandleByIndex(0)\nprint(pynvml.nvmlDeviceGetUtilizationRates(handle))\npynvml.nvmlShutdown()" > gpu_monitor.py | verify: exists gpu_monitor.py
- [ ] Commit initial changes | git add . && git commit -m "Initial commit with GPU monitor script" | verify: exists HEAD