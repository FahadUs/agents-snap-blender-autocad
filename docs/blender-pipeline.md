# Blender MCP Pipeline

**Entry agent:** `blender_001`
**Protocol:** `protocols/blender_mcp_pipeline.md`
**Agents:** 7

Drives **Blender** directly through the **Blender MCP** server to model, texture, fetch/generate assets, and export — with visual verification after each step (the key advantage over blind GUI automation).

## Agents

| Agent | Name | Role |
|-------|------|------|
| `blender_001` | Blender MCP Coordinator | Entry point. Connection boot check, routes to specialists, enforces save-before-code and screenshot verification. |
| `blender_002` | Scene & Modeling | Creates/imports/edits geometry; fixes origin/pivot, scale, orientation; parent/separate; scene cleanup. |
| `blender_003` | Materials & Color | Creates/assigns/edits materials and colors (PBR / unlit / textures, per-part colors). |
| `blender_004` | Asset Libraries (PolyHaven / Sketchfab) | Finds and imports ready assets (models / HDRIs / textures); records licenses. |
| `blender_005` | Hyper3D Rodin (AI Generation) | Generates 3D models from text or images via Hyper3D Rodin, then imports for refinement. |
| `blender_006` | Python / bpy Automation | Automates Blender via `bpy` (`execute_blender_code`): cleanup, modifiers, rigging, UV, decimation, batch ops, custom export. |
| `blender_007` | Export & Optimize | Exports clean optimized models (GLB/FBX/OBJ) within size/poly budgets; verifies with `verify_3d_asset.ps1`. |

## How routing works

| You need… | Specialist |
|-----------|-----------|
| Scene / modeling / geometry / origin / scale | `blender_002` |
| Materials, color, textures | `blender_003` |
| Fetch assets (PolyHaven / Sketchfab) | `blender_004` |
| AI generate (Hyper3D Rodin text/image → 3D) | `blender_005` |
| `bpy` scripting / automation / cleanup / rigging | `blender_006` |
| Export (GLB/FBX/OBJ) + optimize | `blender_007` |
| Prepare a model for Snapchat Lens Studio | `snap_blender_001` (Snap Blender Prep) |

## Operating rules

- **Save before** any `execute_blender_code`.
- **Verify visually** after each meaningful step (`get_viewport_screenshot`).
- Record asset **licenses** (Sketchfab / PolyHaven / Hyper3D).
- Exported models must pass `protocols/tools/verify_3d_asset.ps1`.

## Requirements to run

- **Blender** installed (free, open-source).
- The **Blender MCP** server connected to your agent runner (e.g. [ahujasid/blender-mcp](https://github.com/ahujasid/blender-mcp)), with the Blender addon open and "Connected".
- `blender_005` (Hyper3D Rodin) uses a third-party AI generation service — it runs **only when you invoke it, with your own account**. It is not called automatically and no key ships in this repo.

> **Boot check:** `blender_001` first confirms the `mcp__blender__*` tools are loaded and that `get_scene_info` succeeds. If not, it tells you to restart the runner and/or open Blender → N → BlenderMCP → Connect.
