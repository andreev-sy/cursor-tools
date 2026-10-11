---
name: andreev-sy-cursor-tools-project-bootstrap
description: >-
  One-time ADP setup: finds verify commands, asks run/don't-run, writes
  .cursor/kits/andreev-sy/cursor-tools/project.md and ensures root AGENTS.md
  links to it without overwriting existing AGENTS.md content. Use when the user
  invokes /andreev-sy-cursor-tools-project-bootstrap or asks to bootstrap project
  verify for ADP.
disable-model-invocation: true
---

# Project bootstrap (for ADP Prove)

Write kit-owned project facts for `/andreev-sy-cursor-tools-adp`. Do **not** replace the user's `AGENTS.md`.

- Output file: `.cursor/kits/andreev-sy/cursor-tools/project.md`
- Template: `.cursor/kits/andreev-sy/cursor-tools/templates/project.template.md`
- Docs: `.cursor/kits/andreev-sy/cursor-tools/ADP.md`

## Hard rules

- Do not edit application source.
- Do not bulk-read the repo.
- Do **not** overwrite or rewrite the whole root `AGENTS.md`. Only ensure a short link to `project.md` exists.
- `project.md` ≤ ~60 lines; **Run these** must contain ≥1 real command (not a placeholder).
- Do not invent a fake test suite. If nothing exists, ask the user for one “done” command.
- Re-run: update `project.md` in place; do not duplicate the AGENTS.md link.

## Workflow

### 1. Scan

Manifests, CI, lint/test/typecheck/format scripts, risky targets (migrations, deploy, secrets).

### 2. Report

Stack one-liner, candidate verify commands, risks.

### 3. Ask (blocking)

1. Which commands go under **Run these** (need ≥1) vs **Never run these**  
2. Don't-touch / ask-first  
3. What to keep out of `project.md`

### 4. Write `.cursor/kits/andreev-sy/cursor-tools/project.md`

```markdown
# andreev-sy/cursor-tools project

## Project / stack
## Verify
### Run these
- <at least one real command>
### Never run these
## Boundaries
### Don't touch
### Ask first
## Neighbors (optional)
## ADP
- Use `/andreev-sy-cursor-tools-adp` (Acceptance → Anchor → Delta → Prove). No teacher-demo or parallel toy code.
## User prefs
```

### 5. Link from root `AGENTS.md`

Link block (exact idea; keep short):

```markdown
## andreev-sy/cursor-tools

Verify and boundaries: [.cursor/kits/andreev-sy/cursor-tools/project.md](.cursor/kits/andreev-sy/cursor-tools/project.md)
```

- If `AGENTS.md` **missing**: create it with a title + this block only.
- If `AGENTS.md` **exists** and already links to `.cursor/kits/andreev-sy/cursor-tools/project.md`: leave `AGENTS.md` unchanged.
- If `AGENTS.md` **exists** without that link: **append** the block at the end. Do not delete or rewrite other content.

## Done criteria

- [ ] User answers collected (or already given)
- [ ] `project.md` written, short, with ≥1 Run these command
- [ ] `AGENTS.md` contains a link to that file (created or appended, never fully overwritten)
