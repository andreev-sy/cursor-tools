---
name: project-bootstrap
description: >-
  One-time project setup for ADP: scans verify commands and boundaries; asks
  run/don't-run preferences; writes a short root AGENTS.md for the Prove layer.
  Use when the user invokes the namespaced bootstrap skill
  (e.g. /cursor-tools-project-bootstrap) or asks to bootstrap AGENTS.md for ADP.
disable-model-invocation: true
---

# Project bootstrap (for ADP Prove)

Produce a **short** root `AGENTS.md` so the ADP skill has project-native Verify/Boundaries.  
Methodology: `.cursor/kits/cursor-tools/ADP.md`.  
Template (if present): `.cursor/kits/cursor-tools/templates/AGENTS.template.md`.

## Hard rules

- Do **not** edit application source or refactor.
- Do **not** bulk-read the repo; manifests, CI, scripts, 2–3 sample paths max.
- **`AGENTS.md` ≤ ~60 lines** — commands, deny-lists, pointers.
- Update in place on re-run; never inflate.
- Prefer `.cursor/kits/cursor-tools/templates/AGENTS.template.md` if available; else the outline below.

## Workflow

### 1. Scan

Look for what exists: package/manifest files, CI, lint/test/typecheck/format scripts, test locations, risky targets (migrations, deploy, secrets).

### 2. Report

Stack one-liner, verify commands found, risks, gaps.

### 3. Ask (blocking only)

1. Which commands **run** after changes vs **never** unless asked  
2. Don't-touch / ask-first  
3. Anything to keep out of always-on `AGENTS.md`

Skip questions already answered.

### 4. Write root `AGENTS.md`

```markdown
# AGENTS.md

## Project / stack
## Verify
### Run these
### Never run these
## Boundaries
### Don't touch
### Ask first
## Neighbors (optional pointers)
## ADP
- Use `/cursor-tools-adp`: Anchor → Delta → Prove. No teacher-demo or parallel toy code.
## User prefs
```

Omit empty fluff. Remind user to commit `AGENTS.md`.

## Done criteria

- [ ] Short report + answers collected
- [ ] Root `AGENTS.md` written, ≤ ~60 lines, Prove-oriented
