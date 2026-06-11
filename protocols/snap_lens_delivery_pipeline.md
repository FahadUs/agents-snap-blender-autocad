# Snap Lens Delivery Pipeline

**Version:** 1.1.0
**Owner:** snap_001 (Snap Lens Pipeline Coordinator)
**Entry point:** orch_001 → snap_001
**Scope:** Filters (2D / Geofilters) **and** AR Lenses (Lens Studio) **and** SnapML custom models.
**Goal:** Produce **buildable, publishable** Snap lenses — real Lens Studio projects + production-ready assets, not just specs.

> ⛔ **MANDATORY** for every Snap lens/filter project. No exceptions. This protocol is read by snap_001 before any delegation, and every snap_* agent complies with `protocols/Senior_Agent_Operating_Standard.md` (SAOS C1–C7).

---

## 0. Authoring Reality — what we actually build

| Output type | Tool | Notes |
|-------------|------|-------|
| **Filter / Geofilter** | Snapchat online filter creator / PNG overlay | 2D only, location-bound (Geo), simplest |
| **AR Lens** | **Lens Studio** (desktop, Win/Mac) | Face/World/Hand/Body tracking, 3D, JS/TS scripting, Material Editor |
| **SnapML effect** | Custom NN exported (ONNX/PyTorch) → Lens Studio ML Component | Segmentation, style transfer, classification |
| **Publishing** | Lens Studio Publish → **My Lenses** portal → Snapcode | Sponsored AR via **Snap Ads Manager** |

**Hard platform constraints (verify current values from Snap docs before each project — they change):**
- **Lens size budget** is strict (historically ~8 MB for community lenses; sponsored have separate limits). Treat as a HARD gate.
- **Performance:** must run on low-end devices; target stable FPS. Optimize textures, poly count, draw calls.
- **Review:** every published lens passes Snap's **Lens/Filter Submission Guidelines** (content, safety, IP, no misleading UI).

---

## 1. Phase Map

| Phase | Name | Owner | Primary Deliverable | Gate |
|-------|------|-------|---------------------|------|
| **0** | Master Plan | snap_001 | `docs/plans/00-master-plan.md` | ✅ User approval (HARD) |
| **1** | Strategy & Trends | snap_002 | `docs/01-strategy.md` (trend, audience, lens type, KPI) | snap_001 review |
| **2** | Creative & Storyboard | snap_003 | `docs/02-storyboard.md` + interaction flow | snap_001 review |
| **3** | Asset Production | snap_004 / snap_005 / snap_006 | `assets/` (2D, 3D, materials) | snap_gate_001 |
| **4** | Lens Studio Build | snap_007 | `lens/` project (scene + tracking + scripts) | snap_gate_001 |
| **5** | SnapML (optional) | snap_008 | `ml/` model + ML Component wiring | snap_gate_001 |
| **6** | VFX & Audio | snap_009 | particles + sound integrated | snap_gate_001 |
| **7** | Optimization | snap_010 | size + FPS report | ⛔ **HARD STOP** if over budget |
| **8** | QA & Device Test | snap_011 | `docs/08-qa-report.md` (real devices) | snap_gate_001 |
| **9** | Compliance & Publish | snap_012 | submission package + Snapcode | ⛔ **HARD STOP** if policy fail |
| **10** | Analytics & Iterate | snap_013 | `docs/10-analytics.md` + backlog | snap_001 review |

**Quality gate** `snap_gate_001` runs after Phases 3, 4, 5, 6, 8 — blocks progression on any HIGH issue (no open FAILs).

### 🎮 Game Path (AR Lens Games)
When the project is a **game**, two extra agents activate:
- **snap_014 — Lens Game Designer** (Phase 2, with snap_003): core mechanic + game loop/states + scoring + difficulty + tuning table → `docs/02b-game-design.md`.
- **snap_015 — Gameplay Engineer** (Phase 4, with snap_007): implements GameManager (state machine, spawner+pooling, score/lives/timer, input mapping, collision, difficulty ramp, game-over/retry) → `lens/scripts/`. Reusable template: `protocols/snap_game_templates/GameManager.js`.

