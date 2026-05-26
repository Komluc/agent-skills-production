#!/usr/bin/env bash
# verify-python.sh
# Part of the code-change-verification skill
# Runs the full Python verification stack
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more checks failed

set -uo pipefail

FAILED=0

run_check() {
  local name="$1"
  local cmd="$2"

  printf "[%-10s] " "$name"
  if eval "$cmd" &>/dev/null; then
    echo "✅ passed"
  else
    echo "❌ FAILED"
    echo "         Command: $cmd"
    eval "$cmd" 2>&1 | head -20 | sed 's/^/         /'
    FAILED=1
  fi
}

# ── Detect package manager ───────────────────────────────────────────────────
if [[ -f "Makefile" ]]; then
  run_check "format"    "make format"
  run_check "lint"      "make lint"
  run_check "typecheck" "make typecheck"
  run_check "tests"     "make tests"
elif command -v uv &>/dev/null; then
  run_check "format"    "uv run ruff format --check ."
  run_check "lint"      "uv run ruff check ."
  run_check "typecheck" "uv run pyright ."
  run_check "tests"     "uv run pytest --tb=short -q"
else
  run_check "format"    "python -m ruff format --check . 2>/dev/null || python -m black --check . 2>/dev/null"
  run_check "lint"      "python -m ruff check . 2>/dev/null || python -m flake8 . 2>/dev/null"
  run_check "typecheck" "python -m mypy . 2>/dev/null || python -m pyright . 2>/dev/null"
  run_check "tests"     "python -m pytest --tb=short -q 2>/dev/null || python -m unittest discover 2>/dev/null"
fi

exit $FAILED
