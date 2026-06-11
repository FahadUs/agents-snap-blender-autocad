# Blender MCP Pipeline

**Version:** 1.0.0 (2026-06-07)
**Owner:** blender_001 (Blender MCP Coordinator) · **Entry:** orch_001 → blender_001
**Server:** `blender` MCP (ahujasid/blender-mcp) — registered in `~/.claude.json` · Blender 5.1 · addon at `C:\SnapLenses\_blender_mcp\addon.py`
**Goal:** Drive Blender directly via MCP (no GUI) — model, texture, fetch/generate assets, run Python, export — for any 3D need across the enterprise.

> ⚠️ **Runtime prerequisites (every session):** (1) Blender open with the **Blender MCP addon enabled** and **"Connect to MCP server"** active (3D viewport → N → BlenderMCP). (2) Claude Code restarted after registering the server so the `mcp__blender__*` tools load. If tools are missing → restart. If commands fail → confirm the addon connection is live.

---

## 1. The 21 MCP Tools (full capability map)

### A) Scene & Inspection
| Tool | Use |
|------|-----|
| `get_scene_info` | full scene graph (objects, hierarchy) |
| `get_object_info` | one object's mesh/transform/materials |
| `get_viewport_screenshot` | render the Blender viewport → image (visual verification!) |

### B) Object Manipulation & Python
| Tool | Use |
|------|-----|
| `execute_blender_code` | **run arbitrary `bpy` Python** — unlimited control (create/edit/delete, origin, modifiers, rigging, cleanup, export). ⚠️ powerful — save first. |

> Object create/move/scale/rotate, set origin, parent/separate, materials, modifiers, export — all done via `execute_blender_code` (bpy).

### C) Materials & Color
- Apply/modify materials & colors via `execute_blender_code` (`obj.data.materials`, `principled BSDF Base Color`, etc.).

### D) PolyHaven (free assets — needs status on)
| Tool | Use |
|------|-----|
| `get_polyhaven_status` | is PolyHaven enabled |
| `get_polyhaven_categories` | list categories |
| `search_polyhaven_assets` | search models/HDRIs/textures |
| `download_polyhaven_asset` | import an asset |
| `set_texture` | apply a downloaded texture |

### E) Sketchfab (models)
| Tool | Use |
|------|-----|
| `get_sketchfab_status` | enabled? |
| `search_sketchfab_models` | search |
| `download_sketchfab_model` | import (respect license) |

### F) Hyper3D Rodin (AI generation: text/image → 3D)
| Tool | Use |
|------|-----|
| `get_hyper3d_status` | enabled? (API key) |
| `generate_hyper3d_model_via_text` | text → 3D |
| `generate_hyper3d_model_via_images` | image → 3D |
| `poll_rodin_job_status` | wait for job |
| `import_generated_asset` | import result into scene |

---

## 2. Phases (general 3D work)
| Phase | Owner | Action |
|-------|-------|--------|
| 0 | blender_001 | Plan: confirm goal, target (web/AR/render), connection live |
| 1 | blender_002 | Scene/modeling (create/import/edit geometry, origin, scale) |
| 2 | blender_003 | Materials & color (PBR/unlit, textures) |
| 3 | blender_004 | Asset libraries (PolyHaven / Sketchfab) — fetch & place |
| 4 | blender_005 | Hyper3D Rodin — generate from text/image |
| 5 | blender_006 | Python/scripting (bpy automation, cleanup, modifiers, rigging) |
| 6 | blender_007 | Export (GLB/FBX/OBJ) + optimize + verify |

> Verify visually with `get_viewport_screenshot` after each meaningful step (closes the blind-automation gap that plagued GUI work).

---

## 3. Execution Rules
1. **Connection check first** — `get_scene_info`; if it fails, the addon isn't connected → stop & instruct user.
2. **Save before `execute_blender_code`** (it can do anything).
3. **Screenshot to verify** — never assume; `get_viewport_screenshot`.
4. **Respect licenses** — Sketchfab/PolyHaven/Hyper3D outputs: record source + license (hand to publishing).
5. **SAOS C1–C7** for every agent.

## 4. Integration
- Registered in `catalog_manifest.json` as system `Blender_MCP` (primary_owner blender_001).
- Feeds the **Snap Blender Prep** pipeline (`snap_blender_prep_pipeline.md`) and the commercial 3D agent (`design_3d_001`).
- Exported GLBs pass `protocols/tools/verify_3d_asset.ps1` before downstream use.
