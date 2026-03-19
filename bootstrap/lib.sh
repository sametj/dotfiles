#!/usr/bin/env bash
set -euo pipefail

log()  { printf "\n\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m!!\033[0m %s\n" "$*"; }
die()  { printf "\n\033[1;31mxx\033[0m %s\n" "$*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }
has_cmd()  { command -v "$1" >/dev/null 2>&1; }

retry() {
  local attempts="$1" delay="$2"; shift 2
  local i
  for ((i = 1; i <= attempts; i++)); do
    if "$@"; then return 0; fi
    if (( i < attempts )); then
      warn "Command failed (attempt ${i}/${attempts}); retrying in ${delay}s: $*"
      sleep "$delay"
    fi
  done
  return 1
}

is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }

detect_platform() {
  case "$(uname -s)" in
    Darwin) PLATFORM="macos" ;;
    Linux)  is_wsl && PLATFORM="wsl" || PLATFORM="linux" ;;
    *)      PLATFORM="unknown" ;;
  esac
  export PLATFORM
}

ensure_supported_platform() {
  detect_platform
  case "$PLATFORM" in
    macos|linux|wsl) log "Detected platform: $PLATFORM" ;;
    *) die "Unsupported platform: $(uname -s)" ;;
  esac
}

ensure_sudo() { need_cmd sudo; sudo -v; }
ensure_apt()  { has_cmd apt || die "apt not found. This step requires Debian/Ubuntu."; }

ensure_brew() {
  if has_cmd brew; then return; fi
  log "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  setup_brew_shellenv
  has_cmd brew || die "Homebrew installation completed, but brew is still not available in PATH."
}

setup_brew_shellenv() {
  if   [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew    ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi
}

repo_root() { cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd; }
app_dir()   { printf '%s/apps/%s\n' "$(repo_root)" "$1"; }

# ── Stow helpers ──────────────────────────────────────────────────────────────

ensure_stow() {
  if has_cmd stow; then return; fi
  log "Installing stow..."
  case "${PLATFORM:-}" in
    macos)     pkg_install stow ;;
    linux|wsl) ensure_sudo; ensure_apt; sudo apt-get install -y stow ;;
    *) die "Cannot install stow: unsupported platform" ;;
  esac
}

stow_app() {
  # stow_app <app> [--delete|--restow]
  local app="$1"
  local action="${2:---restow}"
  local root; root="$(repo_root)"
  local app_files="$root/apps/$app/files"

  [[ -d "$app_files" ]] || die "App files directory not found: $app_files"

  ensure_stow

  log "Stowing app: $app ($action)"
  # --dir points at apps/<app> so stow sees "files" as the package
  # --dotfiles renames dot-foo -> .foo on link
  stow \
    --dir="$root/apps/$app" \
    --target="$HOME" \
    --dotfiles \
    "$action" \
    files
}

unstow_app() { stow_app "$1" --delete; }

# Backward-compatible aliases — tasks not yet updated still work
link_app_files() { stow_app "$1"; }
stow_package()   { stow_app "$1"; }

# ── Package management ────────────────────────────────────────────────────────

pkg_update() {
  case "${PLATFORM:-}" in
    macos)     setup_brew_shellenv; brew update ;;
    linux|wsl) ensure_sudo; ensure_apt; sudo apt-get update -y ;;
    *) die "pkg_update called before platform was initialized" ;;
  esac
}

pkg_install() {
  case "${PLATFORM:-}" in
    macos)     setup_brew_shellenv; brew install "$@" ;;
    linux|wsl) ensure_sudo; ensure_apt; sudo apt-get install -y "$@" ;;
    *) die "pkg_install called before platform was initialized" ;;
  esac
}

pkg_install_cask() {
  case "${PLATFORM:-}" in
    macos) setup_brew_shellenv; brew install --cask "$@" ;;
    *) die "pkg_install_cask is only supported on macOS" ;;
  esac
}

manifest_field() {
  local manifest_path="$1" field_name="$2"
  awk -F': ' -v key="$field_name" '$1 == key { print substr($0, index($0, $2)); exit }' "$manifest_path"
}
