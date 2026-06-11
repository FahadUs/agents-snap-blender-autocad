# AutoCAD MCP Pipeline

**Version:** 1.0.0 (2026-06-08)
**Owner:** autocad_001 (AutoCAD MCP Coordinator) · **Entry:** orch_001 → autocad_001
**Server (planned):** `puran-water/autocad-mcp` v3.1 — registered in `~/.claude.json`
**Goal:** Drive AutoCAD directly via MCP (no manual GUI) — 2D drafting, layers/blocks, annotation/dimensions, P&ID, AutoLISP automation, 3D, and headless DXF generation — for any CAD need across the enterprise.

> 🛠️ **Status: PROVISIONING (2026-06-09).** AutoCAD **2026** (Full) is installed ✅, `uv` installed ✅, isolated Python env **`py312`** (3.12.13) created ✅. Remaining: clone server + install deps into py312 → register MCP → APPLOAD dispatcher → restart → smoke test. See §5 Runtime Setup. The **`py312`** interpreter (`C:\AutoCAD_MCP\py312\Scripts\python.exe`) is THE pipeline Python — never use system 3.14.

> ⚠️ **Runtime prerequisites (every session, once live):**
> 1. **AutoCAD running** with `mcp_dispatch.lsp` loaded via `APPLOAD` (File-IPC backend), **OR** ezdxf headless backend selected (no AutoCAD needed).
> 2. Claude Code restarted after registering the server so the `mcp__autocad__*` tools load. If tools are missing → restart. If commands fail → confirm AutoCAD is open and the LISP dispatcher is loaded.

---

## 1. The 8 Consolidated MCP Tools (full capability map)

The puran-water server consolidates all operations into 8 tools, each taking an `operation` argument.

| Tool | Operations | Owner agent |
|------|-----------|-------------|
| **drawing** | create / open / save / export DXF / plot PDF / purge / undo / redo | autocad_002 (file) / autocad_007 (export) |
| **entity** | CRUD: line, circle, polyline, rectangle, arc, ellipse, text, hatch | autocad_002 |
| **layer** | create / list / freeze / thaw / lock / unlock | autocad_003 |
| **block** | insert / define blocks; manage attributes | autocad_003 |
| **annotation** | text, linear/aligned/angular/radius dimensions, leaders | autocad_004 |
| **pid** | P&ID symbols (valves, pumps, tanks, instruments), process lines, tags, line numbers — from CAD Tools Online (CTO) library | autocad_005 |
| **view** | zoom, viewport control, **screenshot capture** (visual verification!) | autocad_001 (verify) |
| **system** | status, health, backend selection, **arbitrary AutoLISP execution (`execute_lisp`)** | autocad_006 |

> 🔥 **`system(operation="execute_lisp", code="...")`** runs arbitrary AutoLISP — unlimited control (3D via vlax/ActiveX, batch ops, custom routines). This is the AutoCAD equivalent of `execute_blender_code`. Save first.

> 🔥 **ezdxf headless backend** generates DXF files with **no AutoCAD running**, on any OS. Limits: no offset/fillet/chamfer, no plot-to-PDF, no undo/redo, no LISP execution.

---

## 2. Phases (general CAD work)
| Phase | Owner | Action |
|-------|-------|--------|
| 0 | autocad_001 | Plan: confirm goal + target (2D/P&ID/3D/headless), pick backend, connection live |
| 1 | autocad_002 | Drawing & entities (2D geometry, file create/open/save) |
| 2 | autocad_003 | Layers & blocks (organize drawing, insert/define blocks + attributes) |
| 3 | autocad_004 | Annotation & dimensions (dims, leaders, text) |
| 4 | autocad_005 | P&ID (process symbols, lines, tags — CTO library) |
| 5 | autocad_006 | AutoLISP automation & 3D (`execute_lisp`, vlax 3D, batch routines) |
| 6 | autocad_007 | Export (DXF/DWG/PDF) + headless ezdxf generation + verify |

