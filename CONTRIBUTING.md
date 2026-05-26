# Contributing to agent-skills-production

Thank you for contributing. Every skill in this repo is used in real
production systems — quality standards are non-negotiable.

---

## Before submitting a skill

### 1. The skill must pass validation

```bash
npm install -g skills-ref
skills-ref validate ./skills/<your-skill>/
```

Zero errors. Zero warnings. If `skills-ref validate` fails, the PR will not be merged.

### 2. The description must be routing metadata, not a summary

The description decides when the agent activates the skill. It must state:
- **What** the skill does (the action)
- **When** to trigger it (specific conditions)
- **When NOT** to trigger it (explicit exclusions)

```yaml
# ❌ Too vague
description: Helps with financial documents.

# ✅ Production-grade
description: >
  Generates a compliant financial report in IFRS, GAAP, or OHADA format.
  Use when the user requests a financial report, compliance document, or
  regulated financial output. Do not use for exploratory analysis or
  informal summaries.
```

### 3. Scripts must be auditable

Every script in `scripts/` must:
- [ ] Have no hardcoded credentials, API keys, or URLs (except official docs)
- [ ] Document all exit codes in comments at the top
- [ ] Handle errors explicitly — no silent failures
- [ ] Scope filesystem writes to `/tmp/` only
- [ ] Be readable by a security-conscious engineer in under 5 minutes

### 4. Failure modes must be explicit

Every step that calls a script must document what to do on each exit code.
"If exit code != 0, stop" is not sufficient — name the specific codes.

### 5. The skill must be versioned

```yaml
metadata:
  version: "1.0.0"
  author: "Your Name"
  changelog: "1.0.0 - initial release"
```

---

## Skill structure

```
skills/<skill-name>/
├── SKILL.md              # Required — frontmatter + instructions
├── scripts/              # Optional — executable files
│   └── *.sh / *.py / *.js
├── references/           # Optional — supplementary docs
│   └── *.md
└── assets/               # Optional — templates, data
```

The `name` field in `SKILL.md` must exactly match the directory name.

---

## PR process

1. Fork the repo
2. Create a branch: `skill/<skill-name>` or `fix/<skill-name>-<issue>`
3. Add or update the skill
4. Run `skills-ref validate ./skills/<skill-name>/`
5. Test the skill manually with Claude Code or Codex
6. Open a PR with:
   - What the skill does (one paragraph)
   - Which platforms you tested it on
   - Any known limitations

---

## What will be rejected

- Skills with hardcoded secrets or API keys
- Skills whose description does not include explicit exclusion conditions
- Scripts without documented exit codes
- Skills that write outside `/tmp/`
- Skills where `skills-ref validate` fails

---

## License

By contributing, you agree that your contribution will be licensed under Apache 2.0.
