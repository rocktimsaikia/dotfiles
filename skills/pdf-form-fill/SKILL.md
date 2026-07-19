---
name: pdf-form-fill
description: Precisely fill a flat / non-fillable PDF form (no AcroForm fields) by overlaying values at measured coordinates, verified by machine and eye. Use when the user asks to fill, complete, or type values onto a PDF form that has no real form fields. For PDFs with real AcroForm/XFA fields, fill by field name instead - this overlay procedure is unnecessary.
---

# Precise PDF Form Filling (Flat / Non-Fillable Forms)

You are a meticulous PDF form-filling agent. Your job is to overlay user-provided
values onto a flat PDF form (one with **no AcroForm fields**) so that the result
looks as if it were typed by a single, careful system: every value sits inside the
correct field, on the correct line, at one consistent font size, with no overflow,
collision, or drift. You treat "mathematically correct" and "looks right to a human"
as two separate bars, and you must clear both.

---

## CORE PRINCIPLES (never violate)

1. **Measure, never estimate.** Derive every coordinate from the PDF's own vector
   objects (lines, rects, character-box cells, word positions). Eyeballing a
   rendered image to guess coordinates is prohibited except as a last-resort
   fallback that must be explicitly flagged.
2. **One overlay font, one size.** All values you add use a single font and a single
   point size across the entire document. Never vary point size to make something fit
   — use horizontal text-scaling instead (see Fit rule).
3. **Baseline math, not trial-and-error.** Position text by computing its baseline
   from font metrics, not by nudging until it looks right.
4. **Fit by width-scaling, not shrinking.** If a value is too wide for its cell,
   compress it horizontally while keeping glyph height identical, so it still reads as
   the same size as everything else.
5. **Verify in two passes: machine, then eye.** A programmatic bounds/collision check
   AND a rendered visual review are both mandatory before delivery. The visual review
   compares fields *against each other*, not just each field in isolation.
6. **Never fill prohibited fields.** Signatures, and unless the user has explicitly
   provided the value for their own form: passwords, OTPs, or anything requiring a
   handwritten mark. Credentials the user themselves supplies for their own form
   (PAN, account no, IFSC) may be placed; a signature never is.
7. **Confirm data semantics with the user.** Alignment ≠ correctness. Surface the
   actual values (especially amounts, dates, yes/no answers, claim types) for the user
   to confirm. Flag anything you inferred, summed, or guessed.

---

## PHASE 0 — INTAKE

- Confirm whether the PDF has real form fields. If it **does** (AcroForm/XFA), fill by
  field name — this whole overlay procedure is unnecessary. Proceed below only for
  **flat** forms.
- Identify which pages/sections are in scope. Explicitly list sections that are:
  - filled by the user (you fill),
  - filled by a third party (e.g. hospital, employer — leave blank),
  - conditionally required (state the condition; skip if not met),
  - signature/date/place (leave for the human).
- Collect all values. For each, note provenance: user-typed, extracted from an
  uploaded document (cite which), or computed (show the computation).
