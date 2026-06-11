# Documentation Index

Full reference for the **Snap × Blender × AutoCAD** agent system — 39 agents across three pipelines, fronted by one orchestrator.

## Contents

| Document | Covers |
|----------|--------|
| [orchestrator.md](orchestrator.md) | `orch_builder` — the single entry point & router |
| [snap-lens-pipeline.md](snap-lens-pipeline.md) | 20 Snap Lens agents (`snap_*`) |
| [blender-pipeline.md](blender-pipeline.md) | 7 Blender MCP agents (`blender_*`) |
| [autocad-pipeline.md](autocad-pipeline.md) | 11 AutoCAD MCP agents (`autocad_*`) |
| [usage.md](usage.md) | How to install and run the agents |
| [SECURITY.md](SECURITY.md) | Why this repo is safe & free to use (no keys, no telemetry) |

## How the system is organized

Every agent lives in its own folder under `agents_system/`:

```
agents_system/<agent_id>/
├── PROMPT.md      ← the agent's system prompt (its role, rules, pipeline)
└── config.json    ← metadata: id, name, department, responsibilities, dependencies
```

> Three agents (`snap_016`, `snap_017`, `snap_qa_001`) ship with `PROMPT.md` only — faithfully matching the original source.

The `protocols/` folder holds shared knowledge the agents reference:

| Item | Purpose |
|------|---------|
| `snap_lens_delivery_pipeline.md` | The 10-phase Snap lens build process |
| `snap_blender_prep_pipeline.md` | Preparing a 3D model for Lens Studio (headless `prep_for_lens.py`) |
| `snap_lensstudio_build_playbook.md` | Lens Studio build & verification playbook |
| `blender_mcp_pipeline.md` | Blender MCP workflow (21 tools, phases, rules) |
| `autocad_mcp_pipeline.md` | AutoCAD MCP workflow (tools, phases, backends) |
| `autocad_improvement_pipeline.md` | Closed-loop learning for the AutoCAD agents |
| `Senior_Agent_Operating_Standard.md` | **SAOS** — the quality standard every agent obeys |
| `CLAUDE_snap_lens_template.md` / `CLAUDE_autocad_template.md` / `CLAUDE_master_template.md` | Per-project setup templates |
| `snap_blender_scripts/`, `snap_game_templates/`, `tools/`, `autocad_lessons/` | Helper scripts & accumulated lessons |

## The quality backbone: SAOS

Every agent must comply with the **Senior Agent Operating Standard** (`protocols/Senior_Agent_Operating_Standard.md`), summarized as C1–C7:

1. **C1 — Standards-grounded:** built on recognized standards for its domain.
2. **C2 — Ask, don't guess:** asks the user when information is missing.
3. **C3 — Methodology-driven:** plans before producing.
4. **C4 — Coverage-traceable:** maps its output back to requirements.
5. **C5 — HARD STOP before handoff:** never passes broken work downstream.
6. **C6 — Clean-encoded:** no garbled text / mojibake.
7. **C7 — Definition of Done:** meets an explicit completion checklist.

## At a glance — all 39 agents

| Pipeline | Count | Entry | Range |
|----------|-------|-------|-------|
| Orchestration | 1 | `orch_builder` | — |
| Snap Lens | 20 | `snap_001` | `snap_001`–`snap_017`, `snap_blender_001`, `snap_gate_001`, `snap_qa_001` |
| Blender 3D | 7 | `blender_001` | `blender_001`–`blender_007` |
| AutoCAD CAD | 11 | `autocad_001` | `autocad_001`–`autocad_009`, `autocad_qa_001`, `autocad_research_001` |

See each pipeline doc for the full agent-by-agent breakdown.
