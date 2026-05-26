# AGENTS.md
# Example for a full-stack project using agent-skills-production
# Copy to your repo root and adapt to your stack

## Overview

This file configures mandatory skill usage for Codex and other agents
working in this repository. Skills are in `.agents/skills/` (cross-platform)
or `.codex/skills/` (Codex-specific).

---

## Mandatory skill usage

### Before touching code
- Use `$implementation-strategy` before editing runtime or API changes
  (if you have this skill installed — see github.com/openai/skills)

### When changing code
- Run `$code-change-verification` when runtime code, tests, or build
  behavior changes
- Do NOT run for docs-only changes (README, comments, CHANGELOG)

### Before opening a PR
- Use `$pr-summary-for-stakeholders` to generate the PR description
- Use `$release-review` when the work is a release candidate

---

## Build and test commands

Adapt these to your actual stack. Remove sections that don't apply.

### Python
```bash
make format      # ruff format
make lint        # ruff check
make typecheck   # pyright or mypy
make tests       # pytest
```

### TypeScript / Node
```bash
pnpm install
pnpm build
pnpm lint
pnpm test
```

### Both (monorepo)
Run Python checks first, then TypeScript. Both must pass.

---

## Code conventions

- TypeScript: zero `any` — if you see one, fix it
- Python: type hints on all public functions
- Functions: under 40 lines — split if longer
- No secrets or API keys in code — use environment variables

---

## Compatibility rules

- Preserve positional compatibility for all public function signatures
- Do not remove optional parameters — deprecate first
- Do not change return types without a major version bump
- New required environment variables must be documented in `.env.example`

---

## PR conventions

- Title format: `[type]: short description` (feat / fix / chore / docs)
- Every PR must have a description — use `$pr-summary-for-stakeholders`
- Link to the relevant issue if one exists
- Tests required for all bug fixes

---

## Skills installed in this repo

| Skill | Path | Trigger |
|---|---|---|
| `code-change-verification` | `.agents/skills/` | Any runtime code change |
| `pr-summary-for-stakeholders` | `.agents/skills/` | Before opening a PR |
| `release-review` | `.agents/skills/` | Before a release candidate |
| `financial-report-generator` | `.agents/skills/` | Financial document requests |
