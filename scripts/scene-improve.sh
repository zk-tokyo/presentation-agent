#!/usr/bin/env sh
# scene-improve — recursively self-improve a 3D scene (public/scenes/<id>.json)
# with VLM visual feedback. The visually-3d methodology, driven by Claude.
#
# Usage:  sh scripts/scene-improve.sh <id> [max-iterations]
#         (normally invoked by `make scene` / `make scene-improve`)
#
# Each iteration renders the scene to a 2x2 ISO/front/side/top contact-sheet
# PNG (offscreen, no GPU), runs `claude -p` once so the model inspects the
# render visually and returns an improved MachineSceneDescriptor, then
# validates and writes it back. Per-iteration history lands under .refine/.
#
# Env: CLAUDE_BIN (default claude), CLAUDE_MODEL (default opus).

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PROMPT_FILE="$ROOT/prompts/3D_Scene_Self_Improvement.md"
RENDER="$ROOT/scripts/scene-render.mjs"
APPLY="$ROOT/scripts/scene-improve-step.mjs"
CLAUDE_BIN="${CLAUDE_BIN:-claude}"
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}"

die() { echo "scene-improve: $*" >&2; exit 1; }

[ $# -ge 1 ] || die "usage: sh scripts/scene-improve.sh <id> [max-iterations]"
ID="$1"
MAX_ITERS="${2:-4}"
TARGET="$ROOT/public/scenes/$ID.json"
[ -f "$PROMPT_FILE" ] || die "missing prompt: $PROMPT_FILE"
[ -f "$RENDER" ] || die "missing renderer: $RENDER"
[ -f "$APPLY" ] || die "missing helper: $APPLY"
[ -f "$TARGET" ] || die "no scene public/scenes/$ID.json — run 'make scene' first"
command -v "$CLAUDE_BIN" >/dev/null 2>&1 || die "Claude CLI '$CLAUDE_BIN' not on PATH"
command -v node >/dev/null 2>&1 || die "node not on PATH"
case "$MAX_ITERS" in ''|*[!0-9]*) die "max-iterations must be a positive integer" ;; esac

STAMP="$(date +%Y%m%d-%H%M%S)"
RUN_DIR="$ROOT/.refine/scene-$ID-$STAMP"
mkdir -p "$RUN_DIR"
cp "$TARGET" "$RUN_DIR/iter-00.json"
RUN_LOG="$RUN_DIR/run.log"
say() { echo "$@"; echo "$@" >> "$RUN_LOG"; }

say "scene-improve: $TARGET"
say "             history -> $RUN_DIR"
say "             up to $MAX_ITERS iteration(s)"

i=1
while [ "$i" -le "$MAX_ITERS" ]; do
  ii="$(printf '%02d' "$i")"
  say ""
  say "──────── iteration $i / $MAX_ITERS ────────"

  # 1. render the current scene for the visual critique
  RENDER_PNG="$RUN_DIR/iter-$ii-render.png"
  node "$RENDER" "$TARGET" "$RENDER_PNG" >> "$RUN_LOG" 2>&1 \
    || die "renderer failed on iteration $i — see $RUN_LOG"
  say "  rendered -> $(basename "$RENDER_PNG")"

  # 2. build the prompt
  PROMPT_TXT="$RUN_DIR/iter-$ii-prompt.txt"
  {
    cat "$PROMPT_FILE"
    if [ -f "$RUN_DIR/last-review.json" ]; then
      echo; echo "## Carried-over reflection (from the previous iteration)"; echo
      echo "Address these gaps first — the previous pass could not yet close them:"; echo
      echo '```json'; cat "$RUN_DIR/last-review.json"; echo '```'
    fi
    echo; echo "## Current scene to improve"; echo
    echo '```json'; cat "$TARGET"; echo '```'
    echo; echo "## Rendered view — read this file before critiquing"; echo
    echo "The 2x2 ISO/front/side/top contact-sheet render of the current scene is at:"; echo
    echo "    $RENDER_PNG"; echo
    echo "Use the Read tool to open that PNG now and inspect it visually. It is"
    echo "the image this prompt refers to as the attached render."
  } > "$PROMPT_TXT"

  # 3. Claude reads the render and returns an improved descriptor.
  #    Prompt on stdin — it starts with YAML frontmatter the CLI would misparse.
  EVENTS="$RUN_DIR/iter-$ii-events.jsonl"
  MESSAGE="$RUN_DIR/iter-$ii-message.txt"
  CLAUDE_ERR="$RUN_DIR/iter-$ii-claude.err"
  if ! "$CLAUDE_BIN" -p \
        --model "$CLAUDE_MODEL" \
        --output-format stream-json --verbose \
        --dangerously-skip-permissions \
        --tools Read \
        < "$PROMPT_TXT" > "$EVENTS" 2> "$CLAUDE_ERR"; then
    die "Claude CLI failed on iteration $i — see $CLAUDE_ERR and $EVENTS"
  fi
  node -e '
    const fs = require("fs");
    const lines = fs.readFileSync(process.argv[1], "utf8").trim().split("\n");
    let result = "";
    for (const line of lines) {
      try {
        const o = JSON.parse(line);
        if (o.type === "result" && typeof o.result === "string") result = o.result;
      } catch { /* skip */ }
    }
    fs.writeFileSync(process.argv[2], result);
  ' "$EVENTS" "$MESSAGE"
  [ -s "$MESSAGE" ] || die "Claude produced no final message on iteration $i — see $EVENTS"
  say "  claude done (thinking trace: $(basename "$EVENTS"), $(wc -l < "$EVENTS" | tr -d ' ') events)"

  # 4. validate + apply the returned scene; exit code drives the loop
  APPLY_LOG="$RUN_DIR/iter-$ii-apply.log"
  set +e
  node "$APPLY" "$MESSAGE" "$TARGET" "$RUN_DIR" "$ii" > "$APPLY_LOG" 2>&1
  rc=$?
  set -e
  cat "$APPLY_LOG"; cat "$APPLY_LOG" >> "$RUN_LOG"

  case "$rc" in
    0)  ;;
    10) say ""; say "scene-improve: model reports convergence — stopping."; break ;;
    20) say ""; say "scene-improve: no further gain — stopping."; break ;;
    *)  die "could not apply iteration $i (see $MESSAGE and $EVENTS)" ;;
  esac

  i=$((i + 1))
done

say ""
say "scene-improve: done. Improved scene: public/scenes/$ID.json"
say "             history: $RUN_DIR"
say "             revert:  cp $RUN_DIR/iter-00.json $TARGET"
