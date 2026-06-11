# Snap Blender Prep Pipeline

**Version:** 1.0.0 (2026-06-07)
**Owner:** snap_blender_001 · **Entry:** orch_001 → snap_blender_001 (or snap_005 calls it)
**Purpose:** Take any 3D model and **fix + prepare it for Snapchat Lens Studio** — the missing link that caused today's graduation-cap problems (bad origin, giant scale, un-editable white material, fused parts).

> Bridges **Blender** (`blender_mcp_pipeline.md`) and the **Snap Lens** pipeline (`snap_lens_delivery_pipeline.md`). Output: a clean lens-ready GLB that imports correctly on the head at the right size and color.

---

## What it fixes (the gaps)
| Problem (from graduation cap) | Fix |
|-------------------------------|-----|
| Model floats / giant white plane | recenter **origin to geometry**, **apply scale**, normalize to a target real-world size |
| White un-editable imported material | assign clean **per-part materials** with explicit Base Color (theme navy + gold) |
| Tassel fused to cap | **separate** parts by material/loose so they can move/rig |
| Heavy / messy mesh | recalc normals, remove doubles, optional **decimate** |
| Unknown validity | export GLB → `verify_3d_asset.ps1` |

---

## Two execution modes
### A) Headless (most reliable — no GUI, no MCP needed)
Run the prep script directly:
```
& "C:\Program Files\Blender Foundation\Blender 5.1\blender.exe" --background --python ^
  "C:\Users\fahad\OneDrive\Desktop\AgentsSnapBlenderAutoCAD\protocols\snap_blender_scripts\prep_for_lens.py" -- ^
  --in  "C:\...\model.glb" ^
  --out "C:\...\model_lens.glb" ^
  --target-height 0.25 ^
  --recolor "board=#1A2A6C,tassel=#FFD54A" ^
  --separate-loose
```
→ deterministic, scriptable, ideal for batch.

### B) Interactive (Blender MCP)
Via `blender_001` + specialists using `execute_blender_code` + `get_viewport_screenshot` for visual tuning.

---

## Phases
| # | Step | How |
|---|------|-----|
| 1 | Import + inspect | load GLB, list objects/materials |
| 2 | Origin + scale | origin→geometry, apply scale, normalize to target height (head ≈ 0.2–0.3 LS units) |
| 3 | Orientation | +Y up, face -Z; rotate if needed |
| 4 | Materials | per-part clean materials + theme colors (no shared white) |
| 5 | Separate parts | by material / loose (tassel, board) for rigging/interaction |
| 6 | Cleanup | recalc normals, remove doubles, purge orphans, optional decimate |
| 7 | Export GLB | `export_scene.gltf` → `verify_3d_asset.ps1` |
| 8 | Handoff | to snap_005 → Lens Studio (snap_007), reactive tassel (TasselSway) |

## Rules
- SAOS C1–C7. Verify (screenshot in mode B; verify_3d_asset.ps1 always).
- Record source + license (CC-BY → attribution to snap_012).
- Keep lens size tiny (within Snap lens cap).
