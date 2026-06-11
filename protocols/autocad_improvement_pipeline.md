# AutoCAD Improvement Pipeline (Closed-Loop Self-Learning)

**Version:** 1.0.0 (2026-06-09)
**Owner:** autocad_qa_001 · **Runs under:** autocad_001 (every AutoCAD job)
**Goal:** Make the AutoCAD pipeline learn from every job — capture edits/notes, find the root cause, attribute the mistake to the responsible agent, teach that agent a corrective rule, and verify the fix. Errors never repeat silently.

> ⚙️ **Trigger:** This pipeline runs **automatically whenever the full AutoCAD pipeline starts** (autocad_001 Boot Check Phase 0 calls it to LOAD lessons), and again **at the end of every job** (RETROSPECTIVE to capture new lessons). It is not optional.

---

## The Closed Loop (5 stages)

```
        ┌──────────────────────────────────────────────────┐
        │  AutoCAD job starts (orch_001 → autocad_001)      │
        └───────────────┬──────────────────────────────────┘
                        ▼
   1) LOAD      autocad_qa_001 reads LEDGER.md + every agent_<id>.md
               → injects each routed agent's accumulated rules into Phase 0
               (each specialist MUST read its agent_<id>.md before executing)
                        ▼
   2) WORK      autocad_002..007 execute their phases (per their PROMPT + lessons)
                        ▼
   3) CAPTURE   every correction / iteration / user note is logged to LEDGER.md
               (symptom, the change made, before/after)
                        ▼
   4) ATTRIBUTE autocad_qa_001 finds the ROOT CAUSE and the RESPONSIBLE agent
               (whose scope the error falls in) — names "who erred"
                        ▼
   5) TEACH     a prevention RULE is appended to that agent's agent_<id>.md
               (and to its PROMPT.md if it is a hard rule) → agent "learns"
                        ▼
   VERIFY      re-run / re-check; mark the LEDGER entry RESOLVED only when green
        └──────────────────────────────────────────────────┘  (loop)
```

---

## Stores

| File | Purpose |
|------|---------|
| `protocols/autocad_lessons/LEDGER.md` | Chronological log of EVERY issue: id · date · project · phase · **responsible agent** · symptom · root cause · fix · prevention rule · status |
| `protocols/autocad_lessons/agent_<id>.md` | Per-agent accumulated corrective rules. **Each agent reads its own file before executing** (loaded in LOAD stage). |

### LEDGER entry format
```
### L0NN — <short title>
- date: YYYY-MM-DD
- project: <path or name>
- phase / tool: <Phase N / tool>
- responsible_agent: autocad_00X   ← WHO erred
- symptom: <what went wrong, observable>
- root_cause: <the real reason>
- fix: <what was changed>
- prevention_rule: <one-line rule taught to the agent>
- status: OPEN | RESOLVED
```

### agent_<id>.md rule format
```
- [L0NN] <imperative rule the agent must follow>  (source: <symptom>)
```

---

## Attribution map (which agent owns which error class)
| Error class | Responsible agent |
|-------------|-------------------|
| Wrong backend chosen (ezdxf vs File-IPC vs COM); connection/setup; verification skipped | autocad_001 |
| Geometry wrong (coords, overlaps, leftover entities, fresh-drawing) | autocad_002 |
| Layer/block errors (naming, color, missing layer) | autocad_003 |
| Text/label/dimension errors (placement, MTEXT breaks, Arabic, area claims) | autocad_004 |
| P&ID symbol/connectivity errors | autocad_005 |
| LISP/COM/3D automation errors | autocad_006 |
| Export/format/license-stamp errors (DWG/DXF/PDF) | autocad_007 |

> If an error spans two agents, attribute to the one whose **last action** introduced it, and add a cross-note to the other.

---

## Rules
1. **LOAD before WORK** — no specialist executes before its `agent_<id>.md` rules are in context (autocad_001 enforces).
2. **No silent fixes** — every correction gets a LEDGER entry. Accuracy over speed (Fahad's standard).
3. **Name the mistaker** — every entry has a `responsible_agent`. Blame the role, fix the rule, not the person.
4. **Teach, then verify** — a lesson isn't RESOLVED until the corrected behavior is re-verified (visual/AutoCAD).
5. **Promote hard rules** — recurring or critical lessons get appended to the agent's PROMPT.md, not just its lessons file.
6. **SAOS C1–C7** applies; this pipeline is the C-improvement engine.

## Definition of Done (per job)
- LOAD ran (agents got their lessons), all corrections captured in LEDGER, each new issue attributed + taught + verified, statuses set, hard rules promoted.
