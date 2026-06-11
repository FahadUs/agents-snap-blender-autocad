# CLAUDE.md — Snap Lens Project

> Copy this file to the root of every new Snap lens/filter project and fill the `<...>` fields.
> Source template: `C:/Users/fahad/OneDrive/Desktop/AgentsSnapBlenderAutoCAD/protocols/CLAUDE_snap_lens_template.md`
> Pipeline: `C:/Users/fahad/OneDrive/Desktop/AgentsSnapBlenderAutoCAD/protocols/snap_lens_delivery_pipeline.md`

---

## 1. Project Identity
- **Lens name:** `<name>`
- **Owner / brand:** `<brand or creator>`
- **Type:** `<Filter | Geofilter | Face Lens | World Lens | SnapML Lens>`
- **Region / Geo:** `<country/city — relevant for Geofilters & trends>`
- **Target audience:** `<who>`
- **Occasion / campaign:** `<event, season, sponsor>`
- **Goal KPI:** `<share rate | play time | scans | screenshots>`

## 2. Tech Stack & Tooling
- **Authoring:** Lens Studio `<version, e.g. 5.x>`
- **Scripting:** JavaScript / TypeScript (Lens Studio scripting API)
- **3D pipeline:** `<Blender / Maya>` → export `<FBX / GLB>`
- **2D pipeline:** `<Photoshop / Figma / Illustrator>`
- **SnapML (if used):** `<PyTorch / TensorFlow>` → export `<ONNX / compatible>`
- **Audio:** `<DAW / source>` — licensing must be clean.

## 3. Platform Constraints (verify against current Snap docs)
- **Lens size budget:** `<MB — HARD limit>` (historically ~8 MB community; sponsored differ)
- **Target FPS:** `<e.g. 30 stable on low-end>`
- **Texture limit:** power-of-two, compressed, `<max dims>`
- **Poly budget:** `<max tris>`
- **Tracking required:** `<Face / World / Hand / Body / Segmentation>`

## 4. Project Structure
```
docs/        plans, strategy, storyboard, qa, analytics
assets/2d    textures, overlays, geofilter PNGs, icons, CTA
assets/3d    models, rigs, animations
assets/materials  shader graphs, material specs
ml/          SnapML model, training, labels
lens/        Lens Studio project (scene, scripts/, resources)
build/       exported .lns / published artifacts
submission/  snapcode, store copy, screenshots, policy checklist
```

## 5. Pipeline Phases & Gates
| Phase | Owner | Gate |
|-------|-------|------|
| 0 Master Plan | snap_001 | User approval (HARD) |
| 1 Strategy | snap_002 | snap_001 |
| 2 Storyboard | snap_003 | snap_001 |
| 3 Assets | snap_004/005/006 | snap_gate_001 |
| 4 Lens Build | snap_007 | snap_gate_001 |
| 5 SnapML | snap_008 | snap_gate_001 |
| 6 VFX/Audio | snap_009 | snap_gate_001 |
| 7 Optimization | snap_010 | HARD STOP if over budget |
| 8 QA/Device | snap_011 | snap_gate_001 |
| 9 Compliance/Publish | snap_012 | HARD STOP if policy fail |
| 10 Analytics | snap_013 | snap_001 |

## 6. Submission Compliance Checklist (Snap Guidelines)
- [ ] Content safe, non-misleading, no prohibited categories
- [ ] No infringing IP / trademarks / copyrighted audio
- [ ] No misleading UI (fake buttons, fake system prompts)
- [ ] Privacy: no unauthorized data capture
- [ ] Within size & performance budgets
- [ ] Store copy + screenshots + Snapcode prepared

## 7. Working Conventions
- **Sequential only**, no parallel agents.
- **Plan before execution** for every agent.
- **No open FAILs** to close a Phase.
- **Monitor + user confirm** at end of each Phase.
- All agents follow **SAOS (C1–C7)**.
- Communicate in Arabic; clean encoding (no mojibake).

## 8. Current Status
- **Phase:** `<current>`
- **Blockers:** `<...>`
- **Next gate:** `<...>`
