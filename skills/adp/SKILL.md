---
name: adp
description: >-
  Runs ADP methodology (Anchor → Delta → Prove) for production diffs in an
  existing repo. Forbids teacher-demo, toy, or bypass hacks. Use when the user
  invokes the namespaced ADP skill (e.g. /cursor-tools-adp) or asks for
  anchor-first / ADP delivery.
disable-model-invocation: true
---

# ADP (Anchor → Delta → Prove)

You are executing the ADP stack. Direction: **repo → diff**, not feature idea → demo.

Methodology file: `.cursor/kits/cursor-tools/ADP.md` or `~/.cursor/kits/cursor-tools/ADP.md`  
(if `KIT_NAME` was overridden at install, use that folder name instead).  
Follow this skill even if the file is missing.

## Hard bans

- Do **not** skip ahead to feature code before Anchor is named.
- Do **not** produce teaching samples, toy/one-off modules, or a parallel mini-framework.
- Do **not** bypass the anchored path “just to make it work.”
- Do **not** run LLM review loops, refactor option menus, or “quality pass” theater after a green oracle.
- Do **not** claim done without a green project oracle (or an explicit blocker that only the user can resolve).
- Prefer index + grep/glob; no bulk-read of the whole repo.

## Stack (strict order)

### 1) Intent (one line)

Restate the user goal in one sentence.

### 2) Anchor (required before feature code)

Find and **name**:

- existing production path to extend;
- 1–3 neighbor files/modules that define “how this repo already does it”;
- integration point;
- parallel things that must **not** be created.

If Anchor is unclear: search, then ask **only** what blocks naming it. Do not implement the feature yet.

**Greenfield / new module:** Anchor = shape of neighboring modules in this repo (layout, errors, tests, wiring)—not a generic tutorial scaffold.

Output a short **Anchor** block, then continue.

### 3) Delta + forbids

State:

- was → will be;
- touch points along the Anchor path;
- out of scope;
- congruence: same abstraction/error/naming style as the named neighbor unless the user explicitly changes the pattern;
- forbids: no lesson-code, no rewrite of the subsystem, no path bypass, mergeable as-is.

If a product tradeoff is a true blocker, ask once. Do not ask the user to pick refactors for code you are about to write.

### 4) Oracle (Prove)

Define how “merged for real” is proven **in this project**:

- Prefer commands from root `AGENTS.md` (Run these).
- Else detect the project’s normal test/typecheck/lint command relevant to the Delta.
- If no oracle covers the Delta: add the **minimal** failing check along the Anchor (same test style as neighbors), then implement.

Do not treat chat self-assessment as Prove.

### 5) Implement along Anchor only

Write production code only on the anchored path. Match neighbors. No side demo.

### 6) Prove → Stop

Run the oracle. Red → fix along Anchor → re-run. Green → **stop**.

Delivery report (short):

- Anchor used
- Delta applied
- Oracle command + green
- What you deliberately did not touch

No “we could also improve…” unless something remains red or a user-only blocker remains.

## Done criteria

- [ ] Anchor named before feature implementation
- [ ] Delta + forbids stated
- [ ] Oracle defined and executed
- [ ] Green oracle (or explicit user blocker)
- [ ] No teacher/toy/bypass parallel implementation
