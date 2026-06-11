# Lessons for autocad_001 (Coordinator) — read before every job

- [L003] Never judge final quality from the ezdxf/matplotlib preview; verify text/Arabic/output in real AutoCAD (COM screenshot). (source: □ glyphs & missing Arabic in preview while DXF was correct)
- [L006] On AutoCAD **FULL** select the **COM** backend for live work; reserve File-IPC (keystrokes) for AutoCAD **LT**; use ezdxf for headless. puran-water File-IPC fails on full AutoCAD even when the dispatcher is loaded. (source: "LT detected, dispatcher not loaded" + keystroke ping timeout)
- [L011] Register MCP servers with a launcher script (run_server.py), never `-m`/dash args after `--` (the CLI mis-parses them). (source: "unknown option '-m'")
