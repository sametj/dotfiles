#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

mise_task() {
  ensure_supported_platform

  log "[mise] Installing mise (runtime version manager)..."

  if ! has_cmd mise; then
    need_cmd curl
    log "[mise] Downloading and running mise installer..."
    curl https://mise.run | sh
  else
    log "[mise] mise already installed: $(command -v mise)"
  fi

  # Ensure mise is on PATH for this session
  export PATH="$HOME/.local/bin:$PATH"

  has_cmd mise || die "[mise] mise not found after install. Ensure $HOME/.local/bin is in PATH."

  log "[mise] Linking mise config (~/.config/mise/config.toml)..."
  stow_app "mise"

  log "[mise] Installing tools from config..."
  mise install --yes

  # Enable pnpm via corepack (bundled with Node)
  if mise exec node -- corepack >/dev/null 2>&1; then
    log "[mise] Enabling corepack + pnpm..."
    mise exec node -- corepack enable
    mise exec node -- corepack prepare pnpm@latest --activate \
      2>/dev/null || warn "[mise] corepack prepare pnpm failed (not fatal)"
  else
    warn "[mise] corepack not available; skipping pnpm setup."
  fi

  log "[mise] Tools installed:"
  mise list || true
  log "[mise] Done. Restart your shell or run: eval \"\$(mise activate zsh)\""
}

mise_task "$@"
