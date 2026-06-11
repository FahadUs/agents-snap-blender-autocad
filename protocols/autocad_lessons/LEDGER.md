# AutoCAD Pipeline — Lessons LEDGER

Chronological log of every issue. Each is attributed to the **responsible agent**, with root cause, fix, and the prevention rule taught. Owner: autocad_qa_001. See `autocad_improvement_pipeline.md`.

---

### L001 — MTEXT line break needs `\P`, not `\n`; preview also ignores it
- date: 2026-06-09
- project: apartment plan (sketch → CAD)
- phase / tool: Phase 3 / annotation (create_mtext)
- responsible_agent: autocad_004
- symptom: "LIVING / KITCHEN" + "5.0 x 6.0" rendered merged ("KITCHEN5.0")
- root_cause: used `\n` for MTEXT line break (MTEXT needs `\P`); matplotlib preview ignores both and wraps by width only
- fix: one text entity PER LINE; or use `\P`; widen box + add vertical gap
- prevention_rule: For multi-line labels use a separate text entity per line (preview-safe), or `\P` for MTEXT; never `\n`.
- status: RESOLVED

### L002 — MTEXT insert point is TOP-LEFT, not center
- date: 2026-06-09
- project: apartment plan
- phase / tool: Phase 3 / annotation
- responsible_agent: autocad_004
- symptom: room labels drifted toward edges/partitions
- root_cause: treated the insert point as the center; it is the top-left attachment
- fix: offset x by ~len*height*0.3 to visually center
- prevention_rule: Compute label insert as top-left; offset to center (≈ -len*height*0.3, +height).
- status: RESOLVED

### L003 — matplotlib preview ≠ DXF/AutoCAD output
- date: 2026-06-09
- project: villa + apartment plans
- phase / tool: verification (ezdxf get_screenshot)
- responsible_agent: autocad_001
- symptom: □ boxes for letter "O", Arabic shown as nothing, `\P` ignored — but DXF was correct
- root_cause: ezdxf preview renders via matplotlib (limited fonts, no shaping); it is approximate
- fix: treat ezdxf PNG as approximate; final verification in real AutoCAD (COM screenshot)
- prevention_rule: Never judge final quality from the matplotlib preview; verify text/Arabic in real AutoCAD.
- status: RESOLVED

### L004 — Label text wider than its box wraps and collides
- date: 2026-06-09
- project: apartment plan
- phase / tool: Phase 3 / annotation
- responsible_agent: autocad_004
- symptom: long label wrapped and overlapped the dims line below
- root_cause: text box width too small + vertical gap too small
- fix: widen the MTEXT box; increase line gap (≥ 1.5× height)
- prevention_rule: Size the text box wider than the longest line; keep ≥1.5×height vertical gap between stacked labels.
- status: RESOLVED

### L005 — Element placed on top of another (column over label)
- date: 2026-06-09
- project: villa plan
- phase / tool: Phase 1 / geometry
- responsible_agent: autocad_002
- symptom: column circle drawn at the same coords as the room label
- root_cause: coordinates not checked against existing entities
- fix: move column to a clear corner; plan coordinates against occupied zones
- prevention_rule: Before placing an element, check its coords don't collide with labels/other entities.
- status: RESOLVED

### L006 — [CRITICAL] puran-water File-IPC (keystrokes) is AutoCAD LT only — fails on Full 2026
- date: 2026-06-09
- project: live drawing attempt
- phase / tool: Phase 0 / backend selection
- responsible_agent: autocad_001
- symptom: "AutoCAD LT detected but mcp_dispatch.lsp not loaded" even though dispatcher WAS loaded (DEF); ping via WM_CHAR keystrokes timed out
- root_cause: puran-water File-IPC drives the LT command line via keystrokes; full AutoCAD's window/command routing differs → keystrokes don't reach the processor
- fix: on full AutoCAD use COM/ActiveX (win32com) instead; ezdxf headless for offline
- prevention_rule: On AutoCAD FULL choose the COM backend for live work; reserve File-IPC for AutoCAD LT; ezdxf for headless.
- status: RESOLVED

