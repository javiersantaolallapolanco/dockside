#!/bin/sh
set -eu

echo "========================================"
echo "Dockside Audit"
echo "========================================"
echo

echo "[Repository]"
echo "Files.............: $(find . -not -path './.git/*' -type f | wc -l)"
echo "Shell files.......: $(find . -name '*.sh' | wc -l)"
echo "Shell lines.......: $(find . -name '*.sh' -exec cat {} \; | wc -l)"
echo "Functions.........: $(grep -R '^[a-zA-Z0-9_]*()' scripts tests 2>/dev/null | wc -l)"
echo

echo "[Commands]"
find scripts/commands -type f | sed 's#scripts/commands/##' | sed 's/.sh$//' | sort
echo

echo "[Templates]"
find templates -type f | sort
echo

echo "[Tests]"
find tests -name '0*.sh' | sort
echo

echo "[Hardcoded paths]"
grep -R "/share/CACHEDEV1_DATA/docker" scripts tests templates 2>/dev/null || true
echo

echo "[Markers]"
grep -R "TODO_MARKER\|FIXME_MARKER" . --exclude-dir=.git 2>/dev/null || true
echo

echo "[Git]"
git status --short
echo

echo "Audit finished."
