# ------------------------------
# Aliases
# ------------------------------
alias clr='clear'
alias cls='clear && ls'

# tmux
alias tl='tmux ls'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias tx='tmuxinator start'

# ls replacement
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -la --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons --group-directories-first'
  alias ll='exa -la'
  alias lt='exa --tree --level=2'
else
  alias ll='ls -lah'
fi
# git
command -v lazygit >/dev/null 2>&1 && alias lzg='lazygit'

# bat
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=plain --paging=never'
fi

# nvim dotfiles sync
alias nvim-sync='stow --dir ~/.dotfiles/apps/nvim --target ~ --dotfiles --no-folding --restow files'
