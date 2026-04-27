#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

# win32yank enables clipboard passthrough between Neovim (WSL) and Windows
install_win32yank() {
  if command -v win32yank.exe >/dev/null 2>&1; then
    log "[wt] win32yank already installed: $(command -v win32yank.exe)"
    return
  fi

  need_cmd curl
  need_cmd unzip

  log "[wt] Installing win32yank (clipboard bridge for WSL)..."

  local arch
  arch="$(uname -m)"
  local url
  case "$arch" in
    x86_64 | amd64)
      url="https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip"
      ;;
    aarch64 | arm64)
      # arm64 build may not be available; fall back to x64 via emulation
      url="https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip"
      warn "[wt] arm64 WSL: using x64 win32yank (relies on Windows x64 emulation)"
      ;;
    *)
      warn "[wt] Unsupported arch for win32yank: $arch — skipping."
      return 0
      ;;
  esac

  local tmp_zip="/tmp/win32yank.zip"
  local tmp_dir="/tmp/win32yank-extract"

  curl -fsSL "$url" -o "$tmp_zip"
  mkdir -p "$tmp_dir"
  unzip -o "$tmp_zip" -d "$tmp_dir"

  mkdir -p "$HOME/.local/bin"
  cp "$tmp_dir/win32yank.exe" "$HOME/.local/bin/win32yank.exe"
  chmod +x "$HOME/.local/bin/win32yank.exe"

  rm -rf "$tmp_zip" "$tmp_dir"
  log "[wt] win32yank installed to $HOME/.local/bin/win32yank.exe"
}

install_wt_settings() {
  local root
  root="$(repo_root)"
  local our_settings="$root/apps/wt/settings.json"

  if [[ ! -f "$our_settings" ]]; then
    warn "[wt] apps/wt/settings.json not found — skipping Windows Terminal config."
    return 0
  fi

  # Locate Windows Terminal settings.json from WSL
  local wt_settings=""
  local -a candidates=(
    "/mnt/c/Users/*/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    "/mnt/c/Users/*/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
  )

  local pattern
  for pattern in "${candidates[@]}"; do
    for f in $pattern; do
      [[ -f "$f" ]] && wt_settings="$f" && break
    done
    [[ -n "$wt_settings" ]] && break
  done

  if [[ -z "$wt_settings" ]]; then
    warn "[wt] Windows Terminal settings.json not found — is Windows Terminal installed?"
    warn "[wt] Copy apps/wt/settings.json manually to:"
    warn "[wt]   %LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json"
    return 0
  fi

  log "[wt] Found Windows Terminal settings at: $wt_settings"

  local sentinel="$HOME/.local/share/dotfiles/wt-settings-installed"
  if [[ -f "$sentinel" ]]; then
    log "[wt] Windows Terminal settings already installed — skipping (delete $sentinel to force reinstall)."
    return 0
  fi

  # Back up existing settings
  local backup="${wt_settings}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$wt_settings" "$backup"
  log "[wt] Backed up existing settings to: $backup"

  cp "$our_settings" "$wt_settings"

  mkdir -p "$(dirname "$sentinel")"
  touch "$sentinel"

  log "[wt] Installed Windows Terminal settings."
  log "[wt] Restart Windows Terminal to apply changes."
}

wt_task() {
  ensure_supported_platform

  if [[ "${PLATFORM:-}" != "wsl" ]]; then
    log "[wt] Not WSL — skipping Windows Terminal setup."
    return 0
  fi

  log "[wt] Setting up WSL ↔ Windows Terminal integration..."

  install_win32yank
  install_wt_settings

  log "[wt] Done."
}

wt_task "$@"