### L007 — Arabic text renders but RTL shaping is wrong
- date: 2026-06-09
- project: apartment plan (COM)
- phase / tool: Phase 3 / annotation (AddMText)
- responsible_agent: autocad_004
- symptom: Arabic showed glyphs but disconnected / wrong order ("غ ةف 3"); arial.ttf style add gave "Filer error"
- root_cause: (1) AutoCAD does not reliably shape/RTL Arabic in MTEXT; (2) a full font PATH passed to TextStyle.fontFile throws "Filer error" — it expects a font NAME or a filename on the support path
- fix: DUAL method — (1) PRE-SHAPE in Python before sending: `get_display(arabic_reshaper.reshape(txt))` (`arabic-reshaper`+`python-bidi` in py312) returns connected glyphs in correct visual order, bypassing AutoCAD's engine; (2) set TextStyle by font NAME ("Tahoma"/"Arial") via `style.SetFont(...)` or a filename with NO directory — never a full path. `pip install arabic-reshaper python-bidi` in py312.
- prevention_rule: For Arabic, pre-shape with reshaper+bidi AND set the text style by font name (no full path); verify shaping in real AutoCAD.
- status: RESOLVED (live re-verify pending on next AutoCAD-open job)

### L008 — Leftover entities from previous test in the same drawing
- date: 2026-06-09
- project: apartment live (COM)
- phase / tool: Phase 1 / geometry
- responsible_agent: autocad_002
- symptom: old "LIVE FROM PIPELINE" test text + circle remained under the new plan
- root_cause: drew into the existing drawing that still held test entities
- fix: start a fresh drawing (Documents.Add) for a clean deliverable
- prevention_rule: Start each deliverable in a fresh drawing (Documents.Add) unless explicitly editing an existing file.
- status: RESOLVED

### L009 — Honesty: gross area mislabeled as net
- date: 2026-06-09
- project: apartment plan
- phase / tool: title block / annotation
- responsible_agent: autocad_004
- symptom: title said "188.5 sqm (net rooms)" while net rooms summed to ~151
- root_cause: conflated built-up area with net room area
- fix: label "BUILT-UP = 188.5 sqm; NET ROOMS = 151"; verify any area claim
- prevention_rule: Verify every area/number before writing it on the drawing; distinguish built-up vs net.
- status: RESOLVED

### L010 — Education license stamps outputs
- date: 2026-06-09
- project: AutoCAD 2026 (Education / Non-Commercial)
- phase / tool: export
- responsible_agent: autocad_007
- symptom: DWG/DXF/PDF carry an educational plot stamp when opened in commercial AutoCAD
- root_cause: installed AutoCAD is an Education license
- fix: inform the user; not for commercial deliverables
- prevention_rule: If AutoCAD is an Education license, warn the user that exports carry an educational stamp.
- status: RESOLVED
- license_scope_note (2026-06-11): The Education license is FUNCTIONALLY FULL — every feature works (all 2D/3D commands, COM/ActiveX, AutoLISP/execute_lisp, P&ID, layouts/paper space, plotting, DXF/DWG/PDF; no entity caps, no locked commands). The ONLY limits are non-technical: (1) **educational plot stamp** "PRODUCED BY AN AUTODESK EDUCATIONAL PRODUCT" on anything saved/plotted THROUGH AutoCAD; (2) **stamp contagion** — opening an Education file in a COMMERCIAL AutoCAD makes that commercial copy stamp its outputs too (the mark spreads to projects that include the file); (3) **legal** — educational use only, not for commercial/production deliverables.
- clean-output path: **ezdxf headless (autocad_007) does NOT go through AutoCAD** (standalone Python lib) → its DXF is CLEAN, no stamp. Anything via **COM** (live AutoCAD: live edit / 3D / plotting) carries the stamp. RULE: for a clean 2D deliverable use the ezdxf path; reserve COM for work that genuinely needs live AutoCAD, and warn about the stamp. For serious commercial production, a commercial AutoCAD license (or BricsCAD/ZWCAD) is required.

### L011 — `claude mcp add` mis-parses `-m`
- date: 2026-06-09
- project: server registration
- phase / tool: setup
- responsible_agent: autocad_001
- symptom: `claude mcp add ... -- python -m autocad_mcp` → "unknown option '-m'"
- root_cause: the CLI parses `-m` as its own option even after `--`
- fix: use a launcher script (run_server.py: `from autocad_mcp.server import main; main()`) with no dash args
- prevention_rule: Register MCP servers with a launcher script, never with `-m`/dash args after `--`.
- status: RESOLVED

