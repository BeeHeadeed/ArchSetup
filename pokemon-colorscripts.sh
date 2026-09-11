#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLORSCRIPTS_DIR="${SCRIPT_DIR}/colorscripts"
JSON_FILE="${SCRIPT_DIR}/pokemon.json"

REGULAR_SUBDIR="regular"
SHINY_SUBDIR="shiny"
LARGE_SUBDIR="large"
SMALL_SUBDIR="small"

# Default flags
SHOW_TITLE=true
SHINY=false
IS_LARGE=false
FORM=""
NAME=""
RANDOM_GEN=""
LIST_ALL=false

# Generation ranges (Start End)
get_gen_range() {
  case "$1" in
    1) echo "1 151" ;;
    2) echo "152 251" ;;
    3) echo "252 386" ;;
    4) echo "387 493" ;;
    5) echo "494 649" ;;
    6) echo "650 721" ;;
    7) echo "722 809" ;;
    8) echo "810 898" ;;
    *) echo "" ;;
  esac
}

show_help() {
  cat << EOF
pokemon-colorscripts [OPTION] [POKEMON NAME]

CLI utility to print out unicode image of a pokemon in your shell

Options:
  -h, --help        Show this help message and exit
  -l, --list        Print list of all pokemon
  -n, --name NAME   Select pokemon by name
  -f, --form FORM   Show an alternate form of a pokemon
  --no-title        Do not display pokemon name
  -s, --shiny       Show the shiny version of the pokemon
  -b, --big         Show a larger version of the sprite
  -r, --random [G]  Show a random pokemon (e.g. 1-8, 1,3,6, or 2)
EOF
}

list_pokemon_names() {
  jq -r '.[].name' "${JSON_FILE}"
}

show_pokemon_by_name() {
  local target_name="$1"
  local size_subdir="$SMALL_SUBDIR"
  local color_subdir="$REGULAR_SUBDIR"
  
  [[ "${IS_LARGE}" == true ]] && size_subdir="$LARGE_SUBDIR"
  [[ "${SHINY}" == true ]] && color_subdir="$SHINY_SUBDIR"

  # Check if Pokemon exists
  local exists
  exists=$(jq -r --arg n "${target_name}" '.[] | select(.name == $n) | .name' "${JSON_FILE}")
  if [[ -z "${exists}" ]]; then
    echo "Invalid pokemon ${target_name}" >&2
    exit 1
  fi

  # Handle forms
  if [[ -n "${FORM}" ]]; then
    local alternate_forms
    alternate_forms=$(jq -r --arg n "${target_name}" '.[] | select(.name == $n) | .forms[] | select(. != "regular")' "${JSON_FILE}")
    
    if echo "${alternate_forms}" | grep -q "^${FORM}$"; then
      target_name="${target_name}-${FORM}"
    else
      echo "Invalid form '${FORM}' for pokemon ${target_name}" >&2
      if [[ -z "${alternate_forms}" ]]; then
        echo "No alternate forms available for ${target_name}" >&2
      else
        echo "Available alternate forms are:" >&2
        echo "${alternate_forms}" | sed 's/^/- /' >&2
      fi
      exit 1
    fi
  fi

  local file_path="${COLORSCRIPTS_DIR}/${size_subdir}/${color_subdir}/${target_name}.ans"
  
  if [[ ! -f "${file_path}" ]]; then
    echo "Sprite file not found: ${file_path}" >&2
    exit 1
  fi

  if [[ "${SHOW_TITLE}" == true ]]; then
    if [[ "${SHINY}" == true ]]; then
      echo "${target_name} (shiny)"
    else
      echo "${target_name}"
    fi
  fi

  cat "${file_path}"
}

show_random_pokemon() {
  local gens="$1"
  local selected_gen=""

  if [[ "${gens}" == *","* ]]; then
    IFS=',' read -ra GEN_LIST <<< "${gens}"
    selected_gen="${GEN_LIST[$((RANDOM % ${#GEN_LIST[@]}))]}"
    start_gen="${selected_gen}"
    end_gen="${selected_gen}"
  elif [[ "${gens}" == *"-"* ]]; then
    IFS='-' read -r start_gen end_gen <<< "${gens}"
  else
    start_gen="${gens}"
    end_gen="${gens}"
  fi

  local start_range end_range
  read -r start_range _ <<< "$(get_gen_range "${start_gen}")"
  read -r _ end_range <<< "$(get_gen_range "${end_gen}")"

  if [[ -z "${start_range}" || -z "${end_range}" ]]; then
    echo "Invalid generation '${gens}'" >&2
    exit 1
  fi

  local total_in_range=$((end_range - start_range + 1))
  local random_idx=$((start_range + (RANDOM % total_in_range) - 1))

  local selected_pokemon
  selected_pokemon=$(jq -r ".[${random_idx}].name" "${JSON_FILE}")

  # 1/25 chance for shiny if flag not passed
  if [[ "${SHINY}" == false ]]; then
    if [[ $((RANDOM % 25)) -eq 0 ]]; then
      SHINY=true
    fi
  fi

  show_pokemon_by_name "${selected_pokemon}"
}

# Parse Command-Line Arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    -l|--list) LIST_ALL=true; shift ;;
    -n|--name) NAME="$2"; shift 2 ;;
    -f|--form) FORM="$2"; shift 2 ;;
    --no-title) SHOW_TITLE=false; shift ;;
    -s|--shiny) SHINY=true; shift ;;
    -b|--big) IS_LARGE=true; shift ;;
    -r|--random)
      if [[ "${2:-}" != "" && ! "${2:-}" =~ ^- ]]; then
        RANDOM_GEN="$2"
        shift 2
      else
        RANDOM_GEN="1-8"
        shift
      fi
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Execution Logic
if [[ "${LIST_ALL}" == true ]]; then
  list_pokemon_names
elif [[ -n "${NAME}" ]]; then
  show_pokemon_by_name "${NAME}"
elif [[ -n "${RANDOM_GEN}" ]]; then
  if [[ -n "${FORM}" ]]; then
    echo "--form flag unexpected with --random" >&2
    exit 1
  fi
  show_random_pokemon "${RANDOM_GEN}"
else
  show_help
fi