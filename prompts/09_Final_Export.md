
---
Description: Applies the executive review's required revisions to the slide content + visual design, then writes the actual Slidev `.md` files into `slides/` and a top-level `slides.md` that wires them together. Primary side effect is filesystem writes; the JSON summary is a manifest.
Usage: `/09_Final_Export EXECUTIVE_REVIEW=<path> VISUAL_DESIGN=<path> SLIDE_CONTENT=<path>`
Example: `/09_Final_Export EXECUTIVE_REVIEW="outputs/08_Executive_Review.json" VISUAL_DESIGN="outputs/07_Visual_Design.json" SLIDE_CONTENT="outputs/06_Slide_Content.json"`
Language: Visible slide text in the deck's `output_language`; JSON manifest in English.
Execution hint: "Trust, but verify." Apply revisions first. Write files. Then verify the writes happened by listing them. Never report success without verification.
---

# 09_Final_Export

## Your Role
You are the final assembler. You merge approved content with approved visual choices, apply the gatekeeper's revisions, and produce the actual Slidev files. Your work must be flawless.

## Tools You Use
- **`Read`** in parallel: `{{EXECUTIVE_REVIEW}}`, `{{VISUAL_DESIGN}}`, `{{SLIDE_CONTENT}}`.
- **`Write`**:
  - One file per slide → `slides/SL{NN}.md` (zero-padded two-digit numbering, e.g. `slides/SL01.md`).
  - One root file → `slides.md` that imports each slide in order via Slidev's `src:` frontmatter.
  - The manifest → `outputs/09_Final_Export.json`.
- **`Bash`** (verification only): `ls slides/` after writing to confirm files exist on disk. Do not run the dev server here — that's step 10's job.

## Slidev File Conventions

### Per-slide file (`slides/SL{NN}.md`)

```markdown
---
layout: (from VISUAL_DESIGN.slidev_layout — default if absent)
---

# (Action Title from SLIDE_CONTENT)

(Optional eyebrow / subtitle as a small div, if present)

(Visual body — pick ONE based on the visual_strategy:
 - Single number / word
 - Image markdown
 - Mermaid code block (```mermaid ... ```)
 - Slidev layout content (two-cols ::left:: / ::right::)
 - 3–5 key points with <v-clicks>
 - Plain bullets (last resort)
)

(IMAGE_PLACEHOLDER comments from VISUAL_DESIGN, if any)

<!--
Speaker Notes:
(Full speaker_notes paragraph from SLIDE_CONTENT.)
-->
```

### Root file (`slides.md`)

```markdown
---
theme: (theme name; default 'default' unless brand calls for another)
title: (Title from CONTEXT_BRIEF.content_analysis.title)
info: |
  (Title)
  (Optional one-line description)
transition: slide-left
mdc: true
colorSchema: 'light'
src: ./slides/SL01.md
---
---
src: ./slides/SL02.md
---
... (one block per slide, in order)
```

Notice the root frontmatter applies only to slide 01; subsequent `src:` blocks are minimal.

## Apply Revisions First (in this order)

1. **Title revisions** — shorten any title flagged in `required_revisions` to keep one-line layout.
2. **Content revisions** — adjust key points and speaker notes per recommendations.
3. **Visual revisions** — swap layouts, replace decorative visuals, fix Mermaid overflow.
4. **Source fidelity fixes** — restore any anecdote or quote the review flagged as lost.
5. **Bookend fix** — ensure the close echoes the hook.

If a revision targets a slide that no longer exists after merging, log it under `manifest.skipped_revisions` with the reason.

## Process
1. Read all three JSONs in parallel.
2. Build an internal merged data structure: per-slide content + visual design + revisions applied.
3. For each slide, render the Slidev markdown string per the convention above.
4. **`Write`** each slide file under `slides/SL{NN}.md`.
5. **`Write`** the root `slides.md` wiring file.
6. **`Bash`** `ls slides/ | sort` to verify files exist.
7. **`Write`** the manifest JSON to `outputs/09_Final_Export.json`.

## Anti-Patterns to Avoid
- **Skipping File Writes** — describing slides in JSON without actually creating the `.md` files.
- **Ignoring Revisions** — exporting the pre-review draft.
- **Wrong Frontmatter** — missing the top-level `theme:` block or duplicating it on every slide.
- **Inconsistent Numbering** — gaps (`SL01.md`, `SL03.md`) confuse downstream tooling.
- **Reporting Success Without Verification** — never claim files written without an `ls` confirmation.

## Output Format

`Write` to `outputs/09_Final_Export.json`:

```json
{
  "export_summary": {
    "total_slides_created": 0,
    "revisions_applied": 0,
    "skipped_revisions": 0
  },
  "files_created": [
    "slides.md",
    "slides/SL01.md"
  ],
  "verification": {
    "ls_output_lines": 0,
    "all_slides_on_disk": true,
    "justification": "(Result of ls slides/.)"
  },
  "skipped_revisions": [
    { "slide_number": 0, "reason": "..." }
  ],
  "next_step_hint": "Run /10_Recursive_Self_Improvement to build, visual-check, and iterate until the rubric clears 4.5 on every axis."
}
```

## Quality Checklist
- [ ] All `required_revisions` from the review either applied or logged in `skipped_revisions`.
- [ ] Each slide written as `slides/SL{NN}.md` with 2-digit zero-padded numbering.
- [ ] Root `slides.md` lists every slide in order.
- [ ] `Bash ls slides/` confirms every expected file is present.
- [ ] Manifest JSON written via `Write` to `outputs/09_Final_Export.json`.
