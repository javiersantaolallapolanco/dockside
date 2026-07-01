#!/bin/sh

set -eu

DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

rc=0

for t in "$DIR"/0*.sh
do
    echo
    echo "Running $(basename "$t")"

    if ! "$t"; then
        rc=1
    fi
done

echo

if [ "$rc" -eq 0 ]; then
    echo "ALL TESTS PASSED"
else
    echo "TESTS FAILED"
fi

exit "$rc"
