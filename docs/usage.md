# Usage — Install & Run

These agents are **prompts**, not an application. You "run" one by giving its `PROMPT.md` to an LLM agent (Claude Code, Cursor, Cline, or any tool that accepts a system prompt) and then describing your task.

## Quick start

1. **Get the files.**
   ```bash
   git clone <your-repo-url> agents-snap-blender-autocad
   cd agents-snap-blender-autocad
   ```

2. **Pick your entry point.** Always start with the orchestrator:
   - Open `agents_system/orch_builder/PROMPT.md` and load it as your agent's system prompt.
   - Describe your task in plain language ("build a Snapchat beauty filter", "model a low-poly chair in Blender", "draft a P&ID for a pump skid").
   - `orch_builder` classifies it and tells you which pipeline coordinator to invoke next.

3. **Follow the pipeline.** The coordinator (`snap_001` / `blender_001` / `autocad_001`) walks you through its phases, loading the right specialist prompt for each step.

## Running a single pipeline directly

If you already know which pipeline you want, skip the orchestrator and load the coordinator's prompt:

| Goal | Load this prompt |
|------|------------------|
| Snapchat filter / lens / game | `agents_system/snap_001/PROMPT.md` |
| Blender 3D work | `agents_system/blender_001/PROMPT.md` |
| AutoCAD drafting | `agents_system/autocad_001/PROMPT.md` |

## Per-project setup (recommended)

Each pipeline expects a `CLAUDE.md` at your **project** root (not this repo). Copy the matching template and fill in your details:

| Pipeline | Template |
|----------|----------|
| Snap | `protocols/CLAUDE_snap_lens_template.md` |
| AutoCAD | `protocols/CLAUDE_autocad_template.md` |
| Blender / general | `protocols/CLAUDE_master_template.md` |

## External tools you provide

The agents are tool-agnostic instructions. To actually execute, you install and connect the tools yourself:

| Pipeline | Tool you provide | Cost |
|----------|------------------|------|
| Snap | **Lens Studio** (Snap's free desktop app) | Free |
| Blender | **Blender** + a **Blender MCP** server | Free / open-source |
| Blender (optional) | **Hyper3D Rodin** AI generation, **Sketchfab** downloads | Your own account/keys, only if you use them |
| AutoCAD | **AutoCAD** + AutoCAD MCP server, *or* **`ezdxf`** (headless, free) | AutoCAD is licensed; `ezdxf` is free |

> None of these keys or accounts are included in this repo. See [SECURITY.md](SECURITY.md).

## Helper scripts (optional, local-only)

| Script | What it does |
|--------|--------------|
| `protocols/snap_blender_scripts/prep_for_lens.py` | Headless Blender prep of a model for Lens Studio |
| `protocols/snap_game_templates/GameManager.js` | Starter Lens Studio game state machine |
| `protocols/tools/verify_3d_asset.ps1` | Validates an exported 3D asset |
| `protocols/find_free_ports.ps1` | Finds free local ports |

All four are local utilities — none make network calls.
