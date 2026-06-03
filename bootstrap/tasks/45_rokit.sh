#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

# Installs Rokit — the community successor to Aftman (which is archived).
# Rokit is drop-in compatible with aftman.toml / foreman.toml.
# https://github.com/rojo-rbx/rokit

rokit_task() {
  ensure_supported_platform

  log "[rokit] Installing Rokit (Roblox toolchain manager)..."

  if has_cmd rokit; then
    log "[rokit] Already installed: $(command -v rokit)"
    return 0
  fi

  need_cmd curl

  case "$PLATFORM" in
    macos|linux|wsl)
      log "[rokit] Running installer script..."
      curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash
      ;;
    *)
      die "[rokit] Unsupported platform: $PLATFORM"
      ;;
  esac

  export PATH="$HOME/.rokit/bin:$PATH"

  has_cmd rokit || die "[rokit] rokit not found after install. Ensure ~/.rokit/bin is in PATH."

  log "[rokit] Installed: $(rokit --version)"
  log "[rokit] Done. Restart your shell or ensure ~/.rokit/bin is in PATH."
}

rokit_task "$@"
