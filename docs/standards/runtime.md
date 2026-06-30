# Dockside Runtime Standard

## One module = one directory

Example:

core/runtime/docker/
    docker.sh
    test.sh

## One module = one public prefix

filesystem -> runtime_fs_*
docker     -> runtime_docker_*
git        -> runtime_git_*
network    -> runtime_network_*
github     -> runtime_github_*
log        -> runtime_log_*

## Rules

- Every module must provide a test.sh
- Every module must be loadable through runtime_load
- Never use relative paths outside SELF_DIR
- Never execute docker/git/curl directly outside runtime
- Return exit codes. Do not parse stdout unless required.
