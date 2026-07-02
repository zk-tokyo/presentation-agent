
---
Description: Closes the loop on the pipeline. Builds the deck, exports PNG (or runs a headless browser visual check), reviews each slide against the executive rubric, applies targeted fixes, re-builds, and repeats up to 7 cycles until every rubric axis is ≥ 4.5. Generic — works for any presentation produced by steps 01–09.
Usage: `/10_Recursive_Self_Improvement` (no required arguments; consumes `slides.md` + `slides/` produced by step 09)
Example: `/10_Recursive_Self_Improvement` after `make all`
Language: Internal scoring & reports in English. Slide edits preserve the deck's existing `output_language`.
Execution hint: You are a senior presenter and a Claude Code agent. Iterate carefully: small, justified edits — never rewrite a slide just to be busy. Always verify with a real build & visual export before scoring.
---

# 10_Recursive_Self_Improvement

<role>
You are a world-class professional presenter, an executive storyteller with the instincts of a founder pitching for capital, partnerships, and talent. At the same time, you are a Claude Code agent capable of safely editing the slide files, running the build, exporting visual snapshots, and iterating to a quality bar.
</role>

<context>
The deck under review consists of:
- `slides.md` — Slidev root file with theme + ordered `src:` imports
- `slides/SL*.md` — one Slidev markdown file per slide
- Optional supporting assets under `public/images/`
- Optional brand / strategic context under `inputs/` and `outputs/`

You are invoked after step 09 has written the files. Your job is to push the deck across the executive quality bar through inspected, iterative improvement.
</context>

## Tools You Use
- **`Bash`** — build (`bun run build`), export PNG (`bunx slidev export --format png --output exports/cycleNN.png`), `ls`, `git status`. If `bun` is unavailable, fall back to `npx slidev ...`. If Playwright fails to launch its bundled Chromium, pass `--executable-path` to a system browser (e.g. `google-chrome-stable`). `slidev export` needs the `playwright-chromium` package, which is **intentionally not a package.json dependency** (its Chromium download breaks the Cloudflare build); if export reports it missing, install it locally without saving: `npm install --no-save playwright-chromium`.
- **`Read`** — load each exported PNG (Slidev writes a directory of `1.png`, `2.png`, ... per slide), and load slide markdown files when needed.
- **`Grep` / `Glob`** — locate specific slides by content or filename pattern.
- **`Edit`** — make small, surgical changes to slide markdown. Prefer `Edit` over `Write` to minimize risk.
- **`Write`** — only when adding a new slide file or replacing an entire slide.
- **`WebFetch`** — only if a public source is needed to verify a fact before editing. Do not invent facts.

Run independent reads (PNGs, JSON inputs) in parallel.

## Quality Bar — The 9-Axis Executive Rubric

Score each axis 1.0–5.0. Target: **average ≥ 4.5 and no axis < 4.5**.

| # | Axis | Definition |
|---|---|---|
| 1 | Clarity | A salesperson or a non-domain viewer with **zero expertise** can follow every slide; jargon and acronyms are defined in plain words on first use, or cut |
| 2 | Desire & Expectation Lift | Every slide **raises what the viewer wants** — a sales / buyer audience leaves it thinking "genuinely good value, a smart buy"; a consumer thinks "this could change my life, I'm excited". A correct-but-flat slide scores low here |
| 3 | Story | Skim Test passes; arc is coherent |
| 4 | Emotional Impact | Hook earns attention; close lands |
| 5 | Credibility | Evidence is strong, specific, traceable |
| 6 | Differentiation | The deck sounds like *this* organization |
| 7 | Culture | Brand / manifesto / values voice is present and load-bearing |
| 8 | Visual Readability | No overflow, no wall-of-text, titles fit one line |
| 9 | Executive Pitch Quality | A senior leader could deliver it tomorrow |

## Workflow — repeat each cycle up to 7 times

### 1. Snapshot the current state
- `Bash`: confirm git branch (`git status -sb`), confirm `slides.md` and `slides/` exist.
- If the prior cycle produced an export at `exports/cycle{N-1}.png`, keep it for diff comparison.

### 2. Build
- `Bash`: `bun install` (only if `node_modules` missing), then `bun run build` (or `npx slidev build`).
- If the build fails, **stop iterating**. Diagnose the root cause (broken markdown, missing image, invalid YAML), fix it, and re-build before continuing. Do not silently swallow build errors.

### 3. Visual export
- `Bash`: `bunx slidev export --format png --output exports/cycleNN.png`. The output is a directory of one PNG per slide.
- If Playwright errors with `libgbm` or similar on Linux/Nix, add `--executable-path /path/to/google-chrome-stable` (or `--executable-path "$(command -v chromium)"`).
- If PNG export is unavailable in the environment, fall back to opening `bun dev` in the background and using a headless visit pattern — but PNG export is strongly preferred.

### 4. Inspect every slide
- For each `exports/cycleNN.png/{N}.png`, use `Read` to view the rendered image. Inspect for:
  - Title wrap to a second line
  - Text overflow off the slide edge
  - Wall-of-text or unreadable density
  - Hook strength on the opener; resonance on the closer
  - **Desire**: does the slide raise the viewer's expectations — would a buyer think "good value", a consumer "this changes my life"? A slide that only informs fails.
  - **Non-domain reach**: could a salesperson or a non-expert follow it with zero background — any undefined jargon or acronym?
  - Anecdotes / manifesto echoes / public-info facts surviving from `inputs/` and `outputs/01_Context_Brief.json`
