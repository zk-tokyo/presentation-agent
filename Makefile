# ==============================================================================
# Presentation Agent - Ideal Pipeline Makefile
# ==============================================================================
# This Makefile orchestrates the 9-step presentation generation pipeline.
#
# Usage:
#   1. Edit inputs/introduction.md with YAML frontmatter containing:
#      - target_audience: Target audience description
#      - audience_type: individual / group / mixed
#      - constraints: { max_slides: N, max_duration_minutes: M }
#      - output_language: Japanese / English
#      - event: (optional) Event context
#   2. Run `make validate` to verify the input format.
#   3. Run `make all` to execute the entire pipeline.
#
# The final Slidev Markdown files will be generated in the `slides/` directory.
# ==============================================================================

# --- Configuration ---
PROMPTS_DIR ?= prompts
OUTPUT_DIR ?= outputs
LOG_DIR ?= $(OUTPUT_DIR)/logs
SLIDES_DIR ?= slides

# --- User Input (Single Source of Truth) ---
# All metadata is now in the YAML frontmatter of introduction.md
RAW_INPUT ?= inputs/introduction.md

# --- Visual Style (Not part of the content, so kept as Makefile variables) ---
SLIDEV_THEME ?= default
FONT ?= BIZ UDPMincho
BACKGROUND_COLOR ?= \#FFFFFF

# Tone for the presentation (derived from Core Strategy, can be overridden)
TONE ?= Respectfully ambitious and intellectually rigorous.

# --- Output Files ---
CONTEXT_OUT := $(OUTPUT_DIR)/01_Context_Brief.json
PERSONA_OUT := $(OUTPUT_DIR)/02_Audience_Persona.json
STRATEGY_OUT := $(OUTPUT_DIR)/03_Core_Strategy.json
ARGUMENT_OUT := $(OUTPUT_DIR)/04_Governing_Argument.json
BLUEPRINT_OUT := $(OUTPUT_DIR)/05_Narrative_Blueprint.json
DRAFTS_OUT := $(OUTPUT_DIR)/06_Slide_Content.json
VISUALS_OUT := $(OUTPUT_DIR)/07_Visual_Design.json
REVIEW_OUT := $(OUTPUT_DIR)/08_Executive_Review.json
EXPORT_OUT := $(OUTPUT_DIR)/09_Final_Export.json

# --- Claude Configuration ---
export CLAUDE_CODE_PERMISSIONS := bypassPermissions
export CLAUDE_CODE_MAX_OUTPUT_TOKENS := 100000
CLAUDE_FLAGS ?= --dangerously-skip-permissions --output-format json

# --- Phony Targets ---
.PHONY: all init clean help validate \
        context_analysis audience_persona core_strategy \
        governing_argument narrative_blueprint \
        slide_drafting visual_design \
        executive_review final_export

# ==============================================================================
# Main Targets
# ==============================================================================

all: final_export
	@echo "============================================"
	@echo "Pipeline complete!"
	@echo "Final manifest: $(EXPORT_OUT)"
	@echo "Slides directory: $(SLIDES_DIR)/"
	@echo "============================================"

help:
	@echo "============================================================================"
	@echo "Presentation Agent - Ideal Pipeline"
	@echo "============================================================================"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Main Targets:"
	@echo "  all            - Run the entire 9-step pipeline from start to finish."
	@echo "  validate       - Validate that inputs/introduction.md has required frontmatter."
	@echo "  clean          - Remove all generated outputs."
	@echo ""
	@echo "Pipeline Phases and Steps:"
	@echo ""
	@echo "  Phase 1: Foundation (Strategy & Understanding)"
	@echo "    1. context_analysis   - Parse raw input into a structured brief."
	@echo "    2. audience_persona   - Build a detailed persona of the target audience."
	@echo "    3. core_strategy      - Define the presentation's purpose and narrative."
	@echo ""
	@echo "  Phase 2: Architecture (Structure & Argument)"
	@echo "    4. governing_argument - Construct the logical backbone (Pyramid Principle)."
	@echo "    5. narrative_blueprint- Design the slide-by-slide outline with Action Titles."
	@echo ""
	@echo "  Phase 3: Content (Drafting & Visuals)"
	@echo "    6. slide_drafting     - Write bullet points and speaker notes."
	@echo "    7. visual_design      - Design charts, diagrams, and tables."
	@echo ""
	@echo "  Phase 4: Polish & Export (Review & Output)"
	@echo "    8. executive_review   - Conduct a final 'murder board' review."
	@echo "    9. final_export       - Apply revisions and export to Slidev Markdown."
	@echo ""
	@echo "Configuration:"
	@echo "  All presentation metadata is configured in inputs/introduction.md frontmatter:"
	@echo ""
	@echo "  ---"
	@echo "  target_audience: \"SCIS2026参加者（研究者コミュニティ）\""
	@echo "  audience_type: group"
	@echo "  constraints:"
	@echo "    max_slides: 15"
	@echo "    max_duration_minutes: 15"
	@echo "  output_language: Japanese"
	@echo "  event:"
	@echo "    name: \"DEPCON Hakodate\""
	@echo "  ---"
	@echo ""
	@echo "  Visual style variables (Makefile):"
	@echo "  SLIDEV_THEME    - Slidev theme (default: 'default')"
	@echo "  FONT            - Font family (default: 'Inter')"
	@echo "  BACKGROUND_COLOR- Background color (default: '#FFFFFF')"
	@echo "============================================================================"

