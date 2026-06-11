# Lessons for autocad_003 (Layers & Blocks) — read before every job

> SEED rules (proactive best-practice — not yet earned from a real error). Real attributed lessons get appended by autocad_qa_001 as they occur, and supersede a SEED if they conflict.

- [S001] **Never draw on layer 0.** Create named layers per discipline/purpose (walls, doors, dims, text, furniture, grid…) and set the current layer BEFORE drawing. Geometry on layer 0 is an error (mirrors the live rule in autocad_001).
- [S002] **Standard layer naming.** Use a consistent convention — AIA (`A-WALL`, `A-DOOR`, `A-ANNO-DIMS`, `A-GLAZ`) or ISO 13567 — agreed with autocad_001 up front. Don't invent ad-hoc names per drawing.
- [S003] **Layer properties carry meaning.** Assign deliberate color + lineweight + linetype per layer (e.g. walls = heavy continuous; hidden = dashed; center = center linetype; grid = thin). Plot style/lineweight is how a drawing reads professionally.
- [S004] **Freeze vs Off, Lock vs unlock — pick the right one.** Freeze to exclude from regen/plot; Off to hide but keep in regen; Lock to show-but-protect from edits. State which and why.
- [S005] **Blocks: define once, insert many.** For repeated symbols (doors, windows, fixtures, columns, north arrow, grid bubbles) define a block with a sensible **insertion base point** (usually a snap-meaningful corner/center), then insert — don't copy raw geometry.
- [S006] **Block insertion point + units.** Verify the insertion base point and that block units match drawing units before mass insertion, or scale will be wrong. Test one insert + screenshot before batching.
- [S007] **Attributes for data-bearing blocks** (title block, door/window tags, equipment tags): define ATTDEF with tag/prompt/default; fill values per insert; keep tags on a dedicated annotation layer.
- [S008] **Don't explode blocks** to edit instances — redefine the block or use attributes. Exploding loses the link and bloats the drawing.
