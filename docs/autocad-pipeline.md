# AutoCAD MCP Pipeline

**Entry agent:** `autocad_001`
**Protocols:** `protocols/autocad_mcp_pipeline.md`, `protocols/autocad_improvement_pipeline.md`
**Project template:** `protocols/CLAUDE_autocad_template.md`
**Agents:** 11

Drives **AutoCAD** through an **AutoCAD MCP** server (puran-water v3.1) for 2D drafting, layers/blocks, dimensions, P&ID, AutoLISP automation, and DXF/DWG export. Can also run **headless via `ezdxf`** when AutoCAD is not running.

## Agents

| Agent | Name | Role |
|-------|------|------|
| `autocad_001` | AutoCAD MCP Coordinator | Entry point. Connection boot check, picks the backend (File-IPC vs `ezdxf` headless), routes to specialists, enforces save-before-LISP and screenshot verification. |
| `autocad_002` | Drawing & Entity | 2D drafting: line, circle, polyline, rectangle, arc, ellipse, text, hatch + file create/open/save. |
| `autocad_003` | Layers & Blocks | Layers (create/freeze/thaw/lock) and blocks (insert/define + attributes). Sets the layer standard. |
| `autocad_004` | Annotation & Dimensions | Dimensions (linear/aligned/angular/radius), leaders, and text per project dimension style. |
| `autocad_005` | P&ID Specialist | Process & Instrumentation Diagrams: valves, pumps, tanks, instruments, process lines, tags/line numbers (CTO symbol library). |
| `autocad_006` | AutoLISP & 3D Automation | Arbitrary AutoLISP via `execute_lisp` for batch routines, custom ops, and 3D (extrude/revolve via vlax/ActiveX). The AutoCAD equivalent of Blender's `execute_blender_code`. |
| `autocad_007` | Export & Headless | Exports DXF/DWG, plots to PDF, and owns the `ezdxf` headless backend (generate DXF with no AutoCAD running). Verifies outputs. |
| `autocad_008` | Architectural & Space Planning | Floor plans: continuous shared-wall systems, room tiling to a target area, doors/windows as wall openings, room schedules, image→vector tracing. |
| `autocad_009` | Sheet Layout & Plotting | Paper-space sheets: layouts, scale-locked viewports, attributed title blocks, sheet sets, plotting/publishing to PDF/DWF (single + batch). |
| `autocad_qa_001` | Self-Improvement & Retrospective | Runs the AutoCAD Improvement Pipeline (closed-loop learning): loads lessons before work, captures corrections, attributes each error to the responsible agent, teaches a prevention rule, verifies the fix. |
| `autocad_research_001` | Capability-Gap Researcher | Runs after requirements analysis, before execution. Maps required capabilities against existing agents + lessons, researches standards/techniques when needed, and produces a Capability-Gap Report. Recommends; does not build. |

## Two backends

| Backend | When | Needs AutoCAD running? |
|---------|------|------------------------|
| **File-IPC** (live AutoCAD) | Full interactivity, screenshots, P&ID, AutoLISP, 3D | Yes |
| **`ezdxf` headless** | Generating DXF files in batch / CI, no GUI | No |

`autocad_001` chooses the backend during the boot check based on your task and what's available.

## Operating rules

- **Save before** any `execute_lisp`.
- **Verify** drawings (screenshot / `ezdxf` round-trip) before handoff.
- Closed-loop learning via `autocad_qa_001` — errors don't repeat silently.

## Requirements to run

- For the **File-IPC** backend: **AutoCAD** installed + the AutoCAD MCP server connected.
- For the **headless** backend: just Python with **`ezdxf`** (`pip install ezdxf`) — no AutoCAD license needed.

> **Status note:** in the original system this pipeline was designed and validated but its live run was deferred pending an AutoCAD install. The headless `ezdxf` path works without AutoCAD.
