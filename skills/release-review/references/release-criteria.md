# Release Criteria by Change Type

Reference guide for the `release-review` skill.
Load this file when analyzing a diff for release readiness.

---

## 🔴 BLOCKED — Hard stops

These changes require explicit confirmation before release:

### Public API changes
| Change | Decision |
|---|---|
| Removing an existing parameter | BLOCKED — breaking |
| Changing a parameter type | BLOCKED — breaking |
| Changing a return type | BLOCKED — breaking |
| Renaming a public function/method | BLOCKED — breaking |
| Removing a public class or module | BLOCKED — breaking |

### Data integrity
| Change | Decision |
|---|---|
| Database schema migration without rollback script | BLOCKED |
| Removing a data field without migration | BLOCKED |
| Changing serialization format without versioning | BLOCKED |

---

## 🟡 MODERATE — Requires verification

These changes are not automatic blocks but require explicit evidence of handling:

### Compatibility
| Change | Decision |
|---|---|
| Dropping a runtime version (e.g. Python 3.9, Node 18) | MODERATE — verify release notes mention it |
| Major dependency version bump | MODERATE — verify no breaking behavior change |
| New required environment variable | MODERATE — verify deployment docs updated |

### Behavior
| Change | Decision |
|---|---|
| Change to default configuration values | MODERATE — verify documented |
| New rate limits or quota changes | MODERATE — verify documented |
| Authentication flow change | MODERATE — verify backward compatibility |

---

## 🟢 OK — Safe to release

| Change | Decision |
|---|---|
| Adding an optional parameter | OK |
| New public function (additive) | OK |
| Bug fix with test coverage | OK |
| Documentation update | OK |
| Dependency patch/minor version bump | OK |
| Deprecation notice (not removal) | OK if notice is in release notes |
| Performance improvement | OK |
| New feature behind a feature flag | OK |

---

## General rule

**Start from GREEN. Move to BLOCKED only on concrete evidence.**

A BLOCKED call must:
1. Cite the specific file and line number from the diff
2. Name the exact rule from this document being violated
3. Propose the specific action to unblock

A BLOCKED call without these three elements is not a valid BLOCKED call.

---

## OHADA-specific rules (West/Central Africa)

For financial skills or legal document generation targeting OHADA jurisdictions
(TG, CI, SN, CM, GN, BJ, and 14 other member states):

| Change | Decision |
|---|---|
| Change to OHADA chart of accounts structure | BLOCKED — requires compliance review |
| Change to financial statement format | BLOCKED — verify OHADA compliance |
| New currency handling | MODERATE — verify XOF/XAF handling |
