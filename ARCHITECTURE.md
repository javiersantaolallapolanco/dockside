# Dockside Architecture

Dockside is a self-hosted deployment platform.

## Rules

- One entrypoint: bin/dockside
- Commands live under core
- Runtime wraps external tools
- Adapters isolate operating system specifics
- No absolute QTS paths outside adapters/qts
- Every feature must be executable after each commit
