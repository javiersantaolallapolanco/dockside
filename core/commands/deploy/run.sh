#!/bin/sh
set -eu

runtime_load log
runtime_load compose

. "$DOCKSIDE_ROOT/core/services/catalog-service.sh"
. "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

DEPLOY_MODE="run"
DEPLOY_STACK=""
DEPLOY_PULL="yes"
DEPLOY_BUILD="yes"

deploy_usage() {
    cat <<'USAGE'
Usage:
  dockside deploy
  dockside deploy --plan
  dockside deploy --stack <name>
  dockside deploy --no-pull
  dockside deploy --no-build

Options:
  --plan          Show deploy plan without changing anything
  --stack NAME    Deploy only one catalog stack
  --no-pull       Skip docker compose pull
  --no-build      Skip docker compose build
USAGE
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        --plan|plan)
            DEPLOY_MODE="plan"
            shift
            ;;
        --stack)
            if [ "$#" -lt 2 ]; then
                runtime_log_fatal "--stack requires a value"
            fi
            DEPLOY_STACK="$2"
            shift 2
            ;;
        --no-pull)
            DEPLOY_PULL="no"
            shift
            ;;
        --no-build)
            DEPLOY_BUILD="no"
            shift
            ;;
        --help|-h)
            deploy_usage
            exit 0
            ;;
        *)
            runtime_log_fatal "Unknown deploy option: $1"
            ;;
    esac
done

deploy_stack_selected() {
    stack="$1"

    if [ -z "$DEPLOY_STACK" ]; then
        return 0
    fi

    [ "$stack" = "$DEPLOY_STACK" ]
}

deploy_plan_stack() {
    stack="$1"

    compose_service_load_stack "$stack"

    printf "%-18s %s\n" "Stack" "$stack"
    printf "%-18s %s\n" "Name" "$STACK_NAME"
    printf "%-18s %s\n" "Compose file" "$COMPOSE_FILE"

    if [ -n "${ENV_FILE:-}" ]; then
        printf "%-18s %s\n" "Env file" "$ENV_FILE"
    else
        printf "%-18s %s\n" "Env file" "-"
    fi

    printf "\n"
}

deploy_validate_stack() {
    stack="$1"

    runtime_log_info "Validating stack: $stack"
    compose_service_run_stack "$stack" config >/dev/null
}

deploy_pull_stack() {
    stack="$1"

    if [ "$DEPLOY_PULL" = "no" ]; then
        runtime_log_warn "Skipping pull for stack: $stack"
        return 0
    fi

    runtime_log_info "Pulling stack: $stack"

    if ! compose_service_run_stack "$stack" pull; then
        runtime_log_warn "Pull failed or skipped by Compose for stack: $stack"
    fi
}

deploy_build_stack() {
    stack="$1"

    if [ "$DEPLOY_BUILD" = "no" ]; then
        runtime_log_warn "Skipping build for stack: $stack"
        return 0
    fi

    runtime_log_info "Building stack if needed: $stack"

    if ! compose_service_run_stack "$stack" build; then
        runtime_log_warn "Build failed or not required for stack: $stack"
    fi
}

deploy_up_stack() {
    stack="$1"

    runtime_log_info "Starting stack: $stack"
    compose_service_run_stack "$stack" up -d
}

deploy_run_stack() {
    stack="$1"

    printf "\n"
    printf "%s\n" "----------------------------"
    printf "Deploying stack: %s\n" "$stack"
    printf "%s\n" "----------------------------"

    deploy_validate_stack "$stack"
    deploy_pull_stack "$stack"
    deploy_build_stack "$stack"
    deploy_up_stack "$stack"
}

runtime_log_info "Starting Dockside deploy"

stacks="$(catalog_list)"

if [ -z "$stacks" ]; then
    runtime_log_fatal "No stacks defined in catalog"
fi

if [ -n "$DEPLOY_STACK" ] && ! catalog_exists "$DEPLOY_STACK"; then
    runtime_log_fatal "Stack not found in catalog: $DEPLOY_STACK"
fi

printf "\n"
printf "Dockside Deploy\n"
printf "%s\n\n" "============================"

if [ "$DEPLOY_MODE" = "plan" ]; then
    for stack in $stacks
    do
        if deploy_stack_selected "$stack"; then
            deploy_plan_stack "$stack"
        fi
    done

    runtime_log_info "Deploy plan finished"
    exit 0
fi

for stack in $stacks
do
    if deploy_stack_selected "$stack"; then
        deploy_run_stack "$stack"
    fi
done

printf "\n"
runtime_log_info "Dockside deploy finished"
