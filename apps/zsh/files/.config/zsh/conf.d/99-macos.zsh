# ------------------------------
# macOS-specific config
# ------------------------------
if [[ "$(uname)" != "Darwin" ]]; then return; fi

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