init:
	@mkdir -p $(OUTPUT_DIR) $(LOG_DIR) $(SLIDES_DIR)

clean:
	@rm -rf $(OUTPUT_DIR) $(SLIDES_DIR)
	@echo "Cleaned output directories."

# ==============================================================================
# Validation
# ==============================================================================

validate:
	@echo "Validating $(RAW_INPUT)..."
	@if [ ! -f "$(RAW_INPUT)" ]; then \
		echo "ERROR: $(RAW_INPUT) not found"; \
		exit 1; \
	fi
	@if ! grep -q "^target_audience:" "$(RAW_INPUT)"; then \
		echo "ERROR: $(RAW_INPUT) must contain 'target_audience:' in frontmatter"; \
		exit 1; \
	fi
	@if ! grep -q "^audience_type:" "$(RAW_INPUT)"; then \
		echo "ERROR: $(RAW_INPUT) must contain 'audience_type:' in frontmatter"; \
		exit 1; \
	fi
	@if ! grep -q "^constraints:" "$(RAW_INPUT)"; then \
		echo "ERROR: $(RAW_INPUT) must contain 'constraints:' in frontmatter"; \
		exit 1; \
	fi
	@if ! grep -q "^output_language:" "$(RAW_INPUT)"; then \
		echo "ERROR: $(RAW_INPUT) must contain 'output_language:' in frontmatter"; \
		exit 1; \
	fi
	@echo "Validation passed: $(RAW_INPUT) has required frontmatter fields."

# ==============================================================================
# Phase 1: Foundation
# ==============================================================================

context_analysis: $(CONTEXT_OUT)
$(CONTEXT_OUT): $(PROMPTS_DIR)/01_Context_Analysis.md $(RAW_INPUT) | init
	@echo "[Step 1/9] Context Analysis..."
	@prompt="$$(sed -e 's|{{RAW_INPUT}}|$(RAW_INPUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/01_Context_Analysis.json
	@if [ -f "$(CONTEXT_OUT)" ]; then echo "[Step 1/9] Complete."; else echo "[Step 1/9] Warning: $(CONTEXT_OUT) not found."; fi

audience_persona: $(PERSONA_OUT)
$(PERSONA_OUT): $(PROMPTS_DIR)/02_Audience_Persona.md $(CONTEXT_OUT) | init
	@echo "[Step 2/9] Audience Persona..."
	@prompt="$$(sed -e 's|{{CONTEXT_BRIEF}}|$(CONTEXT_OUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/02_Audience_Persona.json
	@if [ -f "$(PERSONA_OUT)" ]; then echo "[Step 2/9] Complete."; else echo "[Step 2/9] Warning: $(PERSONA_OUT) not found."; fi

core_strategy: $(STRATEGY_OUT)
$(STRATEGY_OUT): $(PROMPTS_DIR)/03_Core_Strategy.md $(CONTEXT_OUT) $(PERSONA_OUT) | init
	@echo "[Step 3/9] Core Strategy..."
	@prompt="$$(sed -e 's|{{CONTEXT_BRIEF}}|$(CONTEXT_OUT)|g' -e 's|{{AUDIENCE_PERSONA}}|$(PERSONA_OUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/03_Core_Strategy.json
	@if [ -f "$(STRATEGY_OUT)" ]; then echo "[Step 3/9] Complete."; else echo "[Step 3/9] Warning: $(STRATEGY_OUT) not found."; fi

# ==============================================================================
# Phase 2: Architecture
# ==============================================================================

governing_argument: $(ARGUMENT_OUT)
$(ARGUMENT_OUT): $(PROMPTS_DIR)/04_Governing_Argument.md $(STRATEGY_OUT) $(PERSONA_OUT) | init
	@echo "[Step 4/9] Governing Argument..."
	@prompt="$$(sed -e 's|{{CORE_STRATEGY}}|$(STRATEGY_OUT)|g' -e 's|{{AUDIENCE_PERSONA}}|$(PERSONA_OUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/04_Governing_Argument.json
	@if [ -f "$(ARGUMENT_OUT)" ]; then echo "[Step 4/9] Complete."; else echo "[Step 4/9] Warning: $(ARGUMENT_OUT) not found."; fi