> Verify visually with `view(operation="screenshot")` after each meaningful step (closes the blind-automation gap, same lesson as Blender's `get_viewport_screenshot`).

---

## 3. Execution Rules
1. **Connection check first** — `system(operation="status")`; if it fails, AutoCAD isn't connected / dispatcher not loaded → stop & instruct user (or switch to ezdxf headless if the task allows).
2. **Pick the right backend** — File-IPC (needs AutoCAD, full features incl. LISP/P&ID/3D/PDF) vs ezdxf (headless, 2D DXF only).
3. **Save before `execute_lisp`** (it can do anything).
4. **Screenshot to verify** — never assume; `view(operation="screenshot")`.
5. **Layer discipline** — put geometry on named layers (not layer 0) per drafting standards.
6. **Units & standards** — confirm drawing units + dimension style with the user before mass production (ASK-don't-guess).
7. **SAOS C1–C7** for every agent.

---

## 4. Backend Comparison
| Capability | File-IPC (AutoCAD) | ezdxf (headless) |
|-----------|--------------------|------------------|
| 2D entities, layers, blocks, text, dims | ✅ | ✅ |
| P&ID (CTO library) | ✅ | ✅ (built-in CTO) |
| 3D (extrude/revolve via vlax) | ✅ | ❌ |
| Arbitrary AutoLISP (`execute_lisp`) | ✅ | ❌ |
| offset / fillet / chamfer | ✅ | ❌ |
| plot to PDF | ✅ | ❌ |
| undo / redo | ✅ | ❌ |
| Needs AutoCAD installed | Yes | **No** |
| OS | Windows only | any |

---

## 5. Runtime Setup

### 5.0 Resolved environment (this machine — verified 2026-06-09)
| Item | Value |
|------|-------|
| **AutoCAD** | ✅ **AutoCAD 2026** (Full, English) v25.1.164.0 — `C:\Program Files\Autodesk\AutoCAD 2026\acad.exe` |
| **uv** | ✅ v0.11.19 — `C:\Users\fahad\.local\bin\uv.exe` (`.local\bin` not yet on PATH — call by full path or run `uv python update-shell`) |
| **Python env (THE pipeline interpreter)** | ✅ name **`py312`** · Python **3.12.13** (uv-managed, isolated) |
| **py312 path** | `C:\AutoCAD_MCP\py312\` |
| **py312 python.exe (invoke this)** | `C:\AutoCAD_MCP\py312\Scripts\python.exe` |
| **py312 activate** | `C:\AutoCAD_MCP\py312\Scripts\activate` |
| **Server location** | `C:\AutoCAD_MCP\autocad-mcp\` (after clone) |

> ⚠️ **Always run this server with `py312`** — do NOT use system Python 3.14 (wheel gaps for MCP SDK / pywin32 / ezdxf). Invoke via `C:\AutoCAD_MCP\py312\Scripts\python.exe`.

### 5.1 Remaining steps (to go LIVE)
1. ✅ ~~Prereqs: AutoCAD, uv, isolated Python 3.12 (`py312`)~~ — DONE.
2. **Clone & install:** `git clone https://github.com/puran-water/autocad-mcp C:\AutoCAD_MCP\autocad-mcp` → install deps into **py312** (`C:\AutoCAD_MCP\py312\Scripts\python.exe -m pip install -r requirements.txt`, or `uv pip install --python C:\AutoCAD_MCP\py312\Scripts\python.exe -e .`).
3. **Load LISP dispatcher:** in AutoCAD 2026 run `APPLOAD` → load `mcp_dispatch.lsp` (File-IPC backend). Optionally set `AUTOCAD_MCP_IPC_DIR`.
4. **Register MCP server** in `~/.claude.json` under `mcpServers` (key `autocad`), launching the server with the **py312** interpreter: `command = C:\AutoCAD_MCP\py312\Scripts\python.exe`, `args = [<server entry>.py]`. For WSL clients wrap through `cmd.exe`.
5. **Restart Claude Code** so `mcp__autocad__*` tools load.
6. **Verify:** `system(operation="status")` → expect connected. Then a smoke test: `entity` draw a circle → `view` screenshot.

> Encoding note: `~/.claude.json` must be read/written as UTF-8 (build machine threw a cp1252 decode error on it).

---

## 6. Integration
- Registered in `catalog_manifest.json` as system `AutoCAD_MCP` (primary_owner autocad_001).
- Sibling of the **Blender MCP** pipeline (`blender_mcp_pipeline.md`) — same "drive-the-app-via-MCP + verify-with-screenshot" pattern.
- **BIM track (separate, optional, future):** Autodesk APS / AEC Data Model MCP for cloud BIM data queries (Revit/ACC) — needs an APS account. Documented but not built; would become `autocad_bim_001`.

## 7. Definition of Done (pipeline level)
- Connection verified (or ezdxf backend selected), task routed + completed, result screenshot-verified, exports valid (DXF/DWG/PDF), layers/units/standards respected, handoff clean, SAOS satisfied.
