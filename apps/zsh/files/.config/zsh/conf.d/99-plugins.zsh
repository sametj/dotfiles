# ------------------------------
# zsh-vi-mode (must load before syntax highlighting)
# ------------------------------
if command -v brew >/dev/null 2>&1; then
  [[ -f "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]] && \
    source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi
# Linux: cloned by bootstrap/tasks/15_zsh.sh
[[ -f "$HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]] && \
  source "$HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# ------------------------------
# zsh-syntax-highlighting (MUST be sourced last)
# ------------------------------
if command -v brew >/dev/null 2>&1; then
  [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
