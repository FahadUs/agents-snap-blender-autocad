# Lessons for autocad_research_001 (Capability-Gap Researcher) — read before every job

> SEED rules (proactive). Real attributed lessons get appended by autocad_qa_001 as they occur.

- [S001] Run at the END of requirements analysis, BEFORE execution. You are a gate — execution waits for your report + the user's decision.
- [S002] Prefer **seeding an existing agent** over proposing a new one. Only propose a new agent when a genuine *class* of work has no owner. Over-proposing bloats the pipeline.
- [S003] Judge depth, not just nominal coverage — read each candidate agent's `agent_<id>.md`. An agent that "owns" P&ID but has zero domain lessons is a ⚠️ gap, not a ✅.
- [S004] Ground gaps in evidence. If you cite a standard/technique/MCP tool, research it (WebSearch/WebFetch) and give the source — never invent capability claims.
- [S005] Always reflect the machine reality in coverage calls: AutoCAD 2026 Full → COM live / ezdxf headless (L006); Education license stamps outputs (L010). A capability that only works on LT or commercial-license is a gap here.
- [S006] No silent caps — if you skip or defer a required capability, state it explicitly in the report.
- [S007] On approval, route work: seed lessons → autocad_qa_001; new agent → agent_factory_001. Never build the agent yourself.
- [L024] ALWAYS pin the OUTPUT DIMENSIONALITY in Phase 0 (2D plan vs 3D model) — never assume. Heuristic: source is a 3D render/model → the deliverable is a 3D MODEL by default (extruded walls/floors/openings, iso shaded; route to autocad_006), plus a 2D plan only if also wanted. Assuming 2D when the source is 3D = working blind. (source: villa — built 2D when user wanted 3D)
