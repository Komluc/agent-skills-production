#!/usr/bin/env bash
# fetch-diff.sh
# Part of the release-review skill
# https://github.com/Komluc/agent-skills-production
#
# Usage:
#   scripts/fetch-diff.sh --output <path>
#
# Exit codes:
#   0 — success, diff written to <path>
#   1 — no previous git tag found
#   2 — git not available in PATH
#   3 — missing --output argument

set -euo pipefail

# ── Check git availability ───────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  echo "ERROR: git not found in PATH" >&2
  echo "Install git and retry." >&2
  exit 2
fi

# ── Parse arguments ──────────────────────────────────────────────────────────
OUTPUT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      if [[ -z "${2:-}" ]]; then
        echo "ERROR: --output requires a value" >&2
        exit 3
      fi
      OUTPUT="$2"
      shift 2
      ;;
    --help|-h)
      echo "Usage: $0 --output <path>"
      echo ""
      echo "Generates a git diff between the previous tag and HEAD."
      echo "Writes stat summary + full diff to <path>."
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1" >&2
      echo "Usage: $0 --output <path>" >&2
      exit 3
      ;;
  esac
done

if [[ -z "$OUTPUT" ]]; then
  echo "ERROR: --output is required" >&2
  echo "Usage: $0 --output <path>" >&2
  exit 3
fi

# ── Verify we are in a git repo ──────────────────────────────────────────────
if ! git rev-parse --git-dir &>/dev/null; then
  echo "ERROR: not inside a git repository" >&2
  exit 1
fi

# ── Find the previous tag ────────────────────────────────────────────────────
PREV_TAG=$(git describe --tags --abbrev=0 HEAD~1 2>/dev/null || echo "")

if [[ -z "$PREV_TAG" ]]; then
  echo "ERROR: no previous git tag found." >&2
  echo "" >&2
  echo "Create a starting tag first:" >&2
  echo "  git tag v0.0.0 \$(git rev-list --max-parents=0 HEAD)" >&2
  exit 1
fi

CURRENT_SHA=$(git rev-parse --short HEAD)
echo "Comparing: $PREV_TAG → HEAD ($CURRENT_SHA)"

# ── Generate diff ────────────────────────────────────────────────────────────
{
  echo "# Release diff: $PREV_TAG → HEAD ($CURRENT_SHA)"
  echo "# Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo ""
  echo "## Stat summary"
  echo ""
  git diff "$PREV_TAG"..HEAD --stat --no-color
  echo ""
  echo "## Full diff"
  echo ""
  git diff "$PREV_TAG"..HEAD --no-color
} > "$OUTPUT"

LINE_COUNT=$(wc -l < "$OUTPUT")
echo "Diff written to: $OUTPUT"
echo "Lines: $LINE_COUNT"

if [[ "$LINE_COUNT" -gt 5000 ]]; then
  echo "WARNING: diff is large ($LINE_COUNT lines). Consider reviewing by module." >&2
fi
