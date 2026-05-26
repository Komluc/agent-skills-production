#!/usr/bin/env bash
# detect-stack.sh
# Part of the code-change-verification skill
# Detects the project stack from config files at repo root
#
# Output (stdout): python | typescript | python+typescript | unknown
# Exit code: always 0

set -euo pipefail

HAS_PYTHON=false
HAS_TYPESCRIPT=false

# Python indicators
if [[ -f "pyproject.toml" ]] || [[ -f "Makefile" ]] || [[ -f "setup.py" ]] || [[ -f "requirements.txt" ]]; then
  HAS_PYTHON=true
fi

# TypeScript indicators
if [[ -f "package.json" ]] || [[ -f "tsconfig.json" ]] || [[ -f "pnpm-lock.yaml" ]] || [[ -f "yarn.lock" ]]; then
  HAS_TYPESCRIPT=true
fi

if $HAS_PYTHON && $HAS_TYPESCRIPT; then
  echo "python+typescript"
elif $HAS_PYTHON; then
  echo "python"
elif $HAS_TYPESCRIPT; then
  echo "typescript"
else
  echo "unknown"
fi
