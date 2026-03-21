#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_starship() {
  if has_cmd starship; then
    log "[zsh] starship already installed: $(command -v starship)"
    return
  fi

  case "${PLATFORM:-}" in
  macos)
    log "[zsh] Installing starship via Homebrew..."
    pkg_install starship
    ;;
  linux | wsl)
    log "[zsh] Installing starship..."
    if sudo apt-get install -y starship 2>/dev/null; then
      log "[zsh] starship installed via apt"
    else
      warn "[zsh] starship not available via apt; using official install script"
      need_cmd curl
      retry 3 2 sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    fi
    ;;
  *)
    die "[zsh] Unsupported platform for starship install: ${PLATFORM:-unset}"
    ;;
  esac
}

install_zsh_vi_mode_linux() {
  if [[ -d "$HOME/.zsh-vi-mode" ]]; then
    log "[zsh] zsh-vi-mode already installed."
    return
  fi
  log "[zsh] Installing zsh-vi-mode..."
  git clone https://github.com/jeffreytse/zsh-vi-mode.git "$HOME/.zsh-vi-mode"
}

install_zsh_plugins() {
  case "${PLATFORM:-}" in
  macos)
    # installed via 01_packages.sh (brew)
    log "[zsh] zsh plugins installed via Homebrew."
    ;;
  linux | wsl)
    install_zsh_vi_mode_linux
    ;;
  esac
}

symlink_zshrc() {
  log "[zsh] Linking zsh app files"
  stow_app "zsh"
}

set_default_shell_zsh() {
  if has_cmd zsh; then
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
      log "[zsh] Setting default shell to zsh ($zsh_path)..."
      chsh -s "$zsh_path" || warn "[zsh] chsh failed (not fatal)."
    else
      log "[zsh] Default shell already zsh."
    fi
  fi
}

main() {
  ensure_supported_platform

  log "[zsh] Configuring zsh + starship + plugins..."

  has_cmd zsh  || die "[zsh] zsh is required but not installed."
  has_cmd git  || die "[zsh] git is required but not installed."
  has_cmd curl || die "[zsh] curl is required but not installed."

  install_starship
  install_zsh_plugins
  symlink_zshrc
  set_default_shell_zsh

  log "[zsh] Done. Restart your terminal or run: exec zsh"
}

main "$@"
