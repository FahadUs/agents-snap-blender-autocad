# Lessons for autocad_008 (Architectural & Space Planning) — read before every job

> Inherits the architect-grade rules earned on the apartment-plan project (L012–L016), now owned by this agent.

- [L012] Draw walls as ONE continuous shared network (single-line); rooms tile the footprint sharing walls — never floating boxes with gaps, never double outer walls.
- [L013] When a total area is given, tile the footprint so room areas SUM EXACTLY to it; label each room's area and produce a room SCHEDULE; verify the sum.
- [L014] Hinge every door on the room's OWN wall; swing radius = door width, contained INSIDE that room; break the wall for the opening. Doors never float or cross other walls.
- [L015] Every plan must meet the professional architect bar: continuous shared walls, areas tiling the stated total, doors as proper openings, a room schedule, verified in real AutoCAD.
- [L016] When given a drawing/photo to reproduce, TRACE the real geometry (OpenCV mask → contours → polylines) — never substitute an idealized layout. Match positions/proportions/adjacencies first, then refine. Scripts: _trace1.py / _trace3.py. **Applies ONLY to 2D ortho line drawings (see L019).**
- [L019] **CLASSIFY the source image FIRST.** (a) 2D ortho line/CAD sketch → use L016 auto-trace. (b) 3D render / perspective / photo of a model → **VISUAL REBUILD**: read the layout and reconstruct it as a top-down 2D plan with shared-wall tiling (L012/L013/L014); estimate dimensions proportionally if no scale is given. NEVER auto-trace a 3D/perspective render — there are no clean wall lines and perspective distorts metrics. (source: villa from 3D render IMG_4109; discovered by autocad_research_001)
- [L022] **Visual rebuild must honor the REAL layout, not a tidy grid.** Extract actual spatial structure FIRST: which bath/closet is INSIDE which bedroom (en-suite), where the central living/circulation hub is, how each room is ACCESSED (doors onto the hub/corridor), and the entry/terrace. Then tile to total while KEEPING those relationships. Bedrooms contain their own bath+closet; living is the central connector; include the entry. NEVER collapse to a uniform grid just because areas sum — fidelity of relationships > tidy tiling. (source: villa rebuild v1 grid-trap)
- [L003] Never judge final quality from the matplotlib preview; verify in real AutoCAD (COM screenshot).
- [L005] Before placing an element (column/fixture), check its coords don't collide with labels/other entities.