### L012 — [CRITICAL] Walls were floating boxes with gaps, not a continuous shared system
- date: 2026-06-09
- project: apartment plan
- phase / tool: Phase 1 / geometry
- responsible_agent: autocad_002
- symptom: rooms drawn as separate rectangles with gaps; not like the sketch where the (blue) line IS the wall and adjacent rooms SHARE it
- root_cause: schematic per-room boxes instead of a tiled partition; double outer wall instead of single continuous wall
- fix: model the plan as a TILING — outer rectangle = exterior wall; interior walls are SHARED single-line partitions; rooms are the cells (no gaps, shared edges)
- prevention_rule: Draw walls as ONE continuous shared network (single-line); rooms must tile the footprint sharing walls — never floating boxes with gaps.
- status: RESOLVED

### L013 — Stated TOTAL area must be honored and divided among rooms
- date: 2026-06-09
- project: apartment plan
- phase / tool: geometry + annotation
- responsible_agent: autocad_004
- symptom: plan didn't reflect the stated total (188.5 m2); rooms summed to ~151 with undefined leftover
- root_cause: placed raw net rooms without making them partition the stated total
- fix: tile the footprint so room areas SUM EXACTLY to the stated total; label each room's area
- prevention_rule: When a total area is given, tile the footprint so rooms sum to it; label each room's computed area and verify the sum.
- status: RESOLVED

### L014 — [CRITICAL] Doors must open at the room's own wall, contained inside, not crossing other walls
- date: 2026-06-09
- project: apartment plan
- phase / tool: Phase 2 / doors
- responsible_agent: autocad_002
- symptom: door swing arcs floated mid-space and crossed other walls/edges
- root_cause: doors placed by approximate coords, not hinged on the room boundary with a contained swing
- fix: hinge each door ON the room's wall; swing radius = door width, oriented to stay INSIDE that room; break the wall for the opening
- prevention_rule: Hinge every door on the room's own wall; swing must stay inside that room and never cross another wall.
- status: RESOLVED

### L015 — Standard: deliver architect-grade plans (professional bar)
- date: 2026-06-09
- project: apartment plan
- phase / tool: all
- responsible_agent: autocad_001
- symptom: output read as schematic, not professional ("لازم تصير مهندس محترف")
- root_cause: missing pro conventions (continuous walls, tiled areas, proper door swings, room schedule)
- fix: adopt professional architectural conventions on every plan
- prevention_rule: Every plan must meet a professional architect standard: continuous shared walls, areas tiling the stated total, doors as proper wall openings, a room schedule, verified in AutoCAD.
- status: RESOLVED

### L016 — [CRITICAL] Reproduce the SOURCE faithfully; do not invent an idealized layout
- date: 2026-06-09
- project: apartment plan (from photo)
- phase / tool: Phase 0/1 / fidelity
- responsible_agent: autocad_002
- symptom: generated a tidy grid that was "completely different from the actual drawing" (positions, proportions, adjacencies wrong) across multiple attempts
- root_cause: prioritized a coherent self-made tiling over faithfully matching the user's real geometry
- fix: TRACE the source — extract the actual wall lines from the image (blue mask → vector segments) and draw them as-is; place labels by the real positions; only then refine
- prevention_rule: When given a drawing/photo to reproduce, TRACE the real geometry (image extraction or careful grid reading); never substitute an idealized layout. Match positions, proportions, and adjacencies first.
- fix_applied: OpenCV blue-ink mask → findContours → approxPolyDP → AddLightWeightPolyline in AutoCAD (scaled, Y-flipped) = faithful vector trace of the actual walls; labels placed at transformed source positions. Scripts: C:\AutoCAD_MCP\_trace1.py (mask preview) + _trace3.py (trace + labels).
- status: RESOLVED

### L017 — COM dynamic dispatch intermittently loses methods (AddLightWeightPolyline) with many open drawings
- date: 2026-06-09
- project: 3D conversion
- phase / tool: COM automation
- responsible_agent: autocad_006
- symptom: "AttributeError: <unknown>.AddLightWeightPolyline" on first run; succeeded on retry
- root_cause: win32com late-bound dispatch cache went stale (many drawings open / COM busy)
- fix: retry once; or re-fetch ms = doc.ModelSpace before use; consider win32com gencache (early binding)
- prevention_rule: Wrap COM ModelSpace calls with a retry/re-fetch; don't leave many drawings open during automation.
- status: RESOLVED

