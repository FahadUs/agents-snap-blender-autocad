---
protocol: preflight
version: 1.0
status: mandatory
owner: org_001 + exec_001
effective_date: 2026-04-22
applies_to: every agent invocation that touches code, config, or data
---

# Pre-flight Checklist

Every agent MUST complete this checklist BEFORE touching code on any project. Skipping steps is how we get P06 (`autoflush_events`), P09 (`router_race`), and P15 (`seed_order`) over and over.

## The checklist

### 1. Read CLAUDE.md at project root
```bash
# Example:
cat C:/FahadCompanyConst/CLAUDE.md
```

If the file does not exist, that itself is a signal — per `feedback_new_project_workflow.md`, CLAUDE.md comes first, before implementation. Stop and create one (or flag the orchestrator) rather than coding blind.

What you are looking for:
- Tech stack + versions
- Port assignments
- DB credentials (defaults are usually `admin` per `feedback_environment_conventions.md`)
- Conventions (naming, folders, linting)
- Active gotchas (Windows-specific, tenant-specific)

### 2. Read the 3 most recent handoffs
```bash
ls projects/<project>/handoffs/ | sort -r | head -3
```

For each, look at `next_agent_should`, `gotchas_discovered`, `assumptions`, and `incomplete`. Details in `protocols/handoff.md` section 3.

If `projects/<project>/handoffs/` does not exist, you are the first agent. Create the folder; write a handoff when you finish.

### 3. Scan the shared pitfall DB for your category

```bash
ls C:/Users/fahad/OneDrive/Desktop/AgentsSnapBlenderAutoCAD/pitfalls/
# python_env | fastapi_async | frontend | saudi_specific | rbac | seed | operations
```

Read EVERY file under the category(ies) relevant to your stack. Categories:

| Stack / Topic you are touching          | Required pitfall categories to scan       |
|-----------------------------------------|-------------------------------------------|
| Python env, Windows, CLI, Bash          | `python_env`                              |
| FastAPI, SQLAlchemy async, Pydantic     | `fastapi_async`                           |
| Next.js, React, UI, CORS, frontend      | `frontend`                                |
| Arabic text, phones, addresses, KSA law | `saudi_specific`                          |
| RBAC, roles, permissions, admin bypass  | `rbac`                                    |
| Seed scripts, fixtures, data loading    | `seed`                                    |
| Wave planning, agent budgets, parallel  | `operations`                              |
| Security, auth, encryption, PDPL       | `security`                                |
| Design, screenshots, visual extraction | `visual_extraction`                       |
| Architecture, multi-agent pipelines    | `architecture`                            |

When in doubt, scan more. The cost of reading a pitfall is ~5 seconds; the cost of re-discovering one is hours.

Also consult `index.json` for a full machine-readable list with tags.

### 4. Check your specialization file

```bash
cat C:/Users/fahad/OneDrive/Desktop/AgentsSnapBlenderAutoCAD/specializations/profiles/<your_agent_id>.md
```

Look for:
- Certifications you hold (tells you which `learned_knowledge/` files are authoritative for you).
- Last project you worked on (continuity).
- Known strengths and limitations.

If a new certification has been earned since your last session (check `Last updated:` field), read the linked learned_knowledge files before coding.

### 4b. فحوصات إضافية إلزامية قبل البدء

**Port Registry (P031) — كل مشروع جديد:**
```
اقرأ: C:/Users/fahad/OneDrive/Desktop/AgentsSnapBlenderAutoCAD/protocols/port_registry.md
شغّل: find_free_ports.ps1 للحصول على ports متاحة
⛔ لا تفترض port 8000/3000 — قد تكون مشغولة
```

**JWT Contract — قبل أي عمل على Auth أو Frontend:**
```
تحقق من وجود: contracts/jwt-contract.md
يحتوي: SECRET_KEY، payload fields، storage method، cookie name
⛔ غيابه = لا تبدأ frontend أو auth work
```

**SAST + RBAC — قبل Phase 3:**
```
تحقق من وجود: security/sast-report.md (PASS)
تحقق من وجود: security/rbac-audit.md (PASS)
⛔ غيابهما = لا تبدأ frontend
```

**Startup Check — قبل أي تشغيل:**
```bash
# تحقق من السيرفر قبل tests أو smoke checks
curl -s http://localhost:[PORT]/health
# فشل = لا تشغّل integration tests
```

### 5. Enter Plan Mode for non-trivial tasks

"Non-trivial" means ANY of:
- Multi-file change
- New endpoint, model, migration, or service
- Cross-cutting refactor
- Anything involving auth, billing, or RBAC
- Anything the user phrased with more than one sentence

Plan Mode rules are in `feedback_new_project_workflow.md`. At minimum:
- State the goal in one sentence.
- List the files you will touch with one-line reasons.
- List the new gotchas you expect and how you will handle them.
- Get implicit approval (or explicit, if ambiguous) before touching code.

---

## Exit criteria

You have completed pre-flight when you can answer:

1. What does CLAUDE.md say about this project? (1 sentence)
2. What did the last agent leave me to do? (bullets from `next_agent_should`)
3. Which pitfalls apply to what I am about to build? (list P-ids)
4. Which learned_knowledge files am I certified on, and are any relevant here?
5. Is my plan explicit and approved?

If you cannot answer all five, do not start coding.

---

## Model Selection — مبدأ ثابت

**الموديل المستخدم يتحدد من المستخدم فقط — لا من الوكيل.**

```
المستخدم يختار Sonnet 4.6 → كل الوكلاء الفرعية تعمل بـ Sonnet 4.6
المستخدم يختار Opus 4.7  → كل الوكلاء الفرعية ترث Opus 4.7 تلقائياً
```

**قواعد إلزامية:**
1. لا يكتب أي وكيل model ID داخل الـ prompt أو الكود — الاختيار للمستخدم
2. لا تمرّر `temperature` / `top_p` / `top_k` في API calls — تُعيد 400 error على Opus 4.7
3. إذا احتاج الوكيل قدرات vision عالية الدقة → يستفيد تلقائياً إذا كان المستخدم على Opus 4.7، ويعمل بحدوده إذا كان على Sonnet 4.6

---

## For orchestrators

Orchestrators (exec_001, org_001) should verify pre-flight for each sub-agent they dispatch. A simple check:

- [ ] Did I inject CLAUDE.md into the child's prompt?
- [ ] Did I inject the 3 most recent handoffs?
- [ ] Did I inject the relevant pitfall categories?
- [ ] Did I inject the child's specialization profile?

If yes to all four, the child agent has what it needs to pass its own pre-flight without wasted tool calls.

---

## Common excuses and their rebuttals

| Excuse                                    | Rebuttal                                                                 |
|-------------------------------------------|--------------------------------------------------------------------------|
| "It's a small change."                    | P06 came from a 4-line function. Read pitfalls anyway.                   |
| "I've done this before."                  | Your certification file proves it. Still re-read relevant gotchas.       |
| "No handoffs folder exists."              | Create it. You are writing the first handoff today.                      |
| "CLAUDE.md is out of date."               | Update it as part of your session. That is in the handoff checklist.     |
| "I'm the first agent."                    | Then your pre-flight output seeds the folders for everyone after you.    |
