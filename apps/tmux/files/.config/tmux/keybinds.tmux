# Vi copy mode
setw -g mode-keys vi

# Reload config
unbind r
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Pane navigation (vim-style)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
