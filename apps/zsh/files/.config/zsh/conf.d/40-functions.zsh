# ------------------------------
# Functions
# ------------------------------
nr() {
  if [[ -z "${1:-}" ]]; then
    echo "Usage: nr <npm-script> [args...]"
    return 1
  fi
  local script="$1"
  shift
  npm run "$script" -- "$@" && clear
}

brain-project() {
  local dir
  dir="$(command brain-project "$@")" || return 1
  [[ -d "$dir" ]] && cd "$dir" && nvim index.md
}
