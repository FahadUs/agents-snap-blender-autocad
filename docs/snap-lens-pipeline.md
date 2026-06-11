# Snap Lens Delivery Pipeline

**Entry agent:** `snap_001`
**Protocol:** `protocols/snap_lens_delivery_pipeline.md`
**Project template:** `protocols/CLAUDE_snap_lens_template.md`
**Agents:** 20

Builds Snapchat **filters**, **AR face/world lenses**, **SnapML** effects, and single-player **AR lens games** in Lens Studio — from idea to a submission-ready package.

## The 10-phase process

| Phase | Owner | Deliverable |
|-------|-------|-------------|
| 0 · Master Plan | `snap_001` | `docs/plans/00-master-plan.md` (approved) |
| 1 · Strategy & Trends | `snap_002` | `docs/01-strategy.md` |
| 2 · Creative & Storyboard | `snap_003` | `docs/02-storyboard.md` |
| 3 · Assets | `snap_004` (2D) · `snap_005` (3D) · `snap_006` (materials) | `assets/` |
| 4 · Lens Build | `snap_007` | `lens/` |
| 5 · SnapML *(optional)* | `snap_008` | `ml/` |
| 6 · VFX & Audio | `snap_009` | particles + audio |
| 7 · Optimization | `snap_010` | size/FPS report — **HARD STOP if over budget** |
| 8 · QA & Device | `snap_011` | `docs/08-qa-report.md` |
| 9 · Compliance & Publish | `snap_012` | `submission/` — **HARD STOP on policy violation** |
| 10 · Analytics | `snap_013` | `docs/10-analytics.md` |
| Gate | `snap_gate_001` | runs after phases 3, 4, 5, 6, 8 |

**Routing shortcuts:** a simple Filter/Geofilter skips the 3D, Materials, SnapML, and heavy-build phases. SnapML phase 5 is included only when a custom neural network is required.

## Agents

| Agent | Name | Role |
|-------|------|------|
| `snap_001` | Snap Lens Pipeline Coordinator | Entry point. Boot check, routes each phase sequentially, enforces gates & HARD STOPs, reports at every phase end. |
| `snap_002` | AR Concept & Trend Strategist | Phase 1. Idea → validated strategy: trend scan, audience/region, lens-type decision, share trigger, KPIs, risks. |
| `snap_003` | Creative Director & Storyboard | Phase 2. Strategy → art direction + interaction storyboard + a typed asset list. |
| `snap_004` | 2D Asset Artist | Phase 3 (2D). Textures, overlays, geofilter graphics, icons, UI/CTA, hint visuals. |
| `snap_005` | 3D Artist & Modeler | Phase 3 (3D). Models, UVs, rigs, animations optimized for mobile AR. |
| `snap_006` | Materials & Shaders Specialist | Phase 3 (materials). PBR/unlit materials, face-mesh materials, post effects. |
| `snap_007` | Lens Studio Engineer | Phase 4. Assembles the Lens Studio project: scene graph, tracking, JS/TS behavior. |
| `snap_008` | SnapML / ML Engineer | Phase 5 (optional). Custom neural network via the SnapML component (segmentation, style transfer, detection). |
| `snap_009` | VFX & Audio Specialist | Phase 6. Particle systems, post/screen effects, transitions, sound design. |
| `snap_010` | Performance & Optimization | Phase 7. Brings the lens within Snap size/performance budgets. HARD STOP if over. |
| `snap_011` | QA & Device Testing | Phase 8. Validates on real devices: functional, visual, interaction, stability, regression. |
| `snap_012` | Compliance & Publishing | Phase 9. Checks Snap Submission Guidelines, builds the submission package, publishes. HARD STOP on policy violation. |
| `snap_013` | Analytics & Iteration | Phase 10. Measures vs KPIs, diagnoses, produces a ranked iteration backlog. |
| `snap_014` | Lens Game Designer | Designs single-player AR lens games: mechanic, game loop, scoring, difficulty, tuning table. |
| `snap_015` | Gameplay Engineer | Implements game logic in Lens Studio (JS/TS): GameManager state machine, spawner+pooling, scoring, collision. |
| `snap_016` | AR Beauty & Makeup Specialist | Beauty filters: Face Retouch / Eye Color / Color Correction + Face Mesh makeup (lashes/blush on face UV). *Rule: makeup = Face Mesh texture, not an image on an eye attachment.* |
| `snap_017` | LS File-Format Engineer | Direct, BOM-safe text editing of `Scene.scene` / `.mat` / GUIDs when GUI automation fails. |
| `snap_blender_001` | Snap Model Prep (Blender) | Fixes/prepares any 3D model for Lens Studio (origin/scale/orientation, materials, cleanup, verified lens-ready GLB). Bridges Blender ↔ Snap. |
| `snap_gate_001` | Snap Lens Quality Gate | Quality gate after phases 3,4,5,6,8; blocks progression on any HIGH issue. |
| `snap_qa_001` | Pipeline QA & Retrospective | Tests every phase visually, attributes defects to the responsible agent, teaches the lesson back (closed learning loop). Verifies effects actually render, not just exist. |

## Gates & HARD STOPs

- **Phase 0:** user approval of the Master Plan.
- **Phase 7:** never proceed if the lens is over size/perf budget → loop back to `snap_010`.
- **Phase 9:** never publish on any Snap policy violation → loop back to `snap_012`.
- **No open FAILs:** no phase closes with a HIGH issue open.

## Requirements to run

- **Lens Studio** installed (Snap's free desktop app) for phases 4+.
- Optionally **Blender** for 3D model prep (`snap_blender_001`).
- A Snapchat account only at phase 9 (publishing) — and only if *you* choose to publish.
