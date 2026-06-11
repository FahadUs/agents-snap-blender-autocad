# orch_builder — The Orchestrator

**Role:** Single entry point and connecting link (حلقة الوصل) for all three pipelines.
**Folder:** `agents_system/orch_builder/`

`orch_builder` never does domain work itself. It classifies your request, runs a mandatory boot check, and delegates to the owning **pipeline coordinator** — one at a time, never in parallel.

## What it does

1. **Classify** the task into Snap / Blender / AutoCAD.
2. **Boot check** — verify the project is ready before any work:
   - The right `CLAUDE.md` exists at the project root (or, for MCP-only Blender/AutoCAD work, the MCP connection is live).
   - For full Snap projects: an approved `docs/plans/00-master-plan.md` (Phase 0).
3. **Delegate** to `snap_001`, `blender_001`, or `autocad_001` — sequentially.
4. **Enforce SAOS** on every delegated output; reject anything that violates it.
5. **Report** at the end of each phase (bullet format) and wait for your confirmation.

## Routing table

| Your task mentions… | Routed to | Pipeline |
|---------------------|-----------|----------|
| Snap, filter, lens, SnapML, beauty filter, AR lens game | `snap_001` | Snap Lens Delivery |
| Blender, 3D, model, materials, textures, PolyHaven, Sketchfab, Hyper3D, render, GLB/FBX export | `blender_001` | Blender MCP |
| Prepare a 3D model for Lens Studio (scale/origin/decimate for Snap) | `snap_blender_001` | Snap Blender Prep |
| AutoCAD, DWG, DXF, 2D drafting, layers, blocks, dimensions, P&ID, AutoLISP, DXF export | `autocad_001` | AutoCAD MCP |

When a task is ambiguous (e.g. "a 3D model" could be for a Snap lens, the web, or print), `orch_builder` **asks you for the final target** before routing — it does not guess.

## Boot check (pseudocode)

```
1. Classify task → Snap / Blender / AutoCAD
2. Determine project_root (ask if new project)
3. CLAUDE.md present?  No → HARD STOP, tell user which template to copy:
      Snap    → protocols/CLAUDE_snap_lens_template.md
      AutoCAD → protocols/CLAUDE_autocad_template.md
      Blender → protocols/CLAUDE_master_template.md
   (MCP-only Blender/AutoCAD with no project files: a live MCP connection is enough.)
4. Snap full project? → require approved docs/plans/00-master-plan.md (Phase 0)
5. All checks pass → delegate to the pipeline coordinator
```

## Operating rules

- **Sequential only** — one agent at a time, never parallel.
- **SAOS-gated** — every output must pass C1–C7 (see [docs/README.md](README.md)).
- **No open FAILs** — a phase never closes with a HIGH issue still open.
- **End-of-phase report** — ✅ done + path · 🔎 gate result · 💡 notes · ⏭️ next phase + owner.

## Definition of Done

- Task classified to the correct pipeline; boot check passed.
- Owning coordinator delegated sequentially; every output SAOS-compliant.
- HARD STOPs honored; no open FAILs at handoff.
- Consolidated final report + clean handoff.
