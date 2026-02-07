# Runtime binaries

ChattyFactory uses a local backend binary (`llama-cli`) to run GGUF models via `llama.cpp`.

For licensing, supply-chain, and repo-size reasons, this repository does **not** ship downloaded backend binaries.
Install your platform binary into the appropriate folder:

- Windows: `runtime/bin/windows/`
- Linux: `runtime/bin/linux/`
- macOS: `runtime/bin/macos/`

Platform notes:

- Windows: see `runtime/bin/windows/README.md` (includes a helper script).
- Linux/macOS: see the OS-specific README for expected filenames/paths.

