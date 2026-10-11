---
name: andreev-sy-cursor-tools-adp
description: >-
  Runs ADP (Acceptance → Anchor → Delta → Prove) for production diffs. Hard-stops
  without cited Anchor, real oracle, or full acceptance evidence. Use when the
  user invokes /andreev-sy-cursor-tools-adp or asks for ADP / anchor-first delivery.
disable-model-invocation: true
---

# ADP (Acceptance → Anchor → Delta → Prove)

Direction: **repo → diff**. Not feature idea → demo.  
Methodology: `.cursor/kits/andreev-sy/cursor-tools/ADP.md`.

Goal of a finished run: every acceptance item is done with evidence, touched code matches the neighbor (no toy/bypass/dead leftovers), oracle is green. If the user later asks “all done / quality OK?”, the truthful answer must already be yes — because you closed gaps **before** stopping, not after they chase you.

## Hard stops

**STOP A — no Anchor.**  
Cite **existing** paths (glob/grep/read). If you cannot: ask and **stop**. No feature code, no assumed module, no demo.

**STOP B — no Oracle.**  
Oracle = command from `.cursor/kits/andreev-sy/cursor-tools/project.md` → Verify → **Run these**, or a command the user stated.  
If neither: **stop** (bootstrap or ask for one command). Do not invent tests to unblock.

**STOP C — Oracle not green.**  
Do not claim done unless you ran the oracle this session and it succeeded (or user waived after a real blocker).

**STOP D — Acceptance incomplete.**  
Do not claim done while any AC lacks evidence, or while known gaps remain in the touched diff (dead code, duplicate of neighbor, path bypass, unfinished AC). Fix first; do not ask the user to discover it.

**STOP E — Vague request.**  
If the request is fuzzy, incomplete, or needs product guesses: **do not implement and do not guess**.  
Enter **Clarify** (below): ask sharp questions, refine Acceptance, repeat until every AC is precise and checkable.  
Only then continue to Anchor. Prefer a short blocking questionnaire over essays.

## Hard bans

- Teaching samples, toy/one-off modules, parallel mini-frameworks.
- Bypassing the anchored path “just to make it work.”
- Guessing intent / picking a default interpretation to “just start coding.”
- Silently dropping or narrowing the user’s request.
- LLM review loops, refactor option menus, “want me to also…?” after green.
- Bulk-read of the whole repo.
- Declaring done and hoping the user will QA.

## Stack (order)

### 0) Intake (before code)

Cursor has **no** custom skill form UI. `AskQuestion` cards often missing in Agent — do **not** dump English option ids into chat.

If the user only invoked this skill (or message has no clear Need + constraints):

1. Optionally try `AskQuestion` **once** (Russian labels). If unavailable / fails → step 2.
2. **Default:** post exactly this fill-in block (Russian), then **stop and wait**. No code. No long preface.

````markdown
Заполни и пришли одним сообщением:

**Need:** (что должно заработать)
**Anchor:** (путь/сосед) или напиши: найди в репо
**Prove:** `project.md` | команда: … | нужен bootstrap
**Нельзя:** (через запятую, что актуально)
- новый framework
- one-off скрипт
- rewrite подсистемы
- обход слоя якоря
- (другое: …)
````

3. After they reply → Intent → Acceptance. Still vague → Clarify (STOP E).

Skip step 0 only if Need + constraints are already clear enough to draft Acceptance.

### 1) Intent — one sentence

### 2) Acceptance + Clarify (required before any feature code)

Draft numbered, checkable ACs covering the **full** request. Mark out of scope explicitly.

An AC is ready only if someone else could verify it without asking what you meant (concrete behavior, boundaries, success condition).

If anything is vague → **Clarify loop** (no Anchor/Delta/code yet):

1. List what is unclear (bullets).  
2. Ask only blocking questions (options when useful).  
3. After answers: rewrite Acceptance.  
4. Still vague? Repeat. Never fill gaps with assumptions.

When Acceptance is precise: output final **Acceptance** (AC1, AC2, …) and proceed.

### 3) Anchor

Production path, 1–3 neighbor files, integration point, what must not be created.  
**Anchor** block with cited paths. If STOP A → stop.

### 4) Delta + forbids

was → will be; touch points; map each AC → intended touch; congruence with neighbor; mergeable as-is.  
True product blocker → one question. No refactor menus.

### 5) Oracle

Name the exact command (`project.md` or user). If STOP B → stop.

### 6) Implement along Anchor only

Implement **every** AC. Match neighbor style/errors/layering.

### 7) Close the diff (same turn — not a user loop)

Before/with Prove, on code **you** touched:

1. **Evidence** — for each AC: `done` + proof (path/symbol and/or oracle behavior). Any missing → implement, do not stop.  
2. **Diff quality** — remove dead/unused leftovers you introduced; no duplicate of what the neighbor already does; no bypass of the anchor layer; same abstraction level as neighbor. Fix now.  
3. Do not present options. Do not ask “should I refactor?”.

### 8) Prove → Stop

Run oracle. Red → fix on Anchor → re-run.  
Green + full evidence + clean diff → **stop**.

Delivery report (short):

- Acceptance table: AC → evidence  
- Anchor used  
- Oracle command + green  
- What you deliberately did not touch (out of scope)

## Done criteria

- [ ] Acceptance precise (clarified until checkable — or still in Clarify, no code)
- [ ] Every AC evidenced (or stopped at STOP D)
- [ ] Anchor cited (or STOP A)
- [ ] Oracle green (or STOP B/C / waiver)
- [ ] No guessing; no teacher/toy/bypass; no junk left in the diff
