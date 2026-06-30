#!/bin/sh
set -eu

printf '\n'
printf 'Dockside Doctor\n'
printf '================\n\n'

printf '%-20s' "Shell"
command -v sh >/dev/null && echo "OK" || echo "FAIL"

printf '%-20s' "Docker"
command -v docker >/dev/null && echo "OK" || echo "FAIL"

printf '%-20s' "Git"
command -v git >/dev/null && echo "OK" || echo "FAIL"

printf '%-20s' "Curl"
command -v curl >/dev/null && echo "OK" || echo "FAIL"

printf '%-20s' "QTS"
[ -d /etc/config ] && echo "OK" || echo "NO"

printf '\nDoctor finished.\n'
