---
name: pr-summary-for-stakeholders
license: Apache-2.0
metadata:
  version: "1.0.0"
  author: "Luc K. SEGBEDZI"
  repo: "github.com/Komluc/agent-skills-production"
  article: "https://luc.dev/posts/ai-agent-skills"
description: >
  Translates a GitHub pull request diff into a business-language summary for
  non-technical audiences: product managers, executives, clients, or investors.
  Use when asked to summarize a PR for a stakeholder or non-engineer.
  Do not use for technical code reviews or peer engineering reviews.
---

## Step 1 — Get the PR context

Ask the user for one of:
- A PR URL (e.g. `https://github.com/org/repo/pull/123`)
- A pasted diff
- A description of the changes

If a PR URL is provided and the GitHub CLI (`gh`) is available, run:

```bash
gh pr view <PR_NUMBER> --json title,body,additions,deletions,changedFiles
gh pr diff <PR_NUMBER>
```

If `gh` is not available, ask the user to paste the diff or describe the changes.

## Step 2 — Identify the audience

Before writing, confirm the audience:
- **Executive / board**: focus on business impact, revenue, risk — zero technical detail
- **Product manager**: focus on feature behavior change and user impact
- **Client / investor**: focus on what the product can now do differently
- **Legal / compliance**: focus on regulatory impact and audit trail

Default to "executive" if not specified.

## Step 3 — Write the summary

Use exactly this structure. Fill every field. Do not skip any field.

```
PR Summary — [PR title or brief description]

What changed:
[1-2 sentences maximum. Plain language. No file names, function names,
or technical terms. Describe the change as a user or business observer would.]

Why it matters:
[1-2 sentences. Business value, user benefit, or risk reduction.
Quantify if possible: "reduces processing time by ~30%", "enables X"]

Risk level: [Low / Medium / High]
[One sentence justification. What could go wrong and how likely is it?]

What to monitor after release:
[Specific metrics or behaviors to watch. Or "Nothing additional required."
Never leave this blank — always name at least one thing.]
```

## Step 4 — Final check before output

Before sending the summary, verify:
- [ ] No file names mentioned
- [ ] No function or class names mentioned
- [ ] No line numbers mentioned
- [ ] No jargon (API, refactor, dependency, merge, etc.)
- [ ] Risk level is justified, not assumed
- [ ] "What to monitor" is specific, not generic

If any check fails, rewrite that section before outputting.
