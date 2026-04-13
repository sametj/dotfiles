# ------------------------------
# Linux / WSL-specific config
# ------------------------------
if [[ "$(uname)" != "Linux" ]]; then return; fi

if grep -qi microsoft /proc/version 2>/dev/null; then
  # ── WSL ──────────────────────────────────────────────
  export BROWSER="wslview"

  # Windows home directory
  WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
  export WIN_HOME="/mnt/c/Users/$WIN_USER"

  # Clipboard: delegate to win32yank running on the Windows side
  if command -v win32yank.exe >/dev/null 2>&1; then
    export CLIP_COPY="win32yank.exe -i --crlf"
    export CLIP_PASTE="win32yank.exe -o --lf"
  fi
fi
