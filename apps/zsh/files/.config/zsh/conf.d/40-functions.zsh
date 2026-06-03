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

roblox-dev() {
  local socket="/tmp/nvim-roblox.sock"
  local bridge="$HOME/.config/nvim/lua/plugins/lsp/luau-bridge.py"
  local port="${1:-21121}"

  # Open the bridge in a new tmux window
  tmux new-window -n "luau-bridge" \
    "python3 '$bridge' --port '$port' --nvim-socket '$socket'; echo '[bridge] exited'; read"

  echo "==> Starting Neovim (socket: $socket)..."
  NVIM_LISTEN_ADDRESS="$socket" nvim "${@:2}"

  # Kill the bridge window when Neovim exits
  tmux kill-window -t "luau-bridge" 2>/dev/null
}

stow-app() {
  local app="${1:?Usage: stow-app <app>}"
  stow --dir="$HOME/.dotfiles/apps/$app" --target="$HOME" --dotfiles --no-folding -R files
}

brain-project() {
  local dir
  dir="$(command brain-project "$@")" || return 1
  [[ -d "$dir" ]] && cd "$dir" && nvim index.md
}
