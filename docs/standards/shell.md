# Dockside Shell Standard

- POSIX sh only
- Compatible with QTS shell
- No bashisms
- One function = one responsibility
- Quote every variable
- set -eu in executables
- Libraries must not call set -eu
- Always resolve SELF_DIR
- No duplicated code
