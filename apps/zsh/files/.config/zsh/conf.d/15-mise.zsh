# ------------------------------
# mise — runtime version manager
# Replaces nvm / pyenv / etc.
# ------------------------------
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
