# ------------------------------
# Linux / WSL-specific config
# ------------------------------
if [[ "$(uname)" != "Linux" ]]; then return; fi

# WSL: open URLs in Windows browser
if grep -qi microsoft /proc/version 2>/dev/null; then
  export BROWSER="wslview"

  # Access Windows home drive
  WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
  export WIN_HOME="/mnt/c/Users/$WIN_USER"
fi
