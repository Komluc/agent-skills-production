---
name: financial-report-generator
license: Apache-2.0
metadata:
  version: "1.2.0"
  author: "Luc K. SEGBEDZI"
  repo: "github.com/Komluc/agent-skills-production"
  article: "https://luc.dev/posts/ai-agent-skills"
  changelog: "1.2.0 - OHADA support (TG/CI/SN/CM) · 1.1.0 - cache fallback · 1.0.0 - IFRS+GAAP"
description: >
  Generates a compliant financial report in IFRS, GAAP, or OHADA format.
  Use when the user requests a financial report, compliance document, accounting
  export, or any regulated financial output. Covers IFRS, GAAP, and OHADA
  standards. Do not use for informal financial summaries, exploratory analysis,
  or BI dashboards.
---

## Step 1 — Identify the standard and jurisdiction

Ask the user:
1. **Accounting standard**: IFRS / GAAP / OHADA
2. **Jurisdiction** (for OHADA): which member state (TG, CI, SN, CM, GN, BJ, etc.)
3. **Report type**: Income Statement / Balance Sheet / Cash Flow / Notes / Full set
4. **Period**: fiscal year end date and comparative period

See `references/standards-overview.md` for jurisdiction → standard mapping.

If the user doesn't know their standard, use this heuristic:
- Listed company, international operations → IFRS
- US-based company → GAAP
- West/Central Africa entity → OHADA

## Step 2 — Collect the financial data

Request from the user:
- Trial balance or chart of accounts export (CSV, XLSX, or paste)
- Any adjusting entries not yet booked
- Prior period comparative figures (if available)

If data is provided as a file, read it and verify:
- All accounts sum to zero (debit = credit)
- No missing account codes against the expected chart of accounts
- Currency is consistent

If validation fails, report all discrepancies before continuing.

## Step 3 — Generate the report

Apply the appropriate template from `references/`:

| Standard | Template file |
|---|---|
| IFRS | `references/ifrs-templates.md` |
| GAAP | `references/gaap-templates.md` |
| OHADA | `references/ohada-templates.md` |

Rules for all standards:
- Round to the nearest whole currency unit (no cents in formal reports)
- All figures in thousands unless the entity is below the threshold
- Label the comparative column clearly
- Flag any material items (>5% of total assets or revenue)

## Step 4 — Validation before output

Before presenting the report, verify:
- [ ] Balance sheet balances (Assets = Liabilities + Equity)
- [ ] Net income matches between Income Statement and Balance Sheet
- [ ] Cash flow ending balance matches Balance Sheet cash
- [ ] All required disclosures are present for the selected standard

If any check fails: report the discrepancy and do NOT output the report.
Request corrected input data.

## Step 5 — Output

Produce the report in this order:
1. Cover page (entity name, period, standard, preparer)
2. Financial statements (in standard order for the selected framework)
3. Notes (mandatory disclosures only — no boilerplate)

Add this footer to every report:

```
Prepared using: financial-report-generator v1.2.0
Standard: [IFRS / GAAP / OHADA]
This document is a draft. Review by a qualified accountant is required
before filing or external distribution.
```
