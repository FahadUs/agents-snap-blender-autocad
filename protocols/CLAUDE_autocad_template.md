# CLAUDE.md — AutoCAD MCP Project

> Copy this into the root of any AutoCAD/CAD project, then fill the placeholders.
> Entry point is always **orch_001 → autocad_001**. Never drive AutoCAD blindly; route through the pipeline.

## Project
- **Name:** {project name}
- **Goal:** {what to draw/produce — e.g. floor plan, P&ID, 3D part, batch DXF}
- **Deliverable type:** {DWG / DXF / PDF plot / 3D solid}
- **Backend:** {File-IPC (AutoCAD running) | ezdxf (headless, no AutoCAD)}

## CAD environment
- **AutoCAD version:** {2025 Full / LT 2024+}
- **Units:** {mm / m / inches} — confirm before mass production
- **Drawing standard / template (.dwt):** {ISO / ANSI / company standard}
- **Dimension style:** {name}
- **Layer convention:** {e.g. naming + colors + linetypes}

## Server
- **MCP server:** `autocad` (puran-water/autocad-mcp v3.1) — registered in `~/.claude.json`
- **Python env:** **`py312`** = isolated Python 3.12.13 at `C:\AutoCAD_MCP\py312\` — invoke `C:\AutoCAD_MCP\py312\Scripts\python.exe` (NEVER system 3.14)
- **uv:** `C:\Users\fahad\.local\bin\uv.exe`
- **Server code:** `C:\AutoCAD_MCP\autocad-mcp\`
- **LISP dispatcher loaded:** `mcp_dispatch.lsp` via APPLOAD (File-IPC only)
- **P&ID library:** CAD Tools Online (CTO) at `C:\PIDv4-CTO\` (if P&ID work)

## Pipeline
Follow `C:/Users/fahad/OneDrive/Desktop/AgentsSnapBlenderAutoCAD/protocols/autocad_mcp_pipeline.md` (8 tools, phases 0–6, backend rules).

## Rules (mandatory)
1. **Boot check first** — `system(operation="status")`; if File-IPC fails → tell user to open AutoCAD + APPLOAD the dispatcher, or switch to ezdxf if task allows.
2. **Save before** any `system(operation="execute_lisp")`.
3. **Verify visually** after each meaningful step — `view(operation="screenshot")`.
4. **Layer discipline** — geometry on named layers, not layer 0.
5. **ASK-don't-guess** units, scale, and standards before production (SAOS C2).
6. **SAOS C1–C7** for every agent.

## Output paths
- Drawings: `{project_root}/cad/`
- Exports (DXF/DWG/PDF): `{project_root}/cad/exports/`
- Screenshots/verification: `{project_root}/cad/verify/`
