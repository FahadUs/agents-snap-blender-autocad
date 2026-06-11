# Agents · Snap × Blender × AutoCAD

A standalone collection of **39 AI agent prompts** that turn an LLM coding assistant (Claude Code, Cursor, or any agent runner) into three specialized production pipelines:

| Pipeline | What it builds | Entry agent |
|----------|----------------|-------------|
| 🟡 **Snap Lens** | Snapchat filters, AR face/world lenses, SnapML effects, AR lens games | `snap_001` |
| 🟦 **Blender 3D** | 3D modeling, materials, asset libraries, AI generation, export — via Blender MCP | `blender_001` |
| 🟥 **AutoCAD CAD** | 2D drafting, layers, blocks, dimensions, P&ID, AutoLISP, DXF/DWG export — via AutoCAD MCP | `autocad_001` |

A single orchestrator, **`orch_builder`**, is the entry point: it classifies your task, runs a boot check, and routes it to the right pipeline.

```
You ──▶ orch_builder ──┬──▶ snap_001    ──▶ snap_002 … snap_017
                       ├──▶ blender_001 ──▶ blender_002 … blender_007
                       └──▶ autocad_001 ──▶ autocad_002 … autocad_009
```

## 📖 Documentation

- [docs/README.md](docs/README.md) — full index & how-to
- [docs/orchestrator.md](docs/orchestrator.md) — `orch_builder` (the connecting link)
- [docs/snap-lens-pipeline.md](docs/snap-lens-pipeline.md) — 20 Snap agents
- [docs/blender-pipeline.md](docs/blender-pipeline.md) — 7 Blender agents
- [docs/autocad-pipeline.md](docs/autocad-pipeline.md) — 11 AutoCAD agents
- [docs/usage.md](docs/usage.md) — install & run
- [docs/SECURITY.md](docs/SECURITY.md) — **no API keys, no telemetry, costs nothing to download**

## ✅ What this is — and isn't

- **Is:** plain-text prompt engineering. Every agent is a `PROMPT.md` (its instructions) + a `config.json` (its metadata). No application code, no servers, no accounts.
- **Isn't:** a hosted service. Nothing here phones home or charges anyone. See [SECURITY.md](docs/SECURITY.md).
- Optional external tools (Blender MCP, AutoCAD MCP, Hyper3D, Sketchfab) are **invoked by you, with your own keys, only when you run them** — this repo contains none.

## 🗂️ Repository layout

```
.
├── README.md                 ← you are here
├── catalog_manifest.json     ← machine-readable index of all 39 agents
├── agents_system/            ← 39 agents, one folder each (PROMPT.md + config.json)
├── protocols/                ← pipelines, standards (SAOS), templates, helper scripts
└── docs/                     ← human-readable reports (this documentation)
```

## License & attribution

Prompts and protocols are provided as-is for reuse. When a pipeline fetches third-party assets (Sketchfab / PolyHaven), follow each asset's own license (CC0 / CC-BY attribution).

---

*Built as a portable copy of the Snap, Blender, and AutoCAD pipelines from a larger Enterprise Agents system.*
