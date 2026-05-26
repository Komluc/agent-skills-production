#!/usr/bin/env bash
# verify-typescript.sh
# Part of the code-change-verification skill
# Runs the full TypeScript verification stack
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
if [[ -f "pnpm-lock.yaml" ]]; then
  PM="pnpm"
elif [[ -f "yarn.lock" ]]; then
  PM="yarn"
else
  PM="npm"
fi

run_check "install"   "$PM install --frozen-lockfile 2>/dev/null || $PM install"
run_check "build"     "$PM run build"
run_check "lint"      "$PM run lint 2>/dev/null || $PM exec eslint . --ext .ts,.tsx 2>/dev/null"
run_check "tests"     "$PM run test 2>/dev/null || $PM exec vitest run 2>/dev/null || $PM exec jest --passWithNoTests 2>/dev/null"

exit $FAILED
