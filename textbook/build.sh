#!/usr/bin/env bash
set -euo pipefail

DEFAULT_TEX_FILE="week3_zksnark_notes.tex"
LATEX_RUNS=2

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'USAGE'
Usage: ./build.sh [--keep-aux] [tex-file]

Build the Week 3 LaTeX notes with LuaLaTeX.

Options:
  --keep-aux   Keep LaTeX auxiliary files for debugging.
  -h, --help   Show this help.

If tex-file is omitted, week3_zksnark_notes.tex is used.
USAGE
}

resolve_script_dir() {
  local source_dir
  source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  printf '%s\n' "$source_dir"
}

resolve_tex_path() {
  local script_dir="$1"
  local tex_file="$2"

  if [[ "$tex_file" = /* ]]; then
    printf '%s\n' "$tex_file"
  else
    printf '%s/%s\n' "$script_dir" "$tex_file"
  fi
}

run_lualatex() {
  local script_dir="$1"
  local tex_path="$2"

  lualatex \
    -interaction=nonstopmode \
    -halt-on-error \
    -output-directory="$script_dir" \
    "$tex_path"
}

cleanup_auxiliary_files() {
  local script_dir="$1"
  local job_name="$2"
  local extension

  for extension in aux log out toc; do
    rm -f "$script_dir/$job_name.$extension"
  done
}

main() {
  local keep_aux="false"
  local tex_file="$DEFAULT_TEX_FILE"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --keep-aux)
        keep_aux="true"
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *.tex)
        tex_file="$1"
        ;;
      *)
        fail "unknown argument: $1"
        ;;
    esac
    shift
  done

  command -v lualatex >/dev/null 2>&1 || fail "lualatex is not installed"

  local script_dir
  script_dir="$(resolve_script_dir)"

  local tex_path
  tex_path="$(resolve_tex_path "$script_dir" "$tex_file")"

  [[ -f "$tex_path" ]] || fail "TeX file not found: $tex_path"

  local tex_basename
  tex_basename="$(basename "$tex_path")"

  local job_name
  job_name="${tex_basename%.tex}"

  local run
  for ((run = 1; run <= LATEX_RUNS; run++)); do
    printf 'LuaLaTeX pass %d/%d: %s\n' "$run" "$LATEX_RUNS" "$tex_basename"
    run_lualatex "$script_dir" "$tex_path"
  done

  if [[ "$keep_aux" != "true" ]]; then
    cleanup_auxiliary_files "$script_dir" "$job_name"
  fi

  printf 'Built %s/%s.pdf\n' "$script_dir" "$job_name"
}

main "$@"
