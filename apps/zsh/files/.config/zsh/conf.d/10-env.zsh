# ------------------------------
# Environment / PATH
# ------------------------------
export LANG="en_US.UTF-8"
export COLORTERM=truecolor
export DISABLE_AUTO_TITLE="true"

path_add() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# User bins (mise installs here too)
path_add "$HOME/.local/bin"
path_add "$HOME/bin"

# Neovim at /opt/nvim (Linux binary install)
path_add "/opt/nvim/bin"

# .NET
export DOTNET_ROOT="$HOME/.dotnet"
path_add "$HOME/.dotnet"
path_add "$HOME/.dotnet/tools"

# pnpm (XDG-compliant, cross-platform)
export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
path_add "$PNPM_HOME"

# Editors
export EDITOR="nvim"
export VISUAL="nvim"
