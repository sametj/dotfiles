#!/usr/bin/env bash
set -euo pipefail
echo "==> macOS bootstrap"

# Xcode CLI tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode CLI tools..."
  xcode-select --install
  echo "    Re-run this script after the installer finishes."
  exit 0
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Clone dotfiles if not already here
DOTFILES="$HOME/.dotfiles"
if [[ ! -d "$DOTFILES" ]]; then
  echo "==> Cloning dotfiles..."
  git clone https://github.com/sametj/dotfiles-2026.git "$DOTFILES"
fi

echo "==> Running bootstrap tasks..."
bash "$DOTFILES/bootstrap/install.sh"
