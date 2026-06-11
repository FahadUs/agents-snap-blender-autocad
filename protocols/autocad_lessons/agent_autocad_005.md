# Lessons for autocad_005 (P&ID) — read before every job

> SEED rules (proactive best-practice — not yet earned from a real error). Real attributed lessons get appended by autocad_qa_001 as they occur, and supersede a SEED if they conflict.

- [S001] **Follow a recognized symbol standard.** Use ISA-5.1 (instrumentation) / ISO 10628 (process diagrams) symbol shapes for valves, pumps, vessels, instruments, exchangers. Confirm with autocad_001 which standard the client uses before drawing — don't mix conventions.
- [S002] **Symbols as blocks with a defined connection point.** Build each symbol once as a block whose insertion point sits on its process-line connection node, so lines snap cleanly. Reuse via insert, never redraw.
- [S003] **Instrument bubbles + tag discipline.** Instrument circles carry the ISA tag (function letters on top, loop number below). Single line = field-mounted; single horizontal line = main panel; etc. Keep tags consistent and unique per loop.
- [S004] **Layer separation by entity class.** Process lines, instrument signal lines (dashed/with markers), equipment, instruments, and tags each on their own layer (coordinate with autocad_003) so the diagram can be filtered/plotted by class.
- [S005] **Line type encodes the medium/signal.** Major process = solid heavy; secondary = lighter; pneumatic/electric/data signals each use their ISA signal-line convention. Don't draw every line identical.
- [S006] **Flow direction is explicit.** Add flow arrows on process lines; orient pumps/valves with their inlet/outlet correct. A reviewer must read direction without guessing.
- [S007] **Connectivity, not just pictures.** Lines must actually terminate ON equipment/instrument connection nodes (snap), not float near them — P&ID validity depends on real connections.
- [S008] **Verify against a legend.** Provide/respect a symbol legend + line-list; every symbol and tag on the sheet should map to it. Screenshot-verify the assembled diagram.
