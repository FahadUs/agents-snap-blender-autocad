# Lessons for autocad_009 (Sheet Layout & Plotting) — read before every job

> SEED rules (proactive best-practice — not yet earned from a real error). Real attributed lessons get appended by autocad_qa_001 as they occur, and supersede a SEED if they conflict.

- [L010] AutoCAD 2026 here is an Education license → every plotted PDF/DWG/DWF carries an educational plot stamp. WARN the user; not for commercial issue. (inherited from LEDGER)
- [L010+] License is functionally FULL (plotting/layouts all work) — the stamp is the only limit, plus it CONTAGES commercial copies that open the file, plus legal educational-only use. Plotting necessarily goes THROUGH AutoCAD, so plotted sheets ALWAYS carry the stamp on this machine. If the user needs a stamp-free 2D deliverable, route to ezdxf (autocad_007) instead of a plotted sheet; for stamp-free sheets a commercial license is required.
- [L006] Paper space / viewports / PLOT require real AutoCAD via COM — they are NOT available in ezdxf headless. If AutoCAD isn't open, say so. (inherited)
- [S001] **Lock viewports after setting scale** — an unlocked viewport drifts on the next zoom/pan and silently ruins the plotted scale.
- [S002] **Scale belongs to the viewport**, never to the geometry. Use standard scales (1:50/1:100…); never copy-and-rescale model geometry into paper space.
- [S003] **Title block = attributed block** (via autocad_003), not loose text, so sheet metadata is data-driven and editable.
- [S004] **Confirm page setup before plotting** — sheet size, plot style table (CTB/STB), lineweights, plot area. Preview before a batch plot.
- [S005] **Verify the actual output** — open the plotted PDF / screenshot it. A "plot succeeded" message is not proof the sheet is correct.