Scope = **single-player AR Lens Games** (face/tap/head-driven). **Out of scope:** Snap Games / Bitmoji multiplayer platform (different engine/partner program).

### 💄 Beauty Path (Beauty/Makeup Lenses)
When the project is a **beauty/makeup filter**, activate:
- **snap_016 — AR Beauty & Makeup Specialist** (Phases 3–4, with snap_006/007): يوزّع الإطلالة على مؤثرات Snap الجاهزة (Face Retouch/Eye Color/Color Correction) + Face Mesh makeup. ⚠️ القاعدة الذهبية: المكياج الملتصق بالوجه = **Face Mesh texture على UV**، لا Image على نقطة العين (لا يُعرض).
- **snap_017 — LS File-Format Engineer** (Phase 4 support): تحرير Scene.scene/.mat/GUID نصّيًا **بلا BOM** عند فشل أتمتة GUI.

### 🔍 QA & Retrospective (كل المشاريع)
- **snap_qa_001 — Pipeline QA & Retrospective**: يعمل بعد كل Phase تحت snap_001 — يفحص المخرَج **بصريًا** (هل المؤثر يُرسَم فعلًا؟ لا فقط موجود في Hierarchy)، ينسب كل خلل للوكيل المسؤول، يلقّن الدرس في PROMPT/playbook/pitfalls، ويتحقّق من الإصلاح (حلقة تعلّم مغلقة). يكمّل `snap_gate_001` (البوابة تمنع التقدّم؛ snap_qa_001 يحسّن الوكلاء).

---

## 2. Execution Rules (inherited from system)

1. **Sequential only** — never parallel agent execution.
2. **CLAUDE.md first** — every lens project must have a `CLAUDE.md` from `protocols/CLAUDE_snap_lens_template.md` before Phase 1.
3. **Phase 0 mandatory** — `docs/plans/00-master-plan.md` approved before any production agent runs.
4. **Plan before execution** — each agent writes a detailed plan (every file/asset/script) before producing.
5. **No open FAILs** — a Phase does not close while a HIGH issue is open, even if it's a harness artifact.
6. **Monitor at end of each Phase** — snap_001 prints a bullet report + suggestions and waits for user confirmation between Phases.
7. **SAOS C1–C7** — every output is standards-grounded, ASK-don't-guess, methodology-driven, coverage-traceable, HARD-STOP before handoff, clean-encoded, passes Definition of Done.

---

## 3. Standard Lens Project Structure

```
<LensProject>/
├─ CLAUDE.md                       ← from CLAUDE_snap_lens_template.md
├─ docs/
│   ├─ plans/00-master-plan.md
│   ├─ 01-strategy.md
│   ├─ 02-storyboard.md
│   ├─ 08-qa-report.md
│   └─ 10-analytics.md
├─ assets/
│   ├─ 2d/        (textures, overlays, geofilter PNGs, icons, CTA)
│   ├─ 3d/        (models .fbx/.glb, rigs, animations)
│   └─ materials/ (shader graphs, material specs)
├─ ml/            (SnapML: training notebook, exported model, labels)
├─ lens/          (Lens Studio project: scene, scripts/ .ts, resources)
├─ build/         (exported .lns / published artifacts)
└─ submission/    (snapcode, store copy, screenshots, policy checklist)
```

---

## 4. Phase Detail

