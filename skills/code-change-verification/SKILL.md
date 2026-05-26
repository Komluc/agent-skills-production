---
name: code-change-verification
license: Apache-2.0
metadata:
  version: "1.0.0"
  author: "Luc K. SEGBEDZI"
  repo: "github.com/Komluc/agent-skills-production"
  article: "https://luc.dev/posts/ai-agent-skills"
description: >
  Runs the full verification stack (format, lint, typecheck, tests) when
  changes affect runtime code, tests, or build behavior. Use before committing
  or opening a PR. Do not trigger for documentation-only changes, config
  comments, or README edits.
---

## Step 1 — Detect the project type

Check which config files exist at the repo root:

```bash
scripts/detect-stack.sh
```

The script outputs one of: `python`, `typescript`, `python+typescript`, `unknown`.

If output is `unknown`: ask the user which stack to verify before continuing.

## Step 2 — Run verification

Run the appropriate commands based on detected stack.

### Python stack

```bash
scripts/verify-python.sh
```

Expected output on success:
```
[format]    ✅ passed
[lint]      ✅ passed
[typecheck] ✅ passed
[tests]     ✅ passed (N tests, 0 failed)
```

### TypeScript stack

```bash
scripts/verify-typescript.sh
```

Expected output on success:
```
[install]   ✅ passed
[build]     ✅ passed
[lint]      ✅ passed
[tests]     ✅ passed (N tests, 0 failed)
```

### Both stacks

Run Python script first, then TypeScript. Both must pass before proceeding.

## Step 3 — Handle results

**If all checks pass:**
Report: `Verification complete — all checks passed. Safe to commit.`
No further action required.

**If any check fails:**
- Read the script output in full
- Identify the failing check (format / lint / typecheck / tests)
- Report in this exact format:

```
Verification failed — [N] check(s) failed:

❌ [check name]: [error summary in one line]
   Fix: [specific action to take]

❌ [check name]: [error summary in one line]
   Fix: [specific action to take]

Do not commit until all checks pass.
```

- Do NOT attempt to auto-fix errors unless the user explicitly asks
- Do NOT skip a failing check and proceed — report it and stop

## Error reference

See `references/common-errors.md` for known error patterns and their fixes.