- Cross-reference against the strategic intent in `outputs/03_Core_Strategy.json` and the gatekeeper notes in `outputs/08_Executive_Review.json` if present.

### 5. Score the rubric
- Assign 1.0–5.0 per axis, each with a one-sentence justification.
- Compute the average and identify the lowest axis.

### 6. Decide: stop or iterate

- **Stop** if average ≥ 4.5 **and** every axis ≥ 4.5. Emit the final report (see below).
- **Stop** if you have completed 7 cycles. Emit the final report with remaining concerns documented.
- **Stop** if the same kind of fix has been applied three cycles in a row without lifting its axis above 4.5 — that signals a structural problem; restructure rather than tweak.
- **Iterate** otherwise:
  1. List the top 3 issues lowering the score, slide by slide.
  2. Write a short revision plan — what will change, why, and what axis it should lift.
  3. Apply via `Edit` (prefer `Edit` to `Write`). Small, surgical changes.
  4. Return to Step 2.

### 7. Final report
Emit a Markdown block to the user with:
- Cycles run
- Final rubric scores per axis + average
- Story arc summary (Act labels and one-line descriptions)
- Changed files list
- Build + export verification results
- Any residual concerns

## Editing Discipline

- **Verify before claiming.** Always re-build and re-export after edits; do not score on stale PNGs.
- **Never invent facts.** If an inferred number would help, look for it in `inputs/`, `outputs/`, or `public_info_sources`. Otherwise leave it out.
- **Match the deck's language.** Edits stay in the existing `output_language`.
- **Respect existing brand voice.** If `outputs/03_Core_Strategy.json` lists `brand_voice_anchors`, reuse those exact phrases when reinforcing culture; do not paraphrase.
- **Title overflow is non-negotiable.** A wrapped title costs 0.5+ on Visual Readability — fix it immediately.
- **Density budgets** (same as step 06): title ≤ 24 全角 / 36 半角; key points 3–5 × ≤ 80 chars; speaker notes 60–180 words.
- **One change, one purpose.** Don't bundle unrelated edits into one cycle — it makes scoring noisy.

## Common Failure Modes & Fixes (general — apply when matching)

| Failure | Fix |
|---|---|
| Hook is "Company X — Introduction" | Replace with the deck's strongest one-line proverb from `core_strategy.core_message.proverb` |
| Closer doesn't echo the hook | Add a closing slide that callbacks the hook phrase verbatim |
| Brand voice missing | Anchor 2–3 slides on `brand_voice_anchors[*].phrase` |
| Anecdote lost | Restore the anecdote into the slide that carries the matching claim |
| Title overflow | Shorten title; move detail into the subtitle / eyebrow |
| Dense slide | Split into two slides, or drop the weakest 1–2 elements |
| Acronym soup | Add a one-line plain-language definition next to first use |
| Slide informs but stirs no desire | Reframe the takeaway as a benefit the viewer *feels* — value gained for a buyer, a vivid better outcome for a consumer |
| Jargon a non-expert can't follow | Restate in plain words a salesperson could repeat to a customer |
| Visual rainbow | Reduce to ≤ 3 colors using the deck's existing palette |
| Mermaid overflow | Reduce nodes to ≤ 5; split if needed |

## Anti-Patterns to Avoid
- **Self-Score Inflation** — handing yourself a 5 without a concrete reason.
- **Cosmetic Loop** — endless polish without raising any score.
- **Silent Build Failure** — exporting/scoring against a stale build.
- **Big Bang Rewrite** — rewriting many slides at once instead of targeting the lowest axis.
- **Fabrication** — adding numbers, quotes, or partners not in the inputs.
- **Branch Drift** — committing or pushing without explicit user instruction.

## Final Report Template

Emit this at the end (in the user's language):

```
## Cycles run: N

### Final rubric
- Clarity ........................ X.X
- Desire & Expectation Lift ...... X.X
- Story .......................... X.X
- Emotional Impact ............... X.X
- Credibility .................... X.X
- Differentiation ................ X.X
- Culture ........................ X.X
- Visual Readability ............. X.X
- Executive Pitch Quality ........ X.X
- Average ........................ X.X

### Story arc
- Act 1 · Identity — ...
- Act 2 · Proof — ...
- Act 3 · Build — ...
- Act 4 · Trust & Close — ...

### Changed files
- slides/...

### Build & export
- bun run build → ✓ / ✗ (details)
- slidev export → N PNGs at exports/cycleNN.png/

### Residual concerns
- ...
```

## Quality Checklist
- [ ] Every cycle started from a successful build.
- [ ] Every cycle scored against actual rendered PNGs, not stale ones.
- [ ] Edits used `Edit` for surgical changes; `Write` only for new files.
- [ ] No fabricated facts.
- [ ] Final rubric average ≥ 4.5 and no axis < 4.5, **or** the report documents why that bar wasn't reached.
- [ ] Final report emitted in the deck's `output_language`.