### L018 — 2D plan → 3D conversion technique (capability, not an error)
- date: 2026-06-09
- project: 3D conversion
- phase / tool: autocad_006 / 3D
- responsible_agent: autocad_006
- symptom: (none — capability note)
- root_cause: n/a
- fix: set each closed wall polyline's `.Thickness = ceiling_height` (robust vertical extrude to surfaces); then SW/SE iso via SendCommand "_-VPOINT 1,-1,1", "_ZOOM _E", "_VSCURRENT _Conceptual". For solid walls use AddRegion + Boolean subtract (room voids) + AddExtrudedSolid.
- prevention_rule: For quick 3D from a wall plan, use polyline.Thickness; for true solids use region-boolean + extrude. Verify in an iso shaded view.
- status: RESOLVED

### L019 — [CRITICAL] Source is a 3D/perspective RENDER, not a 2D ortho line-drawing → visual REBUILD, not auto-trace
- date: 2026-06-11
- project: villa plan from 3D render (IMG_4109)
- phase / tool: Phase 0 / fidelity + Phase 0.5 capability-gap
- responsible_agent: autocad_008 (discovered by autocad_research_001 gate)
- symptom: the source is a colored 3D isometric render of a furnished plan; the L016 auto-trace (OpenCV blue-mask → contours → polylines) does not apply — there are no clean 2D wall lines and the perspective distorts true metrics
- root_cause: L016 assumes a FLAT 2D orthographic line/CAD sketch; a 3D render/perspective/photo-of-a-model has shaded volumes, furniture, and foreshortening instead of measurable wall lines
- fix: FIRST classify the source image — (a) 2D ortho line/CAD sketch → use L016 auto-trace; (b) 3D render / perspective / photo of a model → VISUAL REBUILD: read the layout and reconstruct it as a top-down 2D plan using shared-wall tiling (L012/L013/L014); estimate dimensions proportionally when no scale is given
- prevention_rule: Before reproducing a source, CLASSIFY it (2D ortho vs 3D/perspective). Auto-trace (L016) ONLY for 2D ortho line drawings; for 3D renders/perspective/photos do a visual rebuild, never an auto-trace.
- status: RESOLVED (adopted before execution per user instruction)

### L020 — COM error -2147418111 "Call was rejected by callee" on Documents.Add() → immediate Layers.Add()
- date: 2026-06-11
- project: villa from 3D render (IMG_4109)
- phase / tool: Phase 1 / geometry (COM live build, villa_build_com.py)
- responsible_agent: autocad_002
- symptom: first run failed — `Documents.Add()` followed immediately by `Layers.Add()` (and other entity calls) threw COM error -2147418111 "Call was rejected by callee"; the same script succeeded on a clean second run
- root_cause: the freshly created drawing is not finished initializing / the AutoCAD app is momentarily busy ("callee" not ready) when the very next COM call arrives, so COM rejects the call (HRESULT -2147418111 / -2147417846 RPC_E_SERVERCALL_RETRYLATER class)
- fix: added a `com_busy_retry()` wrapper that retries the call on -2147418111 / -2147417846 (busy/rejected) with a short delay, wrapped around Documents.Add, ModelSpace fetch, Layers, every entity add, and SaveAs; plus `time.sleep(1.0–1.5)` immediately after Documents.Add to let the new drawing initialize before touching Layers/ModelSpace. Second run succeeded cleanly.
- prevention_rule: After Documents.Add, sleep ~1–1.5 s before the next COM call, and wrap all COM calls (Add/ModelSpace/Layers/entities/SaveAs) in a busy-retry that catches -2147418111 / -2147417846 and retries with delay — never call Layers.Add()/ModelSpace immediately after creating a drawing.
- status: RESOLVED (script re-ran cleanly; villa_plan.dwg built, 118 entities)

