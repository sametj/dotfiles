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

# Neovim in /opt (Linux install)
path_add "/opt/nvim/bin"

# User bins
path_add "$HOME/.local/bin"
path_add "$HOME/bin"

# .NET
export DOTNET_ROOT="$HOME/.dotnet"
path_add "$DOTNET_ROOT"

# Editors
export EDITOR="nvim"
export VISUAL="nvim"