narrative_blueprint: $(BLUEPRINT_OUT)
$(BLUEPRINT_OUT): $(PROMPTS_DIR)/05_Narrative_Blueprint.md $(ARGUMENT_OUT) $(STRATEGY_OUT) $(CONTEXT_OUT) | init
	@echo "[Step 5/9] Narrative Blueprint..."
	@prompt="$$(sed -e 's|{{GOVERNING_ARGUMENT}}|$(ARGUMENT_OUT)|g' -e 's|{{CORE_STRATEGY}}|$(STRATEGY_OUT)|g' -e 's|{{CONTEXT_BRIEF}}|$(CONTEXT_OUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/05_Narrative_Blueprint.json
	@if [ -f "$(BLUEPRINT_OUT)" ]; then echo "[Step 5/9] Complete."; else echo "[Step 5/9] Warning: $(BLUEPRINT_OUT) not found."; fi

# ==============================================================================
# Phase 3: Content
# ==============================================================================

slide_drafting: $(DRAFTS_OUT)
$(DRAFTS_OUT): $(PROMPTS_DIR)/06_Slide_Drafting.md $(BLUEPRINT_OUT) $(CONTEXT_OUT) | init
	@echo "[Step 6/9] Slide Drafting..."
	@prompt="$$(sed -e 's|{{NARRATIVE_BLUEPRINT}}|$(BLUEPRINT_OUT)|g' -e 's|{{CONTEXT_BRIEF}}|$(CONTEXT_OUT)|g' -e 's|{{TONE}}|$(TONE)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/06_Slide_Drafting.json
	@if [ -f "$(DRAFTS_OUT)" ]; then echo "[Step 6/9] Complete."; else echo "[Step 6/9] Warning: $(DRAFTS_OUT) not found."; fi

visual_design: $(VISUALS_OUT)
$(VISUALS_OUT): $(PROMPTS_DIR)/07_Visual_Design.md $(DRAFTS_OUT) | init
	@echo "[Step 7/9] Visual Design..."
	@prompt="$$(sed -e 's|{{SLIDE_DRAFTS}}|$(DRAFTS_OUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/07_Visual_Design.json
	@if [ -f "$(VISUALS_OUT)" ]; then echo "[Step 7/9] Complete."; else echo "[Step 7/9] Warning: $(VISUALS_OUT) not found."; fi

# ==============================================================================
# Phase 4: Polish & Export
# ==============================================================================

executive_review: $(REVIEW_OUT)
$(REVIEW_OUT): $(PROMPTS_DIR)/08_Executive_Review.md $(DRAFTS_OUT) $(VISUALS_OUT) $(PERSONA_OUT) $(STRATEGY_OUT) | init
	@echo "[Step 8/9] Executive Review..."
	@prompt="$$(sed -e 's|{{SLIDE_DRAFTS}}|$(DRAFTS_OUT)|g' -e 's|{{VISUAL_DESIGNS}}|$(VISUALS_OUT)|g' -e 's|{{AUDIENCE_PERSONA}}|$(PERSONA_OUT)|g' -e 's|{{CORE_STRATEGY}}|$(STRATEGY_OUT)|g' $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/08_Executive_Review.json
	@if [ -f "$(REVIEW_OUT)" ]; then echo "[Step 8/9] Complete."; else echo "[Step 8/9] Warning: $(REVIEW_OUT) not found."; fi

final_export: $(EXPORT_OUT)
$(EXPORT_OUT): $(PROMPTS_DIR)/09_Final_Export.md $(DRAFTS_OUT) $(VISUALS_OUT) $(REVIEW_OUT) | init
	@echo "[Step 9/9] Final Export..."
	@style_guide='{"theme":"$(SLIDEV_THEME)","font":"$(FONT)","backgroundColor":"$(BACKGROUND_COLOR)"}'; \
	prompt="$$(sed -e 's|{{SLIDE_DRAFTS}}|$(DRAFTS_OUT)|g' -e 's|{{VISUAL_DESIGNS}}|$(VISUALS_OUT)|g' -e 's|{{EXECUTIVE_REVIEW}}|$(REVIEW_OUT)|g' -e "s|{{STYLE_GUIDE}}|$$style_guide|g" $<)"; \
	claude $(CLAUDE_FLAGS) -p "$$prompt" > $(LOG_DIR)/09_Final_Export.json
	@if [ -f "$(EXPORT_OUT)" ]; then echo "[Step 9/9] Complete. Final manifest at $(EXPORT_OUT)"; else echo "[Step 9/9] Warning: $(EXPORT_OUT) not found."; fi