### L021 — Docked AutoCAD palette occludes the plan in the COM verification screenshot
- date: 2026-06-11
- project: villa from 3D render (IMG_4109)
- phase / tool: verification / export (autocad_007, villa_plan_acad.png)
- responsible_agent: autocad_007
- symptom: in the COM verification screenshot a docked palette (likely the Connect/sign-in panel) overlapped the top-left zone (BEDROOM 2 / DRESSING / BATH 1), partly hiding entities that were confirmed present in the build log (118 entities); `PROPERTIESCLOSE` alone did not clear it
- root_cause: open/docked AutoCAD palettes (Properties, Connect/sign-in, tool palettes) float over the drawing area and are captured in the COM/window screenshot, occluding part of the plan; closing only the Properties palette is insufficient
- fix: before taking the verification screenshot, close/hide the palettes via SendCommand — e.g. `_PROPERTIESCLOSE`, `_TOOLPALETTESCLOSE`, `CLEANSCREENON` (and dismiss the Connect/sign-in panel) — then ZoomExtents and capture; verify the captured PNG shows the full footprint with no overlay before declaring verification done
- prevention_rule: Before the verification screenshot, close/hide ALL palettes (PROPERTIESCLOSE + TOOLPALETTESCLOSE + dismiss Connect/sign-in; optionally CLEANSCREENON) and confirm the captured PNG shows the whole plan unobstructed — never verify from a screenshot with a palette overlapping the drawing.
- status: RESOLVED (lesson taught; future captures must clear palettes first)

### L022 — [CRITICAL] Visual rebuild must honor the REAL layout (en-suite baths, central living, entry), not collapse it to a tidy grid
- date: 2026-06-11
- project: villa from 3D render (IMG_4109) — rebuild v2
- phase / tool: Phase 0/1 / architectural fidelity
- responsible_agent: autocad_008
- symptom: rebuild v1 reproduced the right room COUNT/types but flattened the organic plan into a regular 6-cell grid — baths became a separate strip instead of en-suite inside the bedrooms, the central open living/circulation hub was lost, dressing/closets and the front entry/terrace were dropped. Faithful to the count, not to the plan. (this is the L016 trap occurring even after a correct L019 classification)
- root_cause: during visual rebuild the agent optimized for a clean tiling that sums to the total area, instead of preserving the source's actual spatial relationships (adjacencies, en-suite baths, central living as circulation, entry sequence)
- fix: in visual rebuild, FIRST extract the real spatial structure from the render — which baths/closets are INSIDE which bedroom (en-suite), where the central living/circulation hub is, how each room is ACCESSED (doors onto the hub/corridor, not arbitrary openings), and the entry/terrace — then tile to total while keeping those relationships. Bedrooms contain their own bath+closet; living is the central connector; include the entry.
- prevention_rule: Visual rebuild (L019) must preserve REAL adjacencies & circulation — en-suite baths/closets inside their bedroom, a central living/circulation hub rooms open onto, a sensible entry sequence — NEVER collapse the plan into a uniform grid just because the areas sum. Fidelity of relationships > tidy tiling.
- status: RESOLVED (adopted before rebuild v2 per user instruction)
- verification (2026-06-11): rebuild v2 applied L022 successfully (en-suite baths inside bedrooms + central living hub + dressing inside bed2 + front entry) and scored **8/10** fidelity vs source render IMG_4109, up from the v1 tidy grid (~5/10). L022 confirmed EFFECTIVE.

### L023 — Text shows letter "O" as a box (□) in AutoCAD ("BEDR□□M") → default text style/font can't render the glyph
- date: 2026-06-11
- project: villa from 3D render (IMG_4109) — rebuild v2
- phase / tool: Phase 3 / annotation (room labels via AddText)
- responsible_agent: autocad_004
- symptom: in the AutoCAD verification screenshot, labels rendered the letter "O" as a tofu box □ (e.g. "BEDR□□M", "KITCHEN" partly boxed) — the glyph was missing even for plain Latin text
- root_cause: the labels were drawn with AutoCAD's default text style, which uses an SHX vector font (e.g. `txt.shx`) that does not contain/render the glyph correctly; no TrueType text style was defined before adding the text
- fix: BEFORE adding any text, define a Text Style backed by a clear TrueType font set by NAME (e.g. "Arial"/"Tahoma") — never a full font path (L007 "Filer error") — and assign that style to every label entity (`text.StyleName = "<style>"`); then the glyphs render correctly
- prevention_rule: Before placing labels, create/select a Text Style with a TrueType font by NAME (Arial/Tahoma; no full path per L007) and assign it to every text entity — never rely on the default SHX style, which renders some glyphs (incl. "O") as □ boxes.
- status: RESOLVED

