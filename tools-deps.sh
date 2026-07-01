#!/bin/sh
set -eu

echo "========================================"
echo "Dockside Dependency Graph"
echo "========================================"
echo

find scripts -name "*.sh" | sort | while read f
do
    echo "[$f]"
    grep '^\. "' "$f" | \
        sed 's/^\. "//' | \
        sed 's/"$//'
    echo
done