- Detect any **pre-printed personalization** already on the "blank" form (some forms
  ship with the holder's name/ID pre-filled). Do NOT re-fill those — it causes doubling.
  Verify by rendering the untouched original and inspecting the target fields.

---

## PHASE 1 — MEASURE GEOMETRY (from vectors)

For every field you will fill, obtain coordinates from the document, not a picture.

### Character-box grids (one glyph per cell)
- Extract cell rectangles from vector rects / annotation boxes.
- Detection is often **incomplete** — it may miss the first or last cell. Therefore:
  1. Compute the **pitch** (cell-to-cell spacing) from any two detected adjacent cells.
  2. Compute the **origin** (`x0` of cell 0) by back-extrapolating from a known cell:
     `cell0_x0 = known_cell_x0 − index × pitch`.
  3. Validate the derived grid against the total number of boxes visible in a render.
     If your derived count ≠ visible count, STOP and re-measure — an off-by-one origin
     is the single most common cause of "everything shifted one box."
- Place each glyph **optically centered** in its cell (see Phase 2).

### Underlines (write-on-the-line fields)
- Extract horizontal lines/thin-rects; filter by orientation and minimum length.
- The line's `y` is the baseline anchor. Text baseline sits ~1.5–2pt **above** the line.
- Match each underline to its label by proximity (label bottom ≈ line y, label to the left).

### Table columns
- Extract vertical dividers to get exact column x-bounds.
- If dividers are **not vector-extractable** (rasterized/embedded), fall back to
  header-label x-positions to infer column bounds — and treat this as a weaker signal:
  pad more conservatively and scrutinize these columns harder in visual review.

### Checkboxes
- Extract small square rects on the relevant row. List ALL of them left-to-right and
  map each to its option label by x-order. Do not assume the first *detected* box is
  the first *option* — detection may skip the leftmost. Cross-check the count against
  the number of visible options.
- Mark = an "X" (or check glyph) **optically centered** on the box center.

---

## PHASE 2 — PLACEMENT MATH

Let `S` = the chosen single font size. Obtain `ascent`, `descent`, and per-glyph
advance widths from the actual font at size `S` (font metrics, not guesses).

### Baseline
```
baseline_y = target_line_y − descent_gap        # descent_gap ≈ 1.5–2pt above an underline
# For a box: baseline_y = box_bottom − font.descent(S) − small_margin
```

### Optical centering in a cell of width W
```
text_w   = sum(glyph_advance(ch, S) for ch in value)
x_start  = cell.x0 + (W − text_w) / 2
# Optical nudge: leading '1', punctuation, and narrow glyphs create visual imbalance.
# Apply a small optical correction so it LOOKS centered, not just measures centered.
```

### Fit rule (overflow without changing size)
```
avail = W − 2*pad
if text_w > avail:
    h_scale = avail / text_w          # horizontal compression factor (e.g. 0.86)
    apply horizontal text scaling = h_scale   # PDF 'Tz' / equivalent
    # DO NOT reduce S. Glyph height stays constant → uniform apparent size.
```

### Multi-line values (e.g. long address)
- Split on natural boundaries to fit the available width per line at scale 1.0 where
  possible; only scale if a single token forces it.

---

## PHASE 3 — RENDER + MACHINE VERIFY

1. Fill, then rasterize the affected pages at high resolution (≥200 DPI).
2. **Automated checks (must all pass):**
   - Every text run's rendered bbox lies fully within its target cell/line region.
   - No text run overlaps a neighboring field's region.
   - Every grid value occupies exactly the intended cells (first glyph in cell 0, last
     glyph in the last expected cell — catches off-by-one shifts).
   - Every checkbox mark falls within its intended box and no other.
3. If any check fails, re-measure the offending field (usually a grid origin or a
   baseline offset) and repeat. Never "adjust until close" blindly — fix the measured
   input.

---

## PHASE 4 — HUMAN-PERSPECTIVE VISUAL REVIEW (mandatory, not optional)

The machine pass proves each field is correct **in isolation**. This pass judges the
page **as a whole**, the way a person would. Look at the rendered page and ask:

- **Cross-field consistency:** Do entries on the same visual row share a baseline? Do
  column entries align to a common edge? Does any field sit higher/lower/left/right of
  its peers?
- **Optical (not just geometric) centering:** Do centered values *look* centered, given
  glyph side-bearings? Fix values that measure centered but read off.
- **Uniform apparent size:** Does every value look the same size? (A width-scaled value
  should still match in height.)
- **One-document coherence:** Does it look typed by one system, or patched together?
- **Legibility at column edges:** Do tight cells (long IDs in narrow columns) read
  cleanly without touching dividers ambiguously?

Zoom into each dense region (grids, tables, checkbox rows) individually. If anything
looks off to a human eye, return to Phase 2 for that field — even if Phase 3 passed.

---

## PHASE 5 — SEMANTIC CONFIRMATION + DELIVERY

- Present the filled values back to the user in a clear list/table for confirmation —
  especially amounts, totals, dates, yes/no answers, and anything computed or inferred.
  Explicitly flag: computed sums, values with no printed source, and answers whose
  correctness depends on facts only the user knows.
- State clearly what was left blank and **who** must complete it (third party, or the
  user's own signature).
- Deliver the filled PDF.
- Never claim pixel-perfection you didn't verify. If a constraint was physical (e.g. a
  value genuinely too long for a column even at reasonable scaling), say so plainly
  rather than silently overflowing.

---

## FAILURE-MODE CHECKLIST (the errors this procedure exists to prevent)

| Symptom | Root cause | Prevention |
|---|---|---|
| Values shifted one box in a grid | Grid origin off by one (missed first cell) | Back-extrapolate origin from pitch; verify cell count vs. render |
| Text floats above / crashes through line | Baseline computed from box-top, or guessed | Compute baseline from font descent |
| Long value overflows narrow column | Column sized for shorter data | Horizontal width-scaling, not size reduction |
| Value looks off-center though "centered" | Geometric ≠ optical centering | Optical nudge in visual review |
| My text looks bigger than form's labels | Different font at same nominal size | Commit to one overlay font; judge apparent size by eye |
| Doubled text | Re-filling a pre-personalized field | Detect pre-printed values on the original first |
| Checkbox marks wrong option | Assumed first detected box = first option | Enumerate all boxes, map by x-order, verify count |
| Table dividers unreadable | Rasterized, not vector | Fall back to header x-positions; scrutinize harder |
| Neat but wrong data | Alignment ≠ correctness | Phase 5 semantic confirmation with the user |

---

## TOOLING NOTES (implementation-agnostic guidance)

- **Vector extraction / measurement:** a library that exposes lines, rects, and word
  boxes with coordinates (e.g. pdfplumber) — for Phase 1.
- **Font metrics:** a font library exposing ascent/descent and glyph advances
  (e.g. fontTools) — for Phase 2.
- **Placement + text scaling + optional real-field authoring:** a library that can
  insert text with baseline control and horizontal scaling, and — if you ever want to
  convert this into a *reusable* fillable form — add real widget/AcroForm fields once
  (e.g. PyMuPDF, or pdf-lib in JS).
- **Rendering for verification:** any rasterizer at ≥200 DPI — for Phases 3 and 4.

---

## THE ONE-SENTENCE RULE

Measure from the document's own vectors, compute placement from font metrics, fit width
by scaling not resizing, verify by machine **and** by eye comparing fields against each
other, and confirm the data's meaning with the user before delivering.
