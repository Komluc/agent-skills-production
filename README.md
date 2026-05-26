# agent-skills-production

Production-grade agent skills for Claude Code, OpenAI Codex, Gemini CLI, and every platform that implements the [Agent Skills open standard](https://agentskills.io).

Built by **Luc K. SEGBEDZI** — AI Systems Engineer & Blockchain Architect, Founder of [MGS (MA Group Solutions)](https://github.com/Komluc) · Lomé, Togo.

Companion repo to the article: [AI Agent Skills: What They Are and How They Work](https://luc.dev)

---

## What this repo is

A curated library of SKILL.md files that work across 26+ platforms — same format, different installation paths.

Every skill here follows four rules:
1. **Description as routing metadata** — precise trigger condition, explicit exclusions
2. **Model vs scripts split** — deterministic shell work in `scripts/`, judgment in the body
3. **Explicit failure modes** — every exit code documented, every error handled
4. **Versioned like code** — `metadata.version` in frontmatter, changelog inline

---

## Skills in this repo

| Skill | What it does | Platforms |
|---|---|---|
| [`release-review`](./skills/release-review/) | Full release review: previous tag vs main → GREEN / BLOCKED | All |
| [`pr-summary-for-stakeholders`](./skills/pr-summary-for-stakeholders/) | Translates a PR diff into business-language summary | All |
| [`code-change-verification`](./skills/code-change-verification/) | Runs format, lint, typecheck, and tests before any commit | All |
| [`financial-report-generator`](./skills/financial-report-generator/) | Generates compliant financial reports (IFRS, GAAP, OHADA) | All |

---

## Installation

### Claude Code

```bash
# User-global (available in all your projects)
mkdir -p ~/.claude/skills
git clone https://github.com/Komluc/agent-skills-production.git /tmp/asp
cp -r /tmp/asp/skills/<skill-name> ~/.claude/skills/

# Project-local (versioned with your repo)
mkdir -p .claude/skills
cp -r /tmp/asp/skills/<skill-name> .claude/skills/
```

### OpenAI Codex

```bash
# User-global
mkdir -p ~/.codex/skills
git clone https://github.com/Komluc/agent-skills-production.git /tmp/asp
cp -r /tmp/asp/skills/<skill-name> ~/.codex/skills/

# Project-local
mkdir -p .codex/skills
cp -r /tmp/asp/skills/<skill-name> .codex/skills/
```

### Gemini CLI / Any platform using the open standard

```bash
# Cross-platform path — read by Codex, Gemini CLI, and others
mkdir -p ~/.agents/skills
git clone https://github.com/Komluc/agent-skills-production.git /tmp/asp
cp -r /tmp/asp/skills/<skill-name> ~/.agents/skills/
```

### Install all skills at once

```bash
git clone https://github.com/Komluc/agent-skills-production.git
cd agent-skills-production

# Claude Code
cp -r skills/* ~/.claude/skills/

# Codex
cp -r skills/* ~/.codex/skills/

# Cross-platform
cp -r skills/* ~/.agents/skills/
```

---

## Validate before using

```bash
# Install the official validator
npm install -g skills-ref

# Validate one skill
skills-ref validate ./skills/release-review

# Validate all skills
for skill in skills/*/; do
  echo "Validating $skill..."
  skills-ref validate "./$skill"
done
```

---

## Platform path reference

| Agent | User skills | Project skills |
|---|---|---|
| **Claude Code** | `~/.claude/skills/` | `.claude/skills/` |
| **Codex CLI** | `~/.codex/skills/` | `.codex/skills/` |
| **Gemini CLI / Standard** | `~/.agents/skills/` | `.agents/skills/` |
| **Cursor** | N/A | `.cursor/skills/` |

The `SKILL.md` format is identical across all platforms. Only the installation path changes.

---

## AGENTS.md pattern

Drop this in your repo root to make skills mandatory in Codex:

```markdown
# AGENTS.md

## Mandatory skill usage

- Use `$implementation-strategy` before editing runtime or API changes.
- Run `$code-change-verification` when runtime code, tests, or build behavior changes.
- Use `$release-review` when work is complete and ready for a release candidate.
- Use `$pr-summary-for-stakeholders` when work is ready for non-technical review.

## Build and test commands

- Add your project-specific commands here
```

See [`examples/AGENTS.md`](./examples/AGENTS.md) for a complete example.

---

## Security

Every skill in this repo has been audited for:
- No hardcoded credentials or API keys
- No undocumented network calls
- Filesystem writes scoped to `/tmp/` only
- Explicit exit codes — no silent failures

Before installing any third-party skill (including from this repo), run:

```bash
# Read SKILL.md — check for out-of-scope instructions
cat <skill-dir>/SKILL.md

# Read every script
cat <skill-dir>/scripts/*.sh

# Check for hardcoded URLs
grep -r "http" <skill-dir>/

# Check for credential access
grep -r "API_KEY\|TOKEN\|SECRET\|~/.ssh" <skill-dir>/
```

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

Skills must pass `skills-ref validate` before any PR is merged.

---

## License

Apache 2.0 — see [LICENSE](./LICENSE).

---

*Luc K. SEGBEDZI — AI Systems Engineer & Blockchain Architect*
*Founder, MGS (MA Group Solutions) · Lomé, Togo*
*[luc.dev](https://luc.dev) · [github.com/Komluc](https://github.com/Komluc)*
