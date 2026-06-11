# Lessons for autocad_004 (Annotation & Dimensions) — read before every job

- [L001] For multi-line labels use a SEPARATE text entity per line (preview-safe), or `\P` for MTEXT line breaks — NEVER `\n` (MTEXT ignores it; preview wraps by width only). (source: "KITCHEN5.0" merge)
- [L002] MTEXT insert point is TOP-LEFT, not center. To center: offset insert by ≈ (-len*height*0.3, +height). (source: labels drifting to edges)
- [L004] Size the text box wider than the longest line; keep ≥1.5×height vertical gap between stacked labels. (source: long label wrapped onto dims)
- [L007] **Arabic RTL — SOLVED (dual method).** AutoCAD does NOT reliably shape/RTL Arabic in MTEXT by default. The robust fix has TWO parts:
  1. **PRE-SHAPE in Python before sending** (authoritative — bypasses AutoCAD's engine entirely): in `py312` use `arabic-reshaper` + `python-bidi`:
     ```python
     import arabic_reshaper
     from bidi.algorithm import get_display
     def ar(txt):  # call on EVERY Arabic string before AddText/AddMText
         return get_display(arabic_reshaper.reshape(txt))
     ```
     Send `ar("غرفة نوم")` — it returns connected glyphs in correct visual order; AutoCAD just renders them.
  2. **TextStyle by font NAME, not full path** (fixes the "Filer error"): set the style's typeface by name (e.g. "Tahoma"/"Arial") via `style.SetFont(typeface, bold, italic, charset, pitch)`, OR a font FILENAME with NO directory (AutoCAD resolves it on its support-file search path). NEVER pass a full `C:\...\arial.ttf` path to `.fontFile` → that throws "Filer error".
  - Always verify shaping visually in real AutoCAD (COM screenshot) before delivery.
  - (source: "غ ةف 3" disconnected + arial.ttf Filer error) [STATUS: RESOLVED — live re-verify on next AutoCAD-open job]
- [L009] Verify EVERY area/number before writing it on the drawing; distinguish BUILT-UP vs NET area. (source: gross labeled as net)
- [L013] When a total area is given, label each room's computed area and a room SCHEDULE; verify the room areas SUM to the stated total. (source: stated 188.5 not honored)
- [L023] BEFORE adding any text, define/select a Text Style with a TrueType font by NAME (e.g. "Arial"/"Tahoma" — no full path, per L007) and assign it to every label (`text.StyleName="<style>"`). The default SHX style (txt.shx) renders some glyphs — incl. the letter "O" — as a box □ ("BEDR□□M"). (source: villa v2 labels showed □ for "O")