### Phase 1 — Strategy & Trends (snap_002)
- Trend scan (current Snap AR trends, format, what's performing).
- Target audience, region (Geo relevance), use occasion.
- Lens type decision: Filter vs Face Lens vs World Lens vs SnapML.
- Success KPIs: shares, play time, screenshots, share rate.
- **Gate:** snap_001 confirms scope matches Master Plan.

### Phase 2 — Creative & Storyboard (snap_003)
- Concept + mood board + art direction.
- Interaction flow: trigger (tap/open mouth/look up), states, CTA, hint text.
- Storyboard frames + accessibility notes.
- **Gate:** snap_001 review.

### Phase 3 — Asset Production (snap_004 / snap_005 / snap_006)
- **snap_004 (2D):** textures, overlays, geofilter graphics, icons, UI/CTA — correct specs (power-of-two, compression).
- **snap_005 (3D):** models within poly budget, UVs, rigs, animations, export FBX/GLB.
- **snap_006 (Materials):** Material Editor graphs, PBR/unlit, face-mesh materials, performance-aware shaders.
- **Gate:** snap_gate_001 (specs, budget, naming).

### Phase 4 — Lens Studio Build (snap_007)
- Scene graph assembly; tracking setup (Face/World/Hand/Body/Segmentation).
- Scripting in JS/TS (Lens Studio 5.x): behaviors, triggers, animations, tween, events.
- Bitmoji / Connected Lenses / world mesh where required.
- **⚙️ التنفيذ الفعلي المؤتمت:** اتبع `protocols/snap_lensstudio_build_playbook.md` — خطوات GUI-automation مُتحقَّقة (إنشاء مشروع، استيراد، Head Binding، Inspector، Screen Image، Confetti، Audio) + النموذج الهجين (أتمتة + سحب المستخدم).
- **Gate:** snap_gate_001 (functional + script quality).

### Phase 5 — SnapML (snap_008) — optional
- Define ML task (segmentation / style transfer / classification).
- Dataset, train, export to ONNX/compatible; wire ML Component; test inference on device.
- **Gate:** snap_gate_001 (accuracy + perf on device).

### Phase 6 — VFX & Audio (snap_009)
- Particle systems, post effects, screen transitions.
- Sound design, audio triggers, licensing-clean audio.
- **Gate:** snap_gate_001.

### Phase 7 — Optimization (snap_010)
- Measure lens size vs budget; texture atlasing, mesh decimation, draw-call reduction.
- FPS profiling on target devices.
- ⛔ **HARD STOP:** if over size/perf budget → loop back; never publish over budget.

### Phase 8 — QA & Device Test (snap_011)
- Real device matrix (low/high end, iOS/Android), lighting conditions, multiple faces, edge cases.
- Functional + visual + interaction + crash tests.
- **Gate:** snap_gate_001 (no open FAILs).

### Phase 9 — Compliance & Publish (snap_012)
- Map against Snap **Lens/Filter Submission Guidelines** (content, safety, IP, privacy, no misleading UI).
- Build store copy, screenshots, Snapcode; publish via My Lenses; sponsored via Ads Manager.
- ⛔ **HARD STOP:** any policy violation blocks publish.

### Phase 10 — Analytics & Iterate (snap_013)
- Pull lens metrics (views, plays, share rate, avg play time, screenshots, scans).
- Diagnose drop-offs; produce ranked iteration backlog → feeds next cycle.

---

## 5. Gate Criteria — snap_gate_001

A Phase passes only when:
- All deliverables exist and match the Master Plan scope (coverage-traceable).
- No HIGH issue is open (no open FAILs).
- Size/perf budgets respected (Phases 4–8).
- Encoding clean, naming consistent, assets within spec.
- SAOS Definition of Done met for the owning agent.

Severity: **HIGH** (blocks Phase) · **MEDIUM** (deferred ticket with approval) · **LOW** (logged).

---

## 6. Integration with Enterprise Agents

- Registered in `catalog_manifest.json` under system `Snap_AR_Lenses` (primary_owner: snap_001).
- Entry point: **orch_001 → snap_001**. snap_001 never does domain work; it routes to snap_002…snap_013.
- May consult cross-cutting agents when explicitly requested (e.g. spec_002/ai_002 for advanced ML, qa_* for extra test depth) — but default ownership stays inside the snap_* team.
- All lessons learned after each project are recorded and folded back into this protocol (continuous improvement, version bump).
