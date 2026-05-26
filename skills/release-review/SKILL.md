---
name: release-review
license: Apache-2.0
compatibility: Requires git
metadata:
  version: "1.0.0"
  author: "Luc K. SEGBEDZI"
  repo: "github.com/Komluc/agent-skills-production"
  article: "https://luc.dev/posts/ai-agent-skills"
description: >
  Prepares a complete release review by comparing the previous git tag with
  main. Use when work is complete and ready for a release candidate.
  Do not use for intermediate reviews during active development.
  Requires git in PATH.
---

## Step 1 — Fetch the diff

Run: `scripts/fetch-diff.sh --output /tmp/release-diff.txt`

Exit codes:
- exit 0: diff generated — continue to Step 2
- exit 1: no previous git tag found — ask the user to create a tag first (`git tag v0.0.0 <sha>`)
- exit 2: git not available in PATH — stop and inform the user
- exit 3: missing --output argument — skill configuration error

## Step 2 — Analyze the diff

Read `/tmp/release-diff.txt`. Inspect for:

- Breaking changes in public APIs (removed parameters, changed return types)
- Behavioral regressions in existing functionality
- Missing migration notes for breaking changes
- Feature removals without prior deprecation notice
- Dependency major version bumps without documented rationale

See `references/release-criteria.md` for complete criteria by change type.

## Step 3 — Release decision

Start from **"safe to release"**. Move to **"blocked"** only on concrete evidence
found in the diff — not on suspicion or incomplete information.

Required output format — use exactly this structure:

```
Release readiness review
========================

Release call: 🟢 GREEN — safe to release
```

OR if blocked:

```
Release readiness review
========================

Release call: 🔴 BLOCKED

Unblock checklist:
- [ ] [Specific action — cite the exact file:line from the diff as evidence]
- [ ] [Another specific action with diff evidence]
```

Rules:
- Every BLOCKED item must cite a specific line from the diff as evidence
- A BLOCKED call without evidence in the diff is invalid — do not issue it
- GREEN means you found no breaking evidence, not that you skipped the review
