#!/usr/bin/env sh
# refine — recursive self-improvement loop for a Slidev deck, with VLM visual
# feedback. The visually-3d 3D-model methodology applied to slides.
#
# Usage:  make refine [REFINE_ITERS=N]      (or: sh scripts/refine.sh [max-iters])
#
# Each iteration:
#   1. exports the current deck to per-slide PNGs (slidev export, offscreen);
#   2. runs `claude -p` with those PNGs — the model opens every slide image
#      with the Read tool, scores the 8-axis executive rubric, and makes
#      surgical Edits to slides/SL*.md;
#   3. re-exports to confirm the deck still renders (regression guard);
#   4. repeats until the rubric converges, plateaus, or max-iterations (5).
#
# Every iteration's prompt, slide PNGs, JSONL thinking trace, model output and
# a before-snapshot of the deck is kept under .refine/<timestamp>/ — git-ignored,
# accumulates locally.
#
# Env: CLAUDE_BIN (default claude), CLAUDE_MODEL (default opus),
#      CHROME_PATH (browser for slidev export; auto-detected if unset).

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PROMPT_FILE="$ROOT/prompts/11_Visual_Self_Improvement.md"
STEP="$ROOT/scripts/refine-step.mjs"
DECK="slides.md"
SLIDES_DIR="slides"
MAX_ITERS="${1:-5}"
CLAUDE_BIN="${CLAUDE_BIN:-claude}"
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}"

die() { echo "refine: $*" >&2; exit 1; }

[ -f "$PROMPT_FILE" ] || die "missing prompt: $PROMPT_FILE"
[ -f "$STEP" ] || die "missing helper: $STEP"
[ -f "$DECK" ] || die "no $DECK — run 'make all' first to generate the deck"
[ -d "$SLIDES_DIR" ] && [ -n "$(ls -A "$SLIDES_DIR" 2>/dev/null)" ] \
  || die "$SLIDES_DIR/ is empty — run 'make all' first"
command -v "$CLAUDE_BIN" >/dev/null 2>&1 || die "Claude CLI '$CLAUDE_BIN' not on PATH"
command -v node >/dev/null 2>&1 || die "node not on PATH"
case "$MAX_ITERS" in ''|*[!0-9]*) die "max-iterations must be a positive integer" ;; esac

# slidev runner + browser for PNG export
if command -v bunx >/dev/null 2>&1; then SLIDEV="bunx slidev"
elif command -v npx >/dev/null 2>&1; then SLIDEV="npx slidev"
else die "need bunx or npx for slidev export"; fi
CHROME="${CHROME_PATH:-}"
[ -z "$CHROME" ] && CHROME="$(command -v google-chrome-stable || command -v google-chrome \
  || command -v chromium || command -v chromium-browser || true)"

STAMP="$(date +%Y%m%d-%H%M%S)"
RUN_DIR="$ROOT/.refine/refine-$STAMP"
mkdir -p "$RUN_DIR"
RUN_LOG="$RUN_DIR/run.log"
LAST_GOOD="$RUN_DIR/last-good"

say() { echo "$@"; echo "$@" >> "$RUN_LOG"; }

# snapshot / restore the deck (slides.md + slides/)
snapshot() {
  rm -rf "$1"; mkdir -p "$1/$SLIDES_DIR"
  cp "$DECK" "$1/$DECK"
  cp -r "$SLIDES_DIR/." "$1/$SLIDES_DIR/"
}
restore() {
  cp "$1/$DECK" "$DECK"
  rm -rf "$SLIDES_DIR"; mkdir -p "$SLIDES_DIR"
  cp -r "$1/$SLIDES_DIR/." "$SLIDES_DIR/"
}

# export the current deck to a directory of per-slide PNGs
export_png() {
  if [ -n "$CHROME" ]; then
    $SLIDEV export "$DECK" --format png --output "$1" --executable-path "$CHROME" > "$2" 2>&1
  else
    $SLIDEV export "$DECK" --format png --output "$1" > "$2" 2>&1
  fi
}

# `slidev export` needs the playwright-chromium package. It is deliberately
# NOT a package.json dependency — its Chromium download breaks the Cloudflare
# build — so install it locally on demand, without touching package.json.
ensure_playwright() {
  node -e 'require.resolve("playwright-chromium")' >/dev/null 2>&1 && return 0
  command -v npm >/dev/null 2>&1 || die "playwright-chromium missing and npm not on PATH to install it"
  say "  installing playwright-chromium locally (one-time; not saved to package.json)…"
  _skip=0; [ -n "$CHROME" ] && _skip=1
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=$_skip \
    npm install --no-save --no-audit --no-fund playwright-chromium >/dev/null 2>&1 \
    || die "could not install playwright-chromium — run: npm install --no-save playwright-chromium"
}

