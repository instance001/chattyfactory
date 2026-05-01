# Paths + snapshot gate (memory jogger)

## Paths must be project-relative
Never use:
- drive letters (`C:/...`)
- UNC paths (`\\\\server\\share`)
- absolute paths (`/tmp`, `/home`, `/usr`, `/src/...`)
- parent traversal (`..`)

## Snapshot gate
Before compile/run, file paths referenced by actions/verifies must be:
- present in the project snapshot, **or**
- created earlier in the plan (e.g., `ensure_dir app` before `write_file app/main.py`)

If the gate fails:
- fix the plan paths (don't "explain")
- add missing `ensure_dir`
- avoid inventing conventional paths that aren't in the snapshot

