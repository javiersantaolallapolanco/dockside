#!/bin/sh

runtime_network_http_ok() {
    url="$1"
    curl -fsS "$url" >/dev/null 2>&1
}

runtime_network_wait_http() {
    url="$1"
    timeout="${2:-180}"

    elapsed=0

    while [ "$elapsed" -lt "$timeout" ]
    do
        if runtime_network_http_ok "$url"; then
            return 0
        fi

        sleep 2
        elapsed=$((elapsed + 2))
    done

    return 1
}