say "refine: $DECK ($(ls "$SLIDES_DIR" | wc -l | tr -d ' ') slide files)"
say "        history -> $RUN_DIR"
say "        driver  -> $CLAUDE_BIN / $CLAUDE_MODEL ; browser -> ${CHROME:-playwright-bundled}"
say "        up to $MAX_ITERS iteration(s)"

ensure_playwright

snapshot "$RUN_DIR/iter-00-deck"

i=1
while [ "$i" -le "$MAX_ITERS" ]; do
  ii="$(printf '%02d' "$i")"
  say ""
  say "──────── iteration $i / $MAX_ITERS ────────"

  # 1. render the current deck to per-slide PNGs
  PNG_DIR="$RUN_DIR/iter-$ii-png"
  if ! export_png "$PNG_DIR" "$RUN_DIR/iter-$ii-export.log"; then
    if [ "$i" -eq 1 ]; then
      die "deck does not export — fix slides.md / slides/ first (see $RUN_DIR/iter-$ii-export.log)"
    fi
    say "refine: deck no longer exports — restoring the last good version and stopping."
    restore "$LAST_GOOD"
    break
  fi
  # current deck renders cleanly: it becomes the safety net
  snapshot "$LAST_GOOD"
  say "  rendered $(ls "$PNG_DIR" 2>/dev/null | grep -c '\.png$') slide PNG(s) -> $(basename "$PNG_DIR")"

  # 2. build the prompt
  PROMPT_TXT="$RUN_DIR/iter-$ii-prompt.txt"
  {
    cat "$PROMPT_FILE"
    if [ -f "$RUN_DIR/last-review.json" ]; then
      echo; echo "## Carried-over reflection (from the previous iteration)"; echo
      echo "Close these gaps first — the previous pass could not yet:"; echo
      echo '```json'; cat "$RUN_DIR/last-review.json"; echo '```'
    fi
    echo; echo "## Rendered slides"; echo
    echo "The current deck has been exported to per-slide PNGs in:"; echo
    echo "    $PNG_DIR"; echo
    echo "Read every PNG in that directory (1.png, 2.png, …) before you critique."
    echo; echo "## Deck files to edit"; echo
    echo "Root file : $ROOT/$DECK"
    echo "Slide files: $ROOT/$SLIDES_DIR/ — edit the SL*.md files in place with Edit."
  } > "$PROMPT_TXT"

  # 3. Claude reads the PNGs, edits slides/, emits the JSON review.
  #    The prompt is fed on stdin — it begins with YAML frontmatter ("---"),
  #    which the CLI would otherwise mistake for an option.
  EVENTS="$RUN_DIR/iter-$ii-events.jsonl"
  CLAUDE_ERR="$RUN_DIR/iter-$ii-claude.err"
  if ! "$CLAUDE_BIN" -p \
        --model "$CLAUDE_MODEL" \
        --output-format stream-json --verbose \
        --dangerously-skip-permissions \
        --tools Read Edit Write Grep Glob \
        < "$PROMPT_TXT" > "$EVENTS" 2> "$CLAUDE_ERR"; then
    die "Claude CLI failed on iteration $i — see $CLAUDE_ERR and $EVENTS"
  fi
  say "  claude done (thinking trace: $(basename "$EVENTS"), $(wc -l < "$EVENTS" | tr -d ' ') events)"

  # 4. parse the review; exit code drives the loop
  STEP_LOG="$RUN_DIR/iter-$ii-step.log"
  set +e
  node "$STEP" "$EVENTS" "$RUN_DIR" "$ii" > "$STEP_LOG" 2>&1
  rc=$?
  set -e
  cat "$STEP_LOG"; cat "$STEP_LOG" >> "$RUN_LOG"

  case "$rc" in
    0)  ;;
    10) say ""; say "refine: model reports convergence — stopping."; break ;;
    20) say ""; say "refine: rubric average stopped rising — stopping."; break ;;
    *)  die "could not parse iteration $i (see $EVENTS and $CLAUDE_ERR)" ;;
  esac

  i=$((i + 1))
done

# final guard: confirm the refined deck still exports
if ! export_png "$RUN_DIR/final-png" "$RUN_DIR/final-export.log"; then
  say "refine: final deck does not export — restoring the last good version."
  restore "$LAST_GOOD"
fi

say ""
say "refine: done. Deck refined in place: $DECK + $SLIDES_DIR/"
say "        full history: $RUN_DIR"
say "        review change: git diff -- $DECK $SLIDES_DIR/"
say "        revert:        cp -r $RUN_DIR/iter-00-deck/. ./"
