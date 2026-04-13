#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

NERD_FONT="JetBrainsMono"

fonts_task() {
  ensure_supported_platform

  case "${PLATFORM:-}" in
  macos)
    ensure_brew
    setup_brew_shellenv
    log "[fonts] Installing JetBrainsMono Nerd Font via Homebrew..."
    brew install --cask font-jetbrains-mono-nerd-font \
      || warn "[fonts] Font cask install failed (not fatal)"
    ;;

  wsl)
    log "[fonts] WSL detected — fonts must be installed on the Windows side."
    log "[fonts] Download JetBrainsMono Nerd Font from:"
    log "[fonts]   https://github.com/ryanoasis/nerd-fonts/releases/latest"
    log "[fonts] Install the .ttf files in Windows, then select the font in Windows Terminal."
    ;;

  linux)
    need_cmd curl
    need_cmd unzip
    need_cmd fc-cache

    local font_dir="$HOME/.local/share/fonts/${NERD_FONT}NerdFont"
    mkdir -p "$font_dir"

    log "[fonts] Fetching latest Nerd Fonts release..."
    local version
    version="$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
      | sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
    [[ -n "$version" ]] || { warn "[fonts] Could not fetch Nerd Fonts version; skipping."; return 0; }

    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${NERD_FONT}.zip"
    local tmp="/tmp/${NERD_FONT}-nerd-font.zip"

    log "[fonts] Downloading ${NERD_FONT} Nerd Font ${version}..."
    curl -fL -o "$tmp" "$url"
    unzip -o "$tmp" -d "$font_dir" '*.ttf'
    fc-cache -f "$font_dir"
    rm -f "$tmp"
    log "[fonts] Fonts installed to $font_dir"
    ;;

  *)
    warn "[fonts] Unsupported platform: ${PLATFORM:-unset}; skipping fonts."
    ;;
  esac

  log "[fonts] Done."
}

fonts_task "$@"
