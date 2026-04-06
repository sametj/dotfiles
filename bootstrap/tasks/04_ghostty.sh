#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

ghostty_task() {
  ensure_supported_platform

  case "${PLATFORM:-}" in
    macos)
      if has_cmd ghostty; then
        log "[ghostty] Already installed: $(command -v ghostty)"
      else
        log "[ghostty] Installing Ghostty..."
        pkg_install_cask ghostty
      fi
      ;;
    linux|wsl)
      if has_cmd ghostty; then
        log "[ghostty] Already installed: $(command -v ghostty)"
      else
        warn "[ghostty] Ghostty is not available via apt. Install manually from https://ghostty.org"
      fi
      ;;
  esac

  stow_app "ghostty"
  log "[ghostty] Done."
}

ghostty_task "$@"