### L024 — [CRITICAL] OUTPUT FORMAT must match the source: a 3D render implies a 3D MODEL deliverable, not just a 2D plan
- date: 2026-06-11
- project: villa from 3D render (IMG_4109)
- phase / tool: Phase 0 / requirements — target output type
- responsible_agent: autocad_research_001 (+ autocad_001)
- symptom: the pipeline classified the SOURCE correctly (3D render → visual rebuild) but assumed the DELIVERABLE was a flat 2D floor plan and built only that. User: "you're working blind — the design is wrong, adopt a 3D build, not just a 2D plan." The expected output was a 3D MODEL matching the render, not a 2D drawing.
- root_cause: requirements analysis confirmed goal/units/standard but NEVER pinned the OUTPUT DIMENSIONALITY (2D plan vs 3D model). When the source is a 3D render, the default expectation is a 3D model; assuming 2D is working blind.
- fix: in Phase 0, EXPLICITLY confirm the output format/dimensionality. Heuristic: source is a 3D render/model → deliver a 3D model (extruded walls to ceiling height, floors, openings, optionally 3D furniture) in an iso shaded view — AND a 2D plan if also wanted. Raise walls via polyline.Thickness or region/extrude (L018), iso via VPOINT, VSCURRENT Conceptual. Route 3D to autocad_006.
- prevention_rule: ALWAYS confirm output dimensionality in Phase 0 (research_001 must ask/derive it). If the source is a 3D render/model, deliver a 3D model by default (not only a 2D plan). Match the deliverable's format to the source's format.
- status: RESOLVED — 3D model built (villa_3d.dwg): walls raised to 3000mm via Thickness + floor + 3D furniture + entry columns + iso Conceptual shaded view; matches the dollhouse-render format.

### L025 — 3D-via-COM: set iso view by Viewport.Direction (no SendCommand); shading needs SendCommand not SetVariable; save BEFORE view commands
- date: 2026-06-11
- project: villa 3D model (IMG_4109)
- phase / tool: autocad_006 / 3D COM build + view
- responsible_agent: autocad_006
- symptom: (1) the 3D build script HUNG after SaveAs on `SendCommand("_.-VPOINT\n1,-1,1\n")` (multi-line VPOINT left AutoCAD waiting); the timeout killed it but DWG was already saved. (2) `doc.SetVariable("VSCURRENT","Conceptual")` threw "Error setting system variable".
- root_cause: multi-step SendCommand view macros can leave AutoCAD in a waiting/modal state and hang the COM caller; VSCURRENT is not settable via SetVariable; and mixing view commands into the build risks losing the model if it hangs before save
- fix: (a) set the 3D iso view via COM property — `vp=doc.ActiveViewport; vp.direction=VARIANT(...,(1,-1,1)); doc.ActiveViewport=vp; app.ZoomExtents()` (no SendCommand). (b) apply shading via `doc.SendCommand("_.VSCURRENT\n_C\n")` (SendCommand, single clean macro) — NOT SetVariable. (c) ALWAYS `SaveAs` the model BEFORE issuing any view/SendCommand so a hang never loses the build. (d) run view+screenshot in a SEPARATE short script.
- prevention_rule: For 3D-via-COM: set view by Viewport.Direction (no SendCommand); shade via SendCommand VSCURRENT (not SetVariable); SAVE the model before any view command; keep view/screenshot in a separate script.
- status: RESOLVED (villa_3d_shaded.png produced)

### L026 — AutoCAD COM goes unresponsive (AttributeError on Documents.Count/Add) when a command is pending → send ESC
- date: 2026-06-11
- project: villa 3D model (IMG_4109)
- phase / tool: autocad_006 / COM recovery
- responsible_agent: autocad_006
- symptom: `app.Name` worked but `app.Documents.Count` / `Documents.Add()` raised `AttributeError: <unknown>.Add/Count` — AutoCAD was busy with a pending command (left over from a hung SendCommand), rejecting child COM calls
- root_cause: a pending command / modal state at the AutoCAD command line blocks new COM calls on sub-objects (not a dispatch-cache issue); the app object answers but its collections don't
- fix: before resuming COM, activate the window and send ESC keystrokes — `win32gui.SetForegroundWindow(app.HWND)` then `win32api.keybd_event(0x1B,...)` x2-3 — to cancel the pending command; then Documents.Count/Add work again
- prevention_rule: If AutoCAD COM sub-calls (Documents.Count/Add, ModelSpace) throw AttributeError while app.Name works, the app is busy with a pending command — send ESC keystrokes to its window to clear it, then retry. (complements L020's busy-retry)
- status: RESOLVED
