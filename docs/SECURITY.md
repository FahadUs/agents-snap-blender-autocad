# Security & Cost — Safe to Download, Costs Nothing

This repository contains **only text**: agent prompts (`.md`), metadata (`.json`), documentation, and four small local helper scripts. There is **no application, no server, no account, and no API key** anywhere in it.

## What was verified

A full scan of every file in the repository confirmed:

| Check | Result |
|-------|--------|
| API keys / tokens / secrets (`api_key`, `sk-`, `ghp_`, `AKIA`, bearer tokens, private keys) | ✅ None found |
| `.env`, `*.key`, `*.pem`, credential files | ✅ None exist |
| Hardcoded URLs / HTTP endpoints | ✅ None found |
| Network calls in code (`requests`, `urllib`, `fetch`, `curl`, `Invoke-WebRequest`, sockets) | ✅ None — all 4 scripts are local-only |
| Anthropic / OpenAI / paid-API references | ✅ None |
| Personal email / private identifiers | ✅ None |

> The only "secret"-looking string in the repo is the literal placeholder `SECRET_KEY=your-secret-key` inside a project template (`protocols/port_registry.md`) — an example, not a real key.

## Why it cannot consume anyone's balance

- **Prompts don't run on their own.** A `PROMPT.md` is instructions for an AI agent. Reading or cloning this repo executes nothing.
- **No embedded provider.** Nothing here calls Anthropic, OpenAI, or any billed API. The cost of running an agent is borne by **whoever loads the prompt into their own LLM tool, with their own subscription** — exactly as with any prompt.
- **External tools are opt-in and bring-your-own-key.** Some pipelines *can* use third-party tools (Hyper3D Rodin AI generation, Sketchfab downloads, the Blender/AutoCAD MCP servers). These:
  - are **not** included in this repo,
  - run **only when the user explicitly invokes them**, and
  - use the **user's own** accounts/keys, configured in the user's own environment.

In short: **publishing or downloading this repo charges no one.** Running an agent costs only the LLM tokens of the person who chooses to run it.

## The 4 local scripts (audited)

| Script | Language | Network? | Purpose |
|--------|----------|----------|---------|
| `protocols/snap_blender_scripts/prep_for_lens.py` | Python (Blender `bpy`) | No | Local headless model prep |
| `protocols/snap_game_templates/GameManager.js` | JavaScript (Lens Studio) | No | Game state-machine template |
| `protocols/tools/verify_3d_asset.ps1` | PowerShell | No | Local 3D-asset validation |
| `protocols/find_free_ports.ps1` | PowerShell | No | Local free-port finder |

## Note on file paths

Some files reference absolute Windows paths under `C:/Users/fahad/...` (the author's machine). These are harmless references, not secrets — but if you reuse the repo, adjust paths to your own environment. They do not affect security or cost.

## Recommendation before publishing

- Add a `.gitignore` if you later add real project files, so you never commit `CLAUDE.md` files that contain *your* project credentials.
- Keep any real API keys in your local environment / MCP config — never in a committed file.
